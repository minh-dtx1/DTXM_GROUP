@echo off
chcp 65001 >nul
title Cai Dat Bo Ket Noi Claude - Autodesk BIM
echo =======================================================================
echo    DANG CHUAN BI CAI DAT KET NOI CLAUDE VOI AUTODESK BIM/CAD...
echo =======================================================================
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"

if %errorlevel% neq 0 (
    echo.
    echo [CANH BAO] Qua trinh cai dat gap loi hoac can kiem tra lai quyen truy cap.
)

echo.
echo Nhan phim bat ky de thoat...
pause >nul
