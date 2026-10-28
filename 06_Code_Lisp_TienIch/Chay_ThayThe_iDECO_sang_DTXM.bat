@echo off
chcp 65001 >nul
title DTXM - BATCH THAY THE "iDECO" SANG "DTXM"
cls
echo ==============================================================================
echo              DTXM - CONG CU BATCH REPLACE "iDECO" -^> "DTXM"
echo ==============================================================================
echo.
echo Nhap duong dan thu muc can quet va thay the (DWG, TXT, LSP, MD, CSV, DXF,...):
echo Vi du: F:\OneDrive\DTXM_GROUP\05_DuAn_CauDuong\44_DUONG_NTT
echo.
set /p TARGET_DIR="Duong dan thu muc: "

if "%TARGET_DIR%"=="" (
    set TARGET_DIR=%~dp0
)

echo.
echo Dang khoi dong cong cu Python xu ly...
set PY_EXE="F:\OneDrive\DTXM_GROUP\06_Code_Lisp_TienIch\CLAUDE_AUTODESK_CONNECTOR\venv\Scripts\python.exe"
if not exist %PY_EXE% (
    set PY_EXE="C:\Users\Admin\.gemini\antigravity\scratch\autocad-mcp\.venv\Scripts\python.exe"
)

%PY_EXE% "%~dp003_Python_Scripts_TuDongHoa\04_Batch_Replace_Text_CAD_Va_VanBan.py" --dir "%TARGET_DIR%" --target all

echo.
echo ==============================================================================
pause