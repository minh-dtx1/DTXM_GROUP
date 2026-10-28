# -*- coding: utf-8 -*-
"""
DTXM CAD & Document Automation Tool
Chương trình quét và thay thế chuỗi text "iDECO, IDECO, ideco" thành "DTXM"
hàng loạt cho thư mục bản vẽ AutoCAD (.dwg) và các file tài liệu văn bản.

Tác giả: Nhóm Kỹ thuật DTXM
Ngày cập nhật: 2026-10-28
"""

import os
import sys
import re
import time
import argparse
from pathlib import Path

# Cấu hình UTF-8 an toàn cho console Windows
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
if hasattr(sys.stderr, 'reconfigure'):
    sys.stderr.reconfigure(encoding='utf-8', errors='replace')

SEARCH_REGEX = re.compile(r'iDECO|IDECO|ideco', re.IGNORECASE)
REPLACE_STR = "DTXM"

TEXT_EXTENSIONS = {
    '.txt', '.lsp', '.md', '.json', '.xml', '.csv', '.html', '.htm',
    '.bat', '.cmd', '.ps1', '.py', '.ini', '.cfg', '.dxf', '.sql', '.yaml', '.yml'
}

EXCLUDED_FILENAMES = {
    '04_Batch_Replace_Text_CAD_Va_VanBan.py',
    'Chay_ThayThe_iDECO_sang_DTXM.bat',
    'DTXM_ThayTheText_iDECO_sang_DTXM.lsp',
    '.scanned_dwgs.txt'
}

CACHE_FILE = Path(__file__).parent / ".scanned_dwgs.txt"

def load_scanned_dwgs():
    if CACHE_FILE.exists():
        try:
            with open(CACHE_FILE, 'r', encoding='utf-8') as f:
                return set(line.strip() for line in f if line.strip())
        except Exception:
            pass
    return set()

def record_scanned_dwg(filename: str):
    try:
        with open(CACHE_FILE, 'a', encoding='utf-8') as f:
            f.write(filename + '\n')
    except Exception:
        pass

def replace_in_string(text: str):
    if not text:
        return text, 0
    return re.subn(r'(?i)iDECO', REPLACE_STR, text)

def process_text_file(filepath: Path) -> int:
    if filepath.name in EXCLUDED_FILENAMES:
        return 0

    encodings = ['utf-8-sig', 'utf-8', 'cp1258', 'utf-16', 'latin-1']
    content = None
    used_encoding = None

    for enc in encodings:
        try:
            with open(filepath, 'r', encoding=enc) as f:
                content = f.read()
            used_encoding = enc
            break
        except (UnicodeDecodeError, UnicodeError):
            continue

    if content is None or used_encoding is None:
        return 0

    new_content, count = replace_in_string(content)
    if count > 0:
        with open(filepath, 'w', encoding=used_encoding) as f:
            f.write(new_content)
        print(f"  [TEXT] {filepath.name}: Đã thay thế {count} vị trí ({used_encoding})")
        return count
    return 0

def process_dwg_file(acad, dwg_path: str, backup: bool = True) -> int:
    dwg_path_str = os.path.abspath(dwg_path)
    if backup:
        bak_path = dwg_path_str + ".bak_dtxm"
        if not os.path.exists(bak_path):
            import shutil
            try:
                shutil.copy2(dwg_path_str, bak_path)
            except Exception:
                pass

    total_replaced = 0
    doc = None
    is_already_open = False
    try:
        for i in range(acad.Documents.Count):
            d = acad.Documents.Item(i)
            if os.path.normpath(d.FullName).lower() == os.path.normpath(dwg_path_str).lower():
                doc = d
                is_already_open = True
                break

        if not doc:
            doc = acad.Documents.Open(dwg_path_str)

        def scan_collection(collection):
            nonlocal total_replaced
            for entity in collection:
                try:
                    obj_name = entity.ObjectName
                    if obj_name == "AcDbText":
                        val = entity.TextString
                        new_val, c = replace_in_string(val)
                        if c > 0:
                            entity.TextString = new_val
                            total_replaced += c

                    elif obj_name == "AcDbMText":
                        val = entity.Text
                        new_val, c = replace_in_string(val)
                        if c > 0:
                            entity.Text = new_val
                            total_replaced += c

                    elif obj_name == "AcDbBlockReference":
                        if entity.HasAttributes:
                            for attr in entity.GetAttributes():
                                val = attr.TextString
                                new_val, c = replace_in_string(val)
                                if c > 0:
                                    attr.TextString = new_val
                                    total_replaced += c

                    elif "Dimension" in obj_name:
                        val = getattr(entity, 'TextOverride', '')
                        if val:
                            new_val, c = replace_in_string(val)
                            if c > 0:
                                entity.TextOverride = new_val
                                total_replaced += c

                    elif obj_name == "AcDbMLeader":
                        val = getattr(entity, 'TextString', '')
                        if val:
                            new_val, c = replace_in_string(val)
                            if c > 0:
                                entity.TextString = new_val
                                total_replaced += c

                    elif obj_name == "AcDbTable":
                        rows = entity.Rows
                        cols = entity.Columns
                        for r in range(rows):
                            for col in range(cols):
                                try:
                                    val = entity.GetText(r, col)
                                    if val:
                                        new_val, c = replace_in_string(val)
                                        if c > 0:
                                            entity.SetText(r, col, new_val)
                                            total_replaced += c
                                except Exception:
                                    pass
                except Exception:
                    continue

        scan_collection(doc.ModelSpace)

        try:
            for layout in doc.Layouts:
                if layout.Name.lower() != "model":
                    scan_collection(layout.Block)
        except Exception:
            scan_collection(doc.PaperSpace)

        try:
            for block in doc.Blocks:
                if not block.IsLayout and not block.IsXRef:
                    for entity in block:
                        try:
                            if entity.ObjectName == "AcDbAttributeDefinition":
                                val = entity.TextString
                                new_val, c = replace_in_string(val)
                                if c > 0:
                                    entity.TextString = new_val
                                    total_replaced += c
                            elif entity.ObjectName in ("AcDbText", "AcDbMText"):
                                val = entity.TextString if entity.ObjectName == "AcDbText" else entity.Text
                                new_val, c = replace_in_string(val)
                                if c > 0:
                                    if entity.ObjectName == "AcDbText":
                                        entity.TextString = new_val
                                    else:
                                        entity.Text = new_val
                                    total_replaced += c
                        except Exception:
                            continue
        except Exception:
            pass

        if total_replaced > 0:
            doc.Save()
            print(f"  [CAD]  {os.path.basename(dwg_path_str)}: Đã thay thế {total_replaced} vị trí text/attribute.")
        else:
            print(f"  [CAD]  {os.path.basename(dwg_path_str)}: Không có chuỗi khớp.")

        if not is_already_open:
            doc.Close()

    except Exception as ex:
        print(f"  [LỖI]  Xử lý file {os.path.basename(dwg_path_str)}: {ex}")
        if doc and not is_already_open:
            try:
                doc.Close()
            except Exception:
                pass

    return total_replaced

def run_batch(target_dir: str, target_type: str = "all", recursive: bool = True):
    target_path = Path(target_dir).resolve()
    if not target_path.exists():
        print(f"Lỗi: Thư mục không tồn tại: {target_path}")
        return

    print("=" * 70)
    print(" DTXM - CÔNG CỤ BATCH FIND & REPLACE TEXT")
    print(f" Tìm kiếm : 'iDECO', 'IDECO', 'ideco' (không phân biệt hoa thường)")
    print(f" Thay thế : '{REPLACE_STR}'")
    print(f" Thư mục  : {target_path}")
    print(f" Chế độ   : Loại file = {target_type.upper()}, Đệ quy = {recursive}")
    print("=" * 70)

    dwg_files = []
    text_files = []

    file_iterator = target_path.rglob("*") if recursive else target_path.glob("*")
    for f in file_iterator:
        if not f.is_file():
            continue
        if any(ignored in f.parts for ignored in ('.git', 'venv', '.venv', '__pycache__', 'node_modules')):
            continue

        ext = f.suffix.lower()
        if ext == '.dwg':
            dwg_files.append(f)
        elif ext in TEXT_EXTENSIONS:
            text_files.append(f)

    # 1. Xử lý file văn bản
    total_text_rep = 0
    if target_type in ("all", "text"):
        print(f"\n[1/2] Đang quét {len(text_files)} file văn bản/code/dxf...")
        for tf in text_files:
            try:
                c = process_text_file(tf)
                total_text_rep += c
            except Exception as e:
                print(f"  [Lỗi file text] {tf.name}: {e}")

    # 2. Xử lý file AutoCAD DWG (có resume cache)
    scanned_dwgs = load_scanned_dwgs()
    total_cad_rep = 0
    if target_type in ("all", "cad") and dwg_files:
        remaining_dwgs = [d for d in dwg_files if d.name not in scanned_dwgs]
        print(f"\n[2/2] Tổng số: {len(dwg_files)} DWG. Đã quét trước đó: {len(scanned_dwgs)}. Còn lại: {len(remaining_dwgs)} DWG.")
        
        if remaining_dwgs:
            print("  -> Đang kết nối với AutoCAD...")
            import win32com.client
            acad = None
            try:
                acad = win32com.client.GetActiveObject("AutoCAD.Application")
                print("  -> Kết nối thành công tới phiên AutoCAD đang chạy.")
            except Exception:
                print("  -> Đang khởi chạy AutoCAD mới...")
                acad = win32com.client.Dispatch("AutoCAD.Application")
                acad.Visible = True

            for idx, dwg in enumerate(remaining_dwgs, 1):
                print(f"  [{idx}/{len(remaining_dwgs)}] Đang mở: {dwg.name}...")
                c = process_dwg_file(acad, str(dwg))
                total_cad_rep += c
                record_scanned_dwg(dwg.name)
        else:
            print("  -> Tất cả bản vẽ DWG đã được quét hoàn tất trước đó.")

    print("\n" + "=" * 70)
    print(" KẾT QUẢ HOÀN THÀNH:")
    print(f"  - Tổng vị trí thay thế trong file văn bản : {total_text_rep}")
    print(f"  - Tổng vị trí thay thế trong bản vẽ CAD   : {total_cad_rep}")
    print(f"  - TỔNG CỘNG ĐÃ THAY THẾ                   : {total_text_rep + total_cad_rep} vị trí.")
    print("=" * 70)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="DTXM Batch Text Replace Tool (iDECO -> DTXM)")
    parser.add_argument("--dir", "-d", type=str, default="", help="Đường dẫn thư mục cần quét")
    parser.add_argument("--target", "-t", choices=["all", "cad", "text"], default="all", help="Loại file: all, cad, text")
    parser.add_argument("--no-recursive", action="store_true", help="Không quét thư mục con")
    args = parser.parse_args()

    dir_input = args.dir
    if not dir_input:
        dir_input = os.getcwd()

    run_batch(dir_input, target_type=args.target, recursive=not args.no_recursive)