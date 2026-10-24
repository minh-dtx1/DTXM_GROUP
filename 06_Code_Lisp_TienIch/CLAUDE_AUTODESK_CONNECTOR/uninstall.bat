@echo off
chcp 65001 >nul
title Go Bo Ket Noi Claude - Autodesk
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0uninstall.ps1"
pause
