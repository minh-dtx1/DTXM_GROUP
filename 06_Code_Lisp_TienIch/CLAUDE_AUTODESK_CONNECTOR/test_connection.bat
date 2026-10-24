@echo off
chcp 65001 >nul
title Kiem Tra Ket Noi Claude - Autodesk
echo =======================================================================
echo    KIEM TRA KET NOI CLAUDE VOI AUTODESK (AUTOCAD, CIVIL 3D, REVIT)
echo =======================================================================
echo.

if exist "%~dp0venv\Scripts\python.exe" (
    "%~dp0venv\Scripts\python.exe" "%~dp0server_autocad_civil3d.py" --test
) else (
    echo [LUA Y] Thu muc venv chua duoc khoi tao. Vui long chay install.bat truoc!
)

echo.
echo Kiem tra trang thai dich vu trong Claude Code CLI:
where claude >nul 2>nul
if %errorlevel% equ 0 (
    echo.
    echo Dang kiem tra claude mcp list...
    claude mcp list
)

echo.
echo Nhan phim bat ky de ket thuc...
pause >nul
