"""
AutoCAD MCP Server for Google Antigravity
Provides live AutoCAD COM automation, drawing tools, BOM/quantity takeoff,
Layer/Block/Dimension management, AutoLISP execution, and offline DXF tools.
"""

from __future__ import annotations

import array
import csv
import json
import math
import os
import sys
import time
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

import ezdxf
import pythoncom
import pywintypes
import win32com.client
from mcp.server.fastmcp import FastMCP

mcp = FastMCP(
    "civil3d-infraworks",
    instructions=(
        "AutoCAD, Civil 3D and InfraWorks MCP Server enabling direct 2D/3D drawing, "
        "layer/block/dimension management, BOM/quantity takeoff, AutoLISP execution via Windows COM, "
        "Civil 3D surfaces/alignments/profiles query, and InfraWorks 3D model bridging."
    ),
)


# ============================================================================
# COM Helper Functions
# ============================================================================


_ACAD_CACHE: Any = None


def _com_retry(func: Any, *args: Any, retries: int = 12, delay: float = 0.2, **kwargs: Any) -> Any:
    """Retry a COM call if AutoCAD temporarily rejects the call while busy (-2147418111)."""
    for attempt in range(retries):
        try:
            return func(*args, **kwargs)
        except (pywintypes.com_error, AttributeError) as e:
            if attempt < retries - 1:
                time.sleep(delay * (attempt + 1))
                continue
            raise


class _ComProxy:
    """Transparent COM wrapper that automatically retries calls rejected while AutoCAD is busy."""

    def __init__(self, obj: Any) -> None:
        object.__setattr__(self, "_obj", obj)

    def __call__(self, *args: Any, **kwargs: Any) -> Any:
        raw_obj = object.__getattribute__(self, "_obj")
        res = _com_retry(raw_obj, *args, **kwargs)
        if hasattr(res, "_oleobj_"):
            return _ComProxy(res)
        return res

    def __getattr__(self, name: str) -> Any:
        val = _com_retry(getattr, object.__getattribute__(self, "_obj"), name)
        if hasattr(val, "_oleobj_"):
            return _ComProxy(val)
        if callable(val):
            def _wrapped(*args: Any, **kwargs: Any) -> Any:
                res = _com_retry(val, *args, **kwargs)
                if hasattr(res, "_oleobj_"):
                    return _ComProxy(res)
                return res
            return _wrapped
        return val

    def __setattr__(self, name: str, value: Any) -> None:
        _com_retry(setattr, object.__getattribute__(self, "_obj"), name, value)

    def __iter__(self) -> Any:
        for item in _com_retry(lambda: list(object.__getattribute__(self, "_obj"))):
            yield _ComProxy(item) if hasattr(item, "_oleobj_") else item


def _unwrap_com(obj: Any) -> Any:
    """Extract raw pywin32 COM object if wrapped in _ComProxy."""
    if isinstance(obj, _ComProxy):
        return object.__getattribute__(obj, "_obj")
    return obj


def _get_acad(launch_if_needed: bool = True, target_version: str | None = None) -> Any:
    """Initialize COM on the current thread and return the cached AutoCAD.Application proxy.
    Supports all AutoCAD versions: 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027.
    """
    global _ACAD_CACHE
    pythoncom.CoInitialize()
    if _ACAD_CACHE is not None:
        try:
            _ = _ACAD_CACHE.Visible
            return _ACAD_CACHE
        except Exception:
            _ACAD_CACHE = None

    all_prog_ids = [
        "AutoCAD.Application",        # Active / Default instance
        "AutoCAD.Application.26",     # AutoCAD 2027
        "AutoCAD.Application.25",     # AutoCAD 2026 / 2025
        "AutoCAD.Application.24.4",   # AutoCAD 2025
        "AutoCAD.Application.24.3",   # AutoCAD 2024
        "AutoCAD.Application.24.2",   # AutoCAD 2023
        "AutoCAD.Application.24.1",   # AutoCAD 2022
        "AutoCAD.Application.24",     # AutoCAD 2021
        "AutoCAD.Application.23.1",   # AutoCAD 2020
        "AutoCAD.Application.23",     # AutoCAD 2019
        "AutoCAD.Application.22",     # AutoCAD 2018
    ]

    for prog in all_prog_ids:
        try:
            raw = win32com.client.GetActiveObject(prog)
            _ACAD_CACHE = _ComProxy(raw)
            return _ACAD_CACHE
        except Exception:
            continue

    if launch_if_needed:
        for prog in all_prog_ids:
            try:
                raw = win32com.client.Dispatch(prog)
                acad = _ComProxy(raw)
                acad.Visible = True
                _ACAD_CACHE = acad
                return acad
            except Exception:
                continue

    raise RuntimeError("AutoCAD khong dang chay. Vui long mo AutoCAD truoc khi yeu cau Claude thao tac!")


def _get_doc(doc_name: str | None = None) -> tuple[Any, Any]:
    """Return (acad, doc) for the active document or a named open document."""
    acad = _get_acad(launch_if_needed=True)
    if acad.Documents.Count == 0:
        doc = acad.Documents.Add()
    elif doc_name:
        doc = None
        for d in acad.Documents:
            if d.Name.lower() == doc_name.lower():
                doc = d
                break
        if doc is None:
            raise ValueError(f"Document '{doc_name}' is not open in AutoCAD.")
    else:
        doc = acad.ActiveDocument
    return acad, doc


def _pt3d(x: float, y: float, z: float = 0.0) -> Any:
    """Create a 3D double array variant for AutoCAD COM."""
    return win32com.client.VARIANT(
        pythoncom.VT_ARRAY | pythoncom.VT_R8, [float(x), float(y), float(z)]
    )


def _double_array(coords: list[float]) -> Any:
    """Create a flat double array variant for AutoCAD COM (e.g. polylines)."""
    return win32com.client.VARIANT(
        pythoncom.VT_ARRAY | pythoncom.VT_R8, [float(c) for c in coords]
    )


def _obj_array(objects: list[Any]) -> Any:
    """Create a dispatch object array variant for AutoCAD COM (e.g. Hatch loops)."""
    raw_objs = [_unwrap_com(o) for o in objects]
    return win32com.client.VARIANT(
        pythoncom.VT_ARRAY | pythoncom.VT_DISPATCH, raw_objs
    )


def _apply_entity_props(
    entity: Any,
    layer: str | None = None,
    color: int | None = None,
    linetype: str | None = None,
    lineweight: int | None = None,
) -> None:
    """Ensure layer exists if specified, and assign common entity properties."""
    if layer:
        try:
            entity.Document.Layers.Add(layer)
        except Exception:
            pass
        entity.Layer = layer
    if color is not None:
        entity.color = int(color)
    if linetype:
        entity.Linetype = linetype
    if lineweight is not None:
        entity.LineWeight = int(lineweight)


# ============================================================================
# 1. Connection & Document Management Tools
# ============================================================================


@mcp.tool()
def get_autocad_status(target_version: str | None = None) -> dict[str, Any]:
    """Get active AutoCAD application status, version (AutoCAD 2026 / 2027), and open documents."""
    try:
        acad, doc = _get_doc()
        raw_version = str(getattr(acad, "Version", ""))
        caption = str(getattr(acad, "Caption", ""))
        friendly_version = "AutoCAD"
        if raw_version.startswith("26.") or "2027" in caption:
            friendly_version = "AutoCAD 2027"
        elif raw_version.startswith("25.") or "2026" in caption:
            friendly_version = "AutoCAD 2026"
        elif raw_version.startswith("24.4") or "2025" in caption:
            friendly_version = "AutoCAD 2025"
        elif raw_version.startswith("24.3") or "2024" in caption:
            friendly_version = "AutoCAD 2024"
        elif raw_version.startswith("24.2") or "2023" in caption:
            friendly_version = "AutoCAD 2023"
        elif raw_version.startswith("24.1") or "2022" in caption:
            friendly_version = "AutoCAD 2022"
        elif raw_version.startswith("24.") or "2021" in caption:
            friendly_version = "AutoCAD 2021"
        elif raw_version:
            friendly_version = f"AutoCAD (v{raw_version})"

        open_docs = []
        for d in acad.Documents:
            open_docs.append(
                {
                    "name": d.Name,
                    "full_name": d.FullName,
                    "saved": bool(d.Saved),
                    "active": d.Name == doc.Name,
                }
            )
        return {
            "status": "connected",
            "application": acad.Name,
            "version": raw_version,
            "version_name": friendly_version,
            "caption": caption,
            "visible": bool(acad.Visible),
            "active_document": {
                "name": doc.Name,
                "full_name": doc.FullName,
                "active_layer": doc.ActiveLayer.Name,
                "active_space": "ModelSpace" if doc.ActiveSpace == 1 else "PaperSpace",
                "modelspace_entity_count": doc.ModelSpace.Count,
            },
            "open_documents": open_docs,
        }
    except Exception as e:
        return {"status": "error", "error": str(e), "message": "AutoCAD is not currently running or accessible via COM."}


@mcp.tool()
def manage_document(
    action: str,
    file_path: str | None = None,
    zoom_extents: bool = True,
) -> dict[str, Any]:
    """
    Manage AutoCAD documents.
    action: 'new' | 'open' | 'save' | 'save_as' | 'zoom_extents' | 'regen' | 'purge'
    file_path: Required for 'open' and 'save_as' (.dwg or .dxf path).
    """
    acad, doc = _get_doc()
    action = action.lower().strip()

    if action == "new":
        new_doc = acad.Documents.Add()
        return {"action": "new", "document": new_doc.Name}
    elif action == "open":
        if not file_path:
            raise ValueError("file_path is required for action='open'")
        abs_path = str(Path(file_path).resolve())
        opened_doc = acad.Documents.Open(abs_path)
        return {"action": "open", "document": opened_doc.Name, "path": abs_path}
    elif action == "save":
        doc.Save()
        return {"action": "save", "document": doc.Name, "path": doc.FullName}
    elif action == "save_as":
        if not file_path:
            raise ValueError("file_path is required for action='save_as'")
        abs_path = str(Path(file_path).resolve())
        Path(abs_path).parent.mkdir(parents=True, exist_ok=True)
        doc.SaveAs(abs_path)
        return {"action": "save_as", "document": doc.Name, "path": abs_path}
    elif action == "zoom_extents":
        acad.ZoomExtents()
        return {"action": "zoom_extents", "document": doc.Name}
    elif action == "regen":
        doc.Regen(1)  # acAllViewports = 1
        if zoom_extents:
            acad.ZoomExtents()
        return {"action": "regen", "document": doc.Name}
    elif action == "purge":
        doc.PurgeAll()
        return {"action": "purge", "document": doc.Name}
    else:
        raise ValueError(f"Unsupported action: {action}")


# ============================================================================
# 2. Geometric Drawing Tools (Line, Polyline, Rectangle, Circle, Arc, Hatch)
# ============================================================================


@mcp.tool()
def draw_line(
    start_point: list[float],
    end_point: list[float],
    layer: str | None = None,
    color: int | None = None,
) -> dict[str, Any]:
    """
    Draw a Line in AutoCAD ModelSpace.
    start_point: [x, y] or [x, y, z]
    end_point: [x, y] or [x, y, z]
    """
    _, doc = _get_doc()
    p1 = _pt3d(start_point[0], start_point[1], start_point[2] if len(start_point) > 2 else 0.0)
    p2 = _pt3d(end_point[0], end_point[1], end_point[2] if len(end_point) > 2 else 0.0)
    line = doc.ModelSpace.AddLine(p1, p2)
    _apply_entity_props(line, layer=layer, color=color)
    return {
        "handle": line.Handle,
        "type": "AcDbLine",
        "layer": line.Layer,
        "length": round(line.Length, 4),
    }


@mcp.tool()
def draw_lwpolyline(
    points: list[list[float]],
    closed: bool = False,
    layer: str | None = None,
    color: int | None = None,
    constant_width: float | None = None,
) -> dict[str, Any]:
    """
    Draw a 2D Lightweight Polyline (LWPolyline) in AutoCAD ModelSpace.
    points: List of [x, y] coordinate pairs, e.g. [[0, 0], [100, 0], [100, 50], [0, 50]]
    closed: Whether to close the polyline.
    constant_width: Optional global width of the polyline segments.
    """
    if len(points) < 2:
        raise ValueError("At least 2 points are required to draw a polyline.")
    _, doc = _get_doc()
    flat_coords: list[float] = []
    for pt in points:
        flat_coords.extend([float(pt[0]), float(pt[1])])
    pline = doc.ModelSpace.AddLightWeightPolyline(_double_array(flat_coords))
    pline.Closed = bool(closed)
    if constant_width is not None:
        pline.ConstantWidth = float(constant_width)
    _apply_entity_props(pline, layer=layer, color=color)
    res: dict[str, Any] = {
        "handle": pline.Handle,
        "type": "AcDbPolyline",
        "layer": pline.Layer,
        "closed": bool(pline.Closed),
        "length": round(pline.Length, 4),
    }
    if closed:
        try:
            res["area"] = round(pline.Area, 4)
        except Exception:
            pass
    return res


@mcp.tool()
def draw_rectangle(
    corner1: list[float],
    corner2: list[float],
    layer: str | None = None,
    color: int | None = None,
    constant_width: float | None = None,
) -> dict[str, Any]:
    """
    Draw a closed rectangular LWPolyline from two opposite corners [x1, y1] and [x2, y2].
    """
    x1, y1 = float(corner1[0]), float(corner1[1])
    x2, y2 = float(corner2[0]), float(corner2[1])
    pts = [[x1, y1], [x2, y1], [x2, y2], [x1, y2]]
    return draw_lwpolyline(
        points=pts,
        closed=True,
        layer=layer,
        color=color,
        constant_width=constant_width,
    )


@mcp.tool()
def draw_circle(
    center: list[float],
    radius: float,
    layer: str | None = None,
    color: int | None = None,
) -> dict[str, Any]:
    """
    Draw a Circle in AutoCAD ModelSpace.
    center: [x, y] or [x, y, z]
    radius: Circle radius (> 0)
    """
    _, doc = _get_doc()
    c = _pt3d(center[0], center[1], center[2] if len(center) > 2 else 0.0)
    circle = doc.ModelSpace.AddCircle(c, float(radius))
    _apply_entity_props(circle, layer=layer, color=color)
    return {
        "handle": circle.Handle,
        "type": "AcDbCircle",
        "layer": circle.Layer,
        "radius": round(circle.Radius, 4),
        "area": round(circle.Area, 4),
        "circumference": round(circle.Circumference, 4),
    }


@mcp.tool()
def draw_arc(
    center: list[float],
    radius: float,
    start_angle_deg: float,
    end_angle_deg: float,
    layer: str | None = None,
    color: int | None = None,
) -> dict[str, Any]:
    """
    Draw an Arc in AutoCAD ModelSpace.
    center: [x, y] or [x, y, z]
    radius: Arc radius (> 0)
    start_angle_deg: Start angle in degrees (counter-clockwise from positive X-axis)
    end_angle_deg: End angle in degrees
    """
    _, doc = _get_doc()
    c = _pt3d(center[0], center[1], center[2] if len(center) > 2 else 0.0)
    arc = doc.ModelSpace.AddArc(
        c,
        float(radius),
        math.radians(float(start_angle_deg)),
        math.radians(float(end_angle_deg)),
    )
    _apply_entity_props(arc, layer=layer, color=color)
    return {
        "handle": arc.Handle,
        "type": "AcDbArc",
        "layer": arc.Layer,
        "arc_length": round(arc.ArcLength, 4),
    }


@mcp.tool()
def draw_hatch(
    boundary_handle: str,
    pattern_name: str = "ANSI31",
    pattern_scale: float = 1.0,
    pattern_angle_deg: float = 0.0,
    layer: str | None = None,
    color: int | None = None,
) -> dict[str, Any]:
    """
    Create an associative Hatch inside an existing closed entity (e.g., Circle or closed LWPolyline).
    boundary_handle: Entity Handle string returned by draw_circle, draw_rectangle, draw_lwpolyline, etc.
    pattern_name: Standard AutoCAD hatch pattern name (e.g. 'ANSI31', 'SOLID', 'AR-CONC', 'ANSI32').
    """
    _, doc = _get_doc()
    boundary_ent = _com_retry(lambda: doc.HandleToObject(boundary_handle))
    # PatternType: 0 = acHatchPatternTypePreDefined, 1 = acHatchPatternTypeUserDefined
    hatch = _com_retry(lambda: doc.ModelSpace.AddHatch(0, pattern_name, True))
    _com_retry(lambda: hatch.AppendOuterLoop(_obj_array([boundary_ent])))
    if pattern_name.upper() != "SOLID":
        _com_retry(lambda: setattr(hatch, "PatternScale", float(pattern_scale)))
        _com_retry(lambda: setattr(hatch, "PatternAngle", math.radians(float(pattern_angle_deg))))
    _com_retry(lambda: hatch.Evaluate())
    _apply_entity_props(hatch, layer=layer, color=color)
    res: dict[str, Any] = {
        "handle": hatch.Handle,
        "type": "AcDbHatch",
        "pattern": pattern_name,
        "layer": hatch.Layer,
    }
    try:
        res["area"] = round(hatch.Area, 4)
    except Exception:
        pass
    return res


@mcp.tool()
def batch_draw_entities(
    entities: list[dict[str, Any]],
    zoom_extents: bool = True,
) -> dict[str, Any]:
    """
    Draw multiple entities in a single batch call for high speed.
    Each item in 'entities' is a dict with a 'type' field:
      - {'type': 'line', 'start': [x1,y1], 'end': [x2,y2], 'layer': '...', 'color': 1}
      - {'type': 'polyline', 'points': [[x1,y1], [x2,y2], ...], 'closed': True, 'layer': '...'}
      - {'type': 'rectangle', 'corner1': [x1,y1], 'corner2': [x2,y2], 'layer': '...'}
      - {'type': 'circle', 'center': [x,y], 'radius': r, 'layer': '...'}
      - {'type': 'arc', 'center': [x,y], 'radius': r, 'start_angle': 0, 'end_angle': 90, 'layer': '...'}
      - {'type': 'text', 'text': '...', 'position': [x,y], 'height': 2.5, 'layer': '...'}
    """
    acad, doc = _get_doc()
    results = []
    for idx, item in enumerate(entities):
        etype = item.get("type", "").lower()
        layer = item.get("layer")
        color = item.get("color")
        try:
            if etype == "line":
                r = draw_line(item["start"], item["end"], layer=layer, color=color)
            elif etype in ("polyline", "lwpolyline"):
                r = draw_lwpolyline(
                    item["points"],
                    closed=item.get("closed", False),
                    layer=layer,
                    color=color,
                    constant_width=item.get("width"),
                )
            elif etype == "rectangle":
                r = draw_rectangle(
                    item["corner1"],
                    item["corner2"],
                    layer=layer,
                    color=color,
                    constant_width=item.get("width"),
                )
            elif etype == "circle":
                r = draw_circle(item["center"], item["radius"], layer=layer, color=color)
            elif etype == "arc":
                r = draw_arc(
                    item["center"],
                    item["radius"],
                    item["start_angle"],
                    item["end_angle"],
                    layer=layer,
                    color=color,
                )
            elif etype == "text":
                r = add_text(
                    text=item["text"],
                    position=item["position"],
                    height=item.get("height", 2.5),
                    rotation_deg=item.get("rotation", 0.0),
                    layer=layer,
                    color=color,
                )
            else:
                r = {"error": f"Unknown entity type '{etype}' at index {idx}"}
            results.append(r)
        except Exception as e:
            results.append({"error": str(e), "index": idx, "type": etype})

    if zoom_extents:
        try:
            acad.ZoomExtents()
        except Exception:
            pass
    return {"created_count": len(results), "results": results}


# ============================================================================
# 3. Standards Management: Layers, Text/MText, Dimensions, Blocks
# ============================================================================


@mcp.tool()
def manage_layers(
    action: str = "list",
    name: str | None = None,
    color: int = 7,
    linetype: str = "Continuous",
    is_on: bool = True,
    freeze: bool = False,
    lock: bool = False,
    layers_batch: list[dict[str, Any]] | None = None,
) -> dict[str, Any]:
    """
    Manage AutoCAD Layers according to CAD standards.
    action: 'list' | 'create' | 'set_active' | 'batch_create' | 'delete'
    color: AutoCAD Color Index (ACI 1=Red, 2=Yellow, 3=Green, 4=Cyan, 5=Blue, 6=Magenta, 7=White)
    layers_batch: Optional list of layer dicts [{'name': 'A-WALL', 'color': 1, 'linetype': 'Continuous'}, ...]
    """
    _, doc = _get_doc()
    action = action.lower().strip()

    def _ensure_linetype(lt_name: str) -> None:
        if lt_name.lower() == "continuous":
            return
        try:
            _ = doc.Linetypes.Item(lt_name)
        except Exception:
            try:
                doc.Linetypes.Load(lt_name, "acad.lin")
            except Exception:
                pass

    if action == "list":
        layers_info = []
        for lyr in doc.Layers:
            layers_info.append(
                {
                    "name": lyr.Name,
                    "color": lyr.color,
                    "linetype": lyr.Linetype,
                    "is_on": bool(lyr.LayerOn),
                    "freeze": bool(lyr.Freeze),
                    "lock": bool(lyr.Lock),
                    "active": lyr.Name == doc.ActiveLayer.Name,
                }
            )
        return {"count": len(layers_info), "layers": layers_info}

    elif action == "create":
        if not name:
            raise ValueError("Layer 'name' is required for action='create'.")
        _ensure_linetype(linetype)
        lyr = doc.Layers.Add(name)
        lyr.color = int(color)
        try:
            lyr.Linetype = linetype
        except Exception:
            pass
        lyr.LayerOn = bool(is_on)
        if lyr.Name != doc.ActiveLayer.Name:
            lyr.Freeze = bool(freeze)
        lyr.Lock = bool(lock)
        return {"status": "created", "name": lyr.Name, "color": lyr.color, "linetype": lyr.Linetype}

    elif action == "batch_create":
        if not layers_batch:
            raise ValueError("'layers_batch' list is required for action='batch_create'.")
        created = []
        for spec in layers_batch:
            lname = spec["name"]
            lcolor = int(spec.get("color", 7))
            lltype = spec.get("linetype", "Continuous")
            _ensure_linetype(lltype)
            lyr = doc.Layers.Add(lname)
            lyr.color = lcolor
            try:
                lyr.Linetype = lltype
            except Exception:
                pass
            created.append({"name": lyr.Name, "color": lyr.color, "linetype": lyr.Linetype})
        return {"status": "batch_created", "count": len(created), "layers": created}

    elif action == "set_active":
        if not name:
            raise ValueError("Layer 'name' is required for action='set_active'.")
        lyr = doc.Layers.Add(name)
        doc.ActiveLayer = _unwrap_com(lyr)
        return {"status": "active_layer_set", "active_layer": doc.ActiveLayer.Name}

    elif action == "delete":
        if not name:
            raise ValueError("Layer 'name' is required for action='delete'.")
        lyr = doc.Layers.Item(name)
        lyr.Delete()
        return {"status": "deleted", "name": name}

    else:
        raise ValueError(f"Unsupported layer action: {action}")


@mcp.tool()
def add_text(
    text: str,
    position: list[float],
    height: float = 2.5,
    rotation_deg: float = 0.0,
    multiline: bool = False,
    width: float = 100.0,
    layer: str | None = None,
    color: int | None = None,
) -> dict[str, Any]:
    """
    Add single-line Text (AcDbText) or MText (AcDbMText) to ModelSpace.
    """
    _, doc = _get_doc()
    pt = _pt3d(position[0], position[1], position[2] if len(position) > 2 else 0.0)
    if multiline:
        ent = doc.ModelSpace.AddMText(pt, float(width), text)
        ent.Height = float(height)
        ent.Rotation = math.radians(float(rotation_deg))
        etype = "AcDbMText"
    else:
        ent = doc.ModelSpace.AddText(text, pt, float(height))
        ent.Rotation = math.radians(float(rotation_deg))
        etype = "AcDbText"
    _apply_entity_props(ent, layer=layer, color=color)
    return {
        "handle": ent.Handle,
        "type": etype,
        "text": text,
        "layer": ent.Layer,
        "height": float(height),
    }


@mcp.tool()
def add_dimension(
    dim_type: str,
    point1: list[float],
    point2: list[float],
    text_position: list[float],
    rotation_deg: float = 0.0,
    layer: str | None = None,
    color: int | None = None,
) -> dict[str, Any]:
    """
    Add a Dimension in AutoCAD ModelSpace.
    dim_type: 'aligned' | 'rotated' | 'radial' | 'diametric'
    - For 'aligned': point1 = extLine1Point, point2 = extLine2Point, text_position = textLoc
    - For 'rotated': point1 = extLine1Point, point2 = extLine2Point, text_position = textLoc, rotation_deg = angle (0=horizontal, 90=vertical)
    - For 'radial': point1 = center, point2 = chordPoint, text_position = [leaderLength, 0]
    - For 'diametric': point1 = chordPoint, point2 = farChordPoint, text_position = [leaderLength, 0]
    """
    _, doc = _get_doc()
    p1 = _pt3d(point1[0], point1[1], point1[2] if len(point1) > 2 else 0.0)
    p2 = _pt3d(point2[0], point2[1], point2[2] if len(point2) > 2 else 0.0)
    tp = _pt3d(
        text_position[0],
        text_position[1] if len(text_position) > 1 else 0.0,
        text_position[2] if len(text_position) > 2 else 0.0,
    )
    dtype = dim_type.lower().strip()
    if dtype == "aligned":
        dim = doc.ModelSpace.AddDimAligned(p1, p2, tp)
    elif dtype == "rotated":
        dim = doc.ModelSpace.AddDimRotated(p1, p2, tp, math.radians(float(rotation_deg)))
    elif dtype == "radial":
        leader_len = float(text_position[0]) if text_position else 5.0
        dim = doc.ModelSpace.AddDimRadial(p1, p2, leader_len)
    elif dtype == "diametric":
        leader_len = float(text_position[0]) if text_position else 5.0
        dim = doc.ModelSpace.AddDimDiametric(p1, p2, leader_len)
    else:
        raise ValueError(f"Unsupported dim_type: {dim_type}")

    _apply_entity_props(dim, layer=layer, color=color)
    return {
        "handle": dim.Handle,
        "type": dim.ObjectName,
        "layer": dim.Layer,
        "measurement": round(dim.Measurement, 4),
    }


@mcp.tool()
def manage_blocks(
    action: str,
    block_name: str | None = None,
    insertion_point: list[float] | None = None,
    scale_x: float = 1.0,
    scale_y: float = 1.0,
    scale_z: float = 1.0,
    rotation_deg: float = 0.0,
    layer: str | None = None,
    attributes: dict[str, str] | None = None,
    entities_spec: list[dict[str, Any]] | None = None,
    attribute_defs: list[dict[str, Any]] | None = None,
) -> dict[str, Any]:
    """
    Create, list, or insert AutoCAD Blocks (including Block Attributes).
    action: 'list' | 'insert' | 'create_definition'
    - For 'list': lists all non-layout block definitions in the active document.
    - For 'insert': inserts `block_name` at `insertion_point` [x, y] and optionally populates `attributes` dict {TAG: VALUE}.
    - For 'create_definition': creates a new Block definition named `block_name` with base point `insertion_point` (default [0,0,0]),
      adding geometry from `entities_spec` and attribute definitions from `attribute_defs`
      ([{'tag': 'ID', 'prompt': 'Enter ID', 'default': 'B-01', 'position': [0, 0], 'height': 2.5}]).
    """
    _, doc = _get_doc()
    action = action.lower().strip()

    if action == "list":
        blocks = []
        for blk in doc.Blocks:
            if not blk.IsLayout and not blk.Name.startswith("*"):
                blocks.append(
                    {
                        "name": blk.Name,
                        "is_xref": bool(blk.IsXRef),
                        "entity_count": blk.Count,
                    }
                )
        return {"count": len(blocks), "blocks": blocks}

    elif action == "insert":
        if not block_name:
            raise ValueError("'block_name' is required for action='insert'")
        pt_coords = insertion_point or [0.0, 0.0, 0.0]
        pt = _pt3d(pt_coords[0], pt_coords[1], pt_coords[2] if len(pt_coords) > 2 else 0.0)
        bref = doc.ModelSpace.InsertBlock(
            pt,
            block_name,
            float(scale_x),
            float(scale_y),
            float(scale_z),
            math.radians(float(rotation_deg)),
        )
        _apply_entity_props(bref, layer=layer)
        updated_attrs = {}
        if attributes and bref.HasAttributes:
            for att in bref.GetAttributes():
                tag_upper = att.TagString.upper()
                for k, v in attributes.items():
                    if k.upper() == tag_upper:
                        att.TextString = str(v)
                        updated_attrs[att.TagString] = str(v)
        return {
            "handle": bref.Handle,
            "type": "AcDbBlockReference",
            "block_name": bref.EffectiveName if hasattr(bref, "EffectiveName") else bref.Name,
            "layer": bref.Layer,
            "updated_attributes": updated_attrs,
        }

    elif action == "create_definition":
        if not block_name:
            raise ValueError("'block_name' is required for action='create_definition'")
        base_coords = insertion_point or [0.0, 0.0, 0.0]
        base_pt = _pt3d(
            base_coords[0],
            base_coords[1],
            base_coords[2] if len(base_coords) > 2 else 0.0,
        )
        blk_def = doc.Blocks.Add(base_pt, block_name)
        created_items = 0

        for item in entities_spec or []:
            etype = item.get("type", "").lower()
            if etype == "line":
                p1 = _pt3d(item["start"][0], item["start"][1], 0.0)
                p2 = _pt3d(item["end"][0], item["end"][1], 0.0)
                blk_def.AddLine(p1, p2)
                created_items += 1
            elif etype == "circle":
                c = _pt3d(item["center"][0], item["center"][1], 0.0)
                blk_def.AddCircle(c, float(item["radius"]))
                created_items += 1
            elif etype in ("polyline", "lwpolyline", "rectangle"):
                if etype == "rectangle":
                    x1, y1 = float(item["corner1"][0]), float(item["corner1"][1])
                    x2, y2 = float(item["corner2"][0]), float(item["corner2"][1])
                    pts = [[x1, y1], [x2, y1], [x2, y2], [x1, y2]]
                    closed = True
                else:
                    pts = item["points"]
                    closed = bool(item.get("closed", False))
                flat = []
                for p in pts:
                    flat.extend([float(p[0]), float(p[1])])
                pl = blk_def.AddLightWeightPolyline(_double_array(flat))
                pl.Closed = closed
                created_items += 1
            elif etype == "text":
                tp = _pt3d(item["position"][0], item["position"][1], 0.0)
                blk_def.AddText(item["text"], tp, float(item.get("height", 2.5)))
                created_items += 1

        for adef in attribute_defs or []:
            apt = _pt3d(adef["position"][0], adef["position"][1], 0.0)
            height = float(adef.get("height", 2.5))
            # Mode: 0 = acAttributeModeNormal
            blk_def.AddAttribute(
                height,
                0,
                str(adef.get("prompt", adef["tag"])),
                apt,
                str(adef["tag"]).upper(),
                str(adef.get("default", "")),
            )
            created_items += 1

        return {
            "status": "block_definition_created",
            "block_name": blk_def.Name,
            "items_added": created_items,
        }

    else:
        raise ValueError(f"Unsupported block action: {action}")


# ============================================================================
# 4. BOM / Quantity Takeoff & Inspection Tools
# ============================================================================


@mcp.tool()
def extract_bom_and_quantities(
    filter_layer: str | None = None,
    export_csv_path: str | None = None,
) -> dict[str, Any]:
    """
    Scan ModelSpace of the active AutoCAD drawing to perform a full Quantity Takeoff (bóc tách khối lượng)
    and Bill of Materials (BOM) extraction:
      - Total length & closed area by Layer and Entity Type (Lines, Polylines, Arcs, Circles, Hatches)
      - Block Reference counts & Attribute values table (BOM)
      - Text / MText schedule extraction
      - Optional export to CSV file
    """
    _, doc = _get_doc()
    ms = doc.ModelSpace

    type_counts: Counter[str] = Counter()
    layer_summary: dict[str, dict[str, Any]] = defaultdict(
        lambda: {
            "entity_count": 0,
            "total_length": 0.0,
            "total_area": 0.0,
            "types": Counter(),
        }
    )
    block_counts: Counter[str] = Counter()
    block_attributes_bom: list[dict[str, Any]] = []
    texts_extracted: list[dict[str, Any]] = []

    for i in range(ms.Count):
        try:
            ent = ms.Item(i)
            lyr = ent.Layer
            if filter_layer and lyr.lower() != filter_layer.lower():
                continue

            obj_name = ent.ObjectName
            type_counts[obj_name] += 1
            lsum = layer_summary[lyr]
            lsum["entity_count"] += 1
            lsum["types"][obj_name] += 1

            # Length extraction
            if obj_name in ("AcDbLine", "AcDbPolyline", "AcDb2dPolyline", "AcDb3dPolyline"):
                try:
                    lsum["total_length"] += float(ent.Length)
                except Exception:
                    pass
            elif obj_name == "AcDbArc":
                try:
                    lsum["total_length"] += float(ent.ArcLength)
                except Exception:
                    pass
            elif obj_name == "AcDbCircle":
                try:
                    lsum["total_length"] += float(ent.Circumference)
                except Exception:
                    pass

            # Area extraction
            if obj_name in ("AcDbCircle", "AcDbHatch", "AcDbRegion"):
                try:
                    lsum["total_area"] += float(ent.Area)
                except Exception:
                    pass
            elif obj_name in ("AcDbPolyline", "AcDb2dPolyline") and getattr(ent, "Closed", False):
                try:
                    lsum["total_area"] += float(ent.Area)
                except Exception:
                    pass

            # Block References & Attributes
            if obj_name == "AcDbBlockReference":
                bname = getattr(ent, "EffectiveName", None) or ent.Name
                block_counts[bname] += 1
                attrs = {}
                if getattr(ent, "HasAttributes", False):
                    for att in ent.GetAttributes():
                        attrs[att.TagString] = att.TextString
                ins_pt = list(ent.InsertionPoint)
                block_attributes_bom.append(
                    {
                        "handle": ent.Handle,
                        "block_name": bname,
                        "layer": lyr,
                        "x": round(ins_pt[0], 3),
                        "y": round(ins_pt[1], 3),
                        "attributes": attrs,
                    }
                )

            # Text / MText
            elif obj_name in ("AcDbText", "AcDbMText"):
                ins_pt = list(ent.InsertionPoint)
                texts_extracted.append(
                    {
                        "handle": ent.Handle,
                        "type": obj_name,
                        "layer": lyr,
                        "text": ent.TextString,
                        "x": round(ins_pt[0], 3),
                        "y": round(ins_pt[1], 3),
                    }
                )
        except Exception:
            continue

    formatted_layers = {}
    for lyr, data in layer_summary.items():
        formatted_layers[lyr] = {
            "entity_count": data["entity_count"],
            "total_length": round(data["total_length"], 4),
            "total_area": round(data["total_area"], 4),
            "types": dict(data["types"]),
        }

    if export_csv_path:
        csv_path = Path(export_csv_path).resolve()
        csv_path.parent.mkdir(parents=True, exist_ok=True)
        with open(csv_path, "w", newline="", encoding="utf-8-sig") as f:
            writer = csv.writer(f)
            writer.writerow(["SECTION", "LAYER / BLOCK", "METRIC / HANDLE", "VALUE / COUNT", "DETAILS"])
            for lyr, s in formatted_layers.items():
                writer.writerow(
                    [
                        "LAYER_QUANTITY",
                        lyr,
                        f"Entities: {s['entity_count']}",
                        f"Length={s['total_length']} | Area={s['total_area']}",
                        json.dumps(s["types"], ensure_ascii=False),
                    ]
                )
            for bname, cnt in block_counts.items():
                writer.writerow(["BLOCK_SUMMARY", bname, "Count", cnt, ""])
            for bitem in block_attributes_bom:
                writer.writerow(
                    [
                        "BLOCK_INSTANCE",
                        bitem["block_name"],
                        bitem["handle"],
                        f"({bitem['x']}, {bitem['y']})",
                        json.dumps(bitem["attributes"], ensure_ascii=False),
                    ]
                )

    return {
        "document": doc.Name,
        "total_entities_scanned": sum(type_counts.values()),
        "entity_type_counts": dict(type_counts),
        "quantities_by_layer": formatted_layers,
        "block_counts": dict(block_counts),
        "block_instances_sample": block_attributes_bom[:100],
        "texts_sample": texts_extracted[:100],
        "exported_csv": str(Path(export_csv_path).resolve()) if export_csv_path else None,
    }


# ============================================================================
# 5. AutoLISP, Command Script & Plugin Development Tools
# ============================================================================


@mcp.tool()
def execute_command_or_lisp(
    command: str,
    save_lisp_path: str | None = None,
) -> dict[str, Any]:
    """
    Execute an AutoCAD command macro or AutoLISP expression directly in the active drawing via SendCommand.
    - If `save_lisp_path` is provided, writes `command` as an AutoLISP (.lsp) file and loads it into AutoCAD via `(load "...")`.
    - Otherwise sends `command` directly to AutoCAD command line (appending a newline if needed).
    """
    _, doc = _get_doc()
    if save_lisp_path:
        lsp_path = Path(save_lisp_path).resolve()
        lsp_path.parent.mkdir(parents=True, exist_ok=True)
        lsp_path.write_text(command, encoding="utf-8")
        escaped_path = str(lsp_path).replace("\\", "/")
        load_expr = f'(load "{escaped_path}")\n'
        doc.SendCommand(load_expr)
        return {
            "status": "lisp_saved_and_loaded",
            "lisp_file": str(lsp_path),
            "load_command": load_expr.strip(),
        }
    else:
        cmd_str = command if command.endswith("\n") or command.endswith(" ") else command + "\n"
        doc.SendCommand(cmd_str)
        return {
            "status": "command_sent",
            "document": doc.Name,
            "command": command,
        }


# ============================================================================
# 7. Civil 3D & InfraWorks Integration Tools
# ============================================================================


def _get_c3d_apps() -> dict[str, Any]:
    """Return dictionary of available Civil 3D sub-applications (Land, Roadway, Pipe, Survey).
    Checks both Civil 3D 2027 (.13.9) and Civil 3D 2026 (.13.8).
    """
    acad, _ = _get_doc()
    apps: dict[str, Any] = {}
    for ver_suffix in [".13.9", ".13.8", ".13.7", ""]:
        app_mappings = {
            "land": f"AeccXUiLand.AeccApplication{ver_suffix}",
            "roadway": f"AeccXUiRoadway.AeccRoadwayApplication{ver_suffix}",
            "pipe": f"AeccXUiPipe.AeccPipeApplication{ver_suffix}",
            "survey": f"AeccXUiSurvey.AeccSurveyApplication{ver_suffix}",
        }
        for key, prog in app_mappings.items():
            if key not in apps:
                try:
                    raw = acad.GetInterfaceObject(prog)
                    if raw:
                        apps[key] = raw
                except Exception:
                    pass
        if "land" in apps:
            break
    return apps


@mcp.tool()
def get_civil3d_status() -> dict[str, Any]:
    """
    Inspect Civil 3D model data in the active document:
    Surfaces (TIN/Grid), Alignments (Tuyến đường), Corridors, Pipe Networks, Sites, and Cogo Points.
    """
    acad, doc = _get_doc()
    apps = _get_c3d_apps()
    if "land" not in apps:
        return {
            "status": "error",
            "message": "Civil 3D interface (AeccXUiLand.AeccApplication.13.9) not available in current host.",
            "host_application": acad.Caption,
        }

    land_doc = _com_retry(lambda: getattr(apps["land"], "ActiveDocument"))

    # Surfaces
    surfaces_info = []
    try:
        surfaces = _com_retry(lambda: getattr(land_doc, "Surfaces"))
        for s in surfaces:
            try:
                surfaces_info.append(
                    {
                        "name": s.Name,
                        "description": getattr(s, "Description", ""),
                        "type": getattr(s, "Type", "TIN"),
                    }
                )
            except Exception:
                pass
    except Exception:
        pass

    # Alignments
    alignments_info = []
    try:
        alignments = _com_retry(lambda: getattr(land_doc, "AlignmentsSiteless"))
        for al in alignments:
            try:
                alignments_info.append(
                    {
                        "name": al.Name,
                        "length": round(float(getattr(al, "Length", 0.0)), 3),
                        "start_station": round(float(getattr(al, "StartingStation", 0.0)), 3),
                        "end_station": round(float(getattr(al, "EndingStation", 0.0)), 3),
                    }
                )
            except Exception:
                pass
    except Exception:
        pass

    # Corridors (from Roadway App)
    corridors_info = []
    if "roadway" in apps:
        try:
            road_doc = _com_retry(lambda: getattr(apps["roadway"], "ActiveDocument"))
            corridors = _com_retry(lambda: getattr(road_doc, "Corridors"))
            for cor in corridors:
                try:
                    corridors_info.append({"name": cor.Name})
                except Exception:
                    pass
        except Exception:
            pass

    # Pipe Networks (from Pipe App)
    pipe_networks_info = []
    if "pipe" in apps:
        try:
            pipe_doc = _com_retry(lambda: getattr(apps["pipe"], "ActiveDocument"))
            networks = _com_retry(lambda: getattr(pipe_doc, "PipeNetworks"))
            for pn in networks:
                try:
                    pipe_networks_info.append({"name": pn.Name})
                except Exception:
                    pass
        except Exception:
            pass

    # Cogo Points & Sites
    points_count = 0
    sites_count = 0
    try:
        pts = _com_retry(lambda: getattr(land_doc, "Points"))
        points_count = int(getattr(pts, "Count", 0))
    except Exception:
        pass
    try:
        sites = _com_retry(lambda: getattr(land_doc, "Sites"))
        sites_count = int(getattr(sites, "Count", 0))
    except Exception:
        pass

    return {
        "status": "connected",
        "civil3d_version": "2027 (COM 13.9)",
        "document": getattr(land_doc, "Name", doc.Name),
        "surfaces": surfaces_info,
        "surfaces_count": len(surfaces_info),
        "alignments": alignments_info,
        "alignments_count": len(alignments_info),
        "corridors": corridors_info,
        "corridors_count": len(corridors_info),
        "pipe_networks": pipe_networks_info,
        "pipe_networks_count": len(pipe_networks_info),
        "cogo_points_count": points_count,
        "sites_count": sites_count,
    }


@mcp.tool()
def manage_infraworks_model(
    action: str,
    imx_file_path: str | None = None,
    target_drawing_path: str | None = None,
) -> dict[str, Any]:
    """
    Bridge and exchange data between Autodesk InfraWorks and Civil 3D/AutoCAD.
    action: 'export_to_infraworks' | 'import_from_infraworks' | 'status'
    - 'export_to_infraworks': In Civil 3D, executes EXPORTTOIMX or converts surfaces/alignments to IMX/LandXML for InfraWorks.
    - 'import_from_infraworks': In Civil 3D, loads and converts an InfraWorks IMX or SQLite model data file.
    - 'status': Reports running InfraWorks application processes and SQLite database models.
    """
    action = action.lower().strip()
    acad, doc = _get_doc()

    if action == "status":
        import subprocess
        res = subprocess.run(
            ["powershell", "-Command", "Get-Process InfraWorks -ErrorAction SilentlyContinue | Select-Object Id, ProcessName, MainWindowTitle | ConvertTo-Json"],
            capture_output=True,
            text=True,
        )
        proc_data = json.loads(res.stdout) if res.stdout.strip() else None
        return {
            "infraworks_running": proc_data is not None,
            "process_info": proc_data,
            "supported_exchange_formats": ["IMX", "LandXML", "SDF", "SHP", "DWG/3D Solids"],
            "bridge_mechanism": "Direct Civil 3D <-> InfraWorks IMX/LandXML data synchronization pipeline",
        }

    elif action == "export_to_infraworks":
        target = imx_file_path or str(Path(doc.FullName if doc.FullName else "C:/Users/Admin/Desktop/CivilToInfraWorks.imx").with_suffix(".imx"))
        target_clean = str(Path(target).resolve()).replace("\\", "/")
        doc.SendCommand(f'-EXPORTTOIMX "{target_clean}"\n')
        return {
            "status": "imx_export_triggered",
            "target_path": target_clean,
            "note": "Civil 3D command -EXPORTTOIMX dispatched. Open this IMX in InfraWorks to update the 3D model.",
        }

    elif action == "import_from_infraworks":
        if not imx_file_path:
            raise ValueError("imx_file_path is required for action='import_from_infraworks'")
        abs_path = str(Path(imx_file_path).resolve()).replace("\\", "/")
        doc.SendCommand(f'-IMPORTIMX "{abs_path}"\n')
        return {
            "status": "imx_import_triggered",
            "source_path": abs_path,
            "note": "Civil 3D command -IMPORTIMX dispatched into active document.",
        }

    else:
        raise ValueError(f"Unsupported action: {action}")



@mcp.tool()
def inspect_dxf_file_offline(dxf_path: str) -> dict[str, Any]:
    """
    Inspect a DXF file rapidly offline using `ezdxf` without needing to open it in AutoCAD GUI.
    Returns layers, block names, and entity counts in ModelSpace.
    """
    path = Path(dxf_path).resolve()
    if not path.exists():
        raise FileNotFoundError(f"DXF file not found: {path}")
    doc = ezdxf.readfile(str(path))
    msp = doc.modelspace()
    counts = Counter(e.dxftype() for e in msp)
    layers = [lyr.dxf.name for lyr in doc.layers]
    blocks = [blk.name for blk in doc.blocks if not blk.name.startswith("*")]
    return {
        "file": str(path),
        "dxf_version": doc.dxfversion,
        "layer_count": len(layers),
        "layers": layers,
        "block_count": len(blocks),
        "blocks": blocks,
        "modelspace_entity_counts": dict(counts),
    }


@mcp.tool()
def execute_python_in_autocad(code: str) -> dict[str, Any]:
    """
    Execute arbitrary Python automation code with direct, live access to AutoCAD and Civil 3D COM interfaces.
    Injected variables:
    - `acad`: AutoCAD.Application COM object
    - `doc`: Active Document
    - `msp`: ModelSpace
    - `apps`: Dict of Civil 3D applications (land, roadway, pipe, survey)
    - `land_doc`: Civil 3D Land ActiveDocument (AeccDocument)
    Store any returned data in `output` or `result` variable.
    """
    acad, doc = _get_doc()
    apps = _get_c3d_apps()
    land_doc = getattr(apps.get("land"), "ActiveDocument", None) if "land" in apps else None
    road_doc = getattr(apps.get("roadway"), "ActiveDocument", None) if "roadway" in apps else None
    pipe_doc = getattr(apps.get("pipe"), "ActiveDocument", None) if "pipe" in apps else None
    
    import io
    from contextlib import redirect_stdout, redirect_stderr
    stdout_buf = io.StringIO()
    stderr_buf = io.StringIO()
    
    scope: dict[str, Any] = {
        "acad": acad,
        "doc": doc,
        "msp": doc.ModelSpace,
        "apps": apps,
        "land_doc": land_doc,
        "road_doc": road_doc,
        "pipe_doc": pipe_doc,
        "win32com": win32com,
        "pythoncom": pythoncom,
        "output": None,
        "result": None,
    }
    
    try:
        with redirect_stdout(stdout_buf), redirect_stderr(stderr_buf):
            exec(code, scope)
        return {
            "status": "success",
            "stdout": stdout_buf.getvalue(),
            "stderr": stderr_buf.getvalue(),
            "output": scope.get("output") or scope.get("result"),
        }
    except Exception as e:
        return {
            "status": "error",
            "error": str(e),
            "stdout": stdout_buf.getvalue(),
            "stderr": stderr_buf.getvalue(),
        }


@mcp.tool()
def query_civil3d_surface_elevation(surface_name: str, x: float, y: float) -> dict[str, Any]:
    """
    Query the exact elevation (Z) at given (X, Y) coordinates from a Civil 3D TIN Surface.
    """
    apps = _get_c3d_apps()
    if "land" not in apps:
        return {"status": "error", "message": "Civil 3D Land application not available."}
    land_doc = getattr(apps["land"], "ActiveDocument")
    surfaces = getattr(land_doc, "Surfaces")
    target_surf = None
    for s in surfaces:
        if s.Name.lower() == surface_name.lower():
            target_surf = s
            break
    if not target_surf:
        return {"status": "error", "message": f"Surface '{surface_name}' not found."}
    
    try:
        elev = target_surf.FindElevationAtXY(float(x), float(y))
        return {
            "surface": target_surf.Name,
            "x": float(x),
            "y": float(y),
            "elevation": round(float(elev), 4),
        }
    except Exception as e:
        return {"status": "error", "message": f"Could not determine elevation at ({x}, {y}): {e}"}


@mcp.tool()
def query_civil3d_alignment_details(alignment_name: str) -> dict[str, Any]:
    """
    Query comprehensive geometric details of an alignment: length, stations, profiles, and entities.
    """
    apps = _get_c3d_apps()
    if "land" not in apps:
        return {"status": "error", "message": "Civil 3D Land application not available."}
    land_doc = getattr(apps["land"], "ActiveDocument")
    alignments = getattr(land_doc, "AlignmentsSiteless")
    target_al = None
    for al in alignments:
        if al.Name.lower() == alignment_name.lower():
            target_al = al
            break
    if not target_al:
        return {"status": "error", "message": f"Alignment '{alignment_name}' not found."}
    
    profiles = []
    try:
        for pr in target_al.Profiles:
            profiles.append({
                "name": pr.Name,
                "type": getattr(pr, "Type", 0),
                "elevation_min": round(float(getattr(pr, "ElevationMin", 0.0)), 3),
                "elevation_max": round(float(getattr(pr, "ElevationMax", 0.0)), 3),
            })
    except Exception:
        pass
        
    entities = []
    try:
        for ent in target_al.Entities:
            entities.append({
                "start_station": round(float(getattr(ent, "StartingStation", 0.0)), 2),
                "end_station": round(float(getattr(ent, "EndingStation", 0.0)), 2),
                "start_point": (round(float(getattr(ent, "StartEasting", 0.0)), 2), round(float(getattr(ent, "StartNorthing", 0.0)), 2)),
                "end_point": (round(float(getattr(ent, "EndEasting", 0.0)), 2), round(float(getattr(ent, "EndNorthing", 0.0)), 2)),
            })
    except Exception:
        pass

    return {
        "name": target_al.Name,
        "length": round(float(getattr(target_al, "Length", 0.0)), 3),
        "starting_station": round(float(getattr(target_al, "StartingStation", 0.0)), 3),
        "ending_station": round(float(getattr(target_al, "EndingStation", 0.0)), 3),
        "profiles": profiles,
        "entities": entities,
    }


def run_jsonrpc_server() -> None:
    """High-performance, zero-hang JSON-RPC 2.0 stdio server supporting MCP 2024-11-05 and 2025/2026 drafts."""
    tools_cache = []
    for t in mcp._tool_manager.list_tools():
        tools_cache.append({
            "name": t.name,
            "description": t.description or "",
            "inputSchema": t.parameters or {"type": "object", "properties": {}},
        })

    def send_resp(req_id: Any, result: Any = None, error: Any = None) -> None:
        if req_id is None:
            return
        payload: dict[str, Any] = {"jsonrpc": "2.0", "id": req_id}
        if error is not None:
            payload["error"] = error
        else:
            payload["result"] = result if result is not None else {}
        line = json.dumps(payload, ensure_ascii=False) + "\n"
        sys.stdout.write(line)
        sys.stdout.flush()

    while True:
        try:
            raw_line = sys.stdin.readline()
        except Exception:
            break
        if not raw_line:
            break
        raw_line = raw_line.strip()
        if not raw_line:
            continue

        try:
            msg = json.loads(raw_line)
        except Exception as e:
            continue

        req_id = msg.get("id")
        method = msg.get("method")
        params = msg.get("params") or {}

        if method == "server/discover":
            send_resp(req_id, {
                "protocolVersion": "2024-11-05",
                "capabilities": {"tools": {"listChanged": False}},
                "serverInfo": {"name": "civil3d-infraworks", "version": "1.0.0"}
            })
        elif method == "initialize":
            proto = params.get("protocolVersion", "2024-11-05")
            send_resp(req_id, {
                "protocolVersion": proto,
                "capabilities": {"tools": {"listChanged": False}},
                "serverInfo": {"name": "civil3d-infraworks", "version": "1.0.0"}
            })
        elif method == "notifications/initialized":
            pass
        elif method == "ping":
            send_resp(req_id, {})
        elif method == "tools/list":
            send_resp(req_id, {"tools": tools_cache})
        elif method == "tools/call":
            tool_name = params.get("name")
            arguments = params.get("arguments") or {}
            tool = mcp._tool_manager.get_tool(tool_name)
            if not tool:
                send_resp(req_id, error={"code": -32601, "message": f"Tool '{tool_name}' not found"})
                continue
            try:
                fn_res = tool.fn(**arguments)
                text_content = json.dumps(fn_res, ensure_ascii=False, indent=2) if not isinstance(fn_res, str) else fn_res
                send_resp(req_id, {
                    "content": [{"type": "text", "text": text_content}]
                })
            except Exception as e:
                send_resp(req_id, {
                    "content": [{"type": "text", "text": f"Error executing {tool_name}: {e}"}],
                    "isError": True
                })
        else:
            if req_id is not None:
                send_resp(req_id, error={"code": -32601, "message": f"Method '{method}' not found"})


def main() -> None:
    if len(sys.argv) > 1 and sys.argv[1] in ("--test", "-t", "test"):
        print("=======================================================")
        print("   KIEM TRA KET NOI AUTOCAD / CIVIL 3D / INFRAWORKS    ")
        print("=======================================================")
        try:
            acad_res = get_autocad_status()
            print(f"[AutoCAD] Trang thai: {acad_res.get('status')}")
            if acad_res.get("status") == "connected":
                print(f"  - Phien ban : {acad_res.get('version_name')} ({acad_res.get('version')})")
                print(f"  - Ban ve    : {acad_res.get('active_document', {}).get('name')}")
                print(f"  - Doi tuong : {acad_res.get('active_document', {}).get('modelspace_entity_count')}")
            else:
                print(f"  - Chu y: {acad_res.get('message', acad_res.get('error', 'Chua mo AutoCAD'))}")
        except Exception as e:
            print(f"[AutoCAD] Loi kiem tra: {e}")

        try:
            c3d_res = get_civil3d_status()
            print(f"[Civil 3D] Trang thai: {c3d_res.get('status')}")
            if c3d_res.get("status") == "connected":
                print(f"  - Phien ban : {c3d_res.get('civil3d_version')}")
                print(f"  - Be mat    : {c3d_res.get('surfaces_count')} surface(s)")
                print(f"  - Tim tuyen : {c3d_res.get('alignments_count')} alignment(s)")
            else:
                print(f"  - Chu y: {c3d_res.get('message', c3d_res.get('error', 'Chua bat Civil 3D'))}")
        except Exception as e:
            print(f"[Civil 3D] Loi kiem tra: {e}")
        print("=======================================================")
        return

    run_jsonrpc_server()


if __name__ == "__main__":
    main()
