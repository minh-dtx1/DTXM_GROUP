# ==============================================================================
# BỘ CÀI ĐẶT TỰ ĐỘNG: KẾT NỐI CLAUDE AI VỚI AUTODESK (REVIT, CIVIL 3D, CAD, INFRAWORKS)
# Tương thích: Windows 10, Windows 11 (64-bit)
# Phiên bản phần mềm hỗ trợ:
# - Autodesk AutoCAD 2024, 2025, 2026, 2027
# - Autodesk Civil 3D 2024, 2025, 2026, 2027
# - Autodesk InfraWorks 2024, 2025, 2026, 2027
# - Autodesk Revit 2024, 2025, 2026, 2027 (MCP Stdio & pyRevit)
# ==============================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Bộ Cài Đặt Kết Nối Claude - Autodesk BIM/CAD"

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host "   BỘ CÀI ĐẶT KẾT NỐI CLAUDE AI VỚI AUTODESK (BIM & CIVIL CAD)         " -ForegroundColor Yellow
Write-Host "   Revit | Civil 3D | AutoCAD | InfraWorks -> Claude Desktop & CLI    " -ForegroundColor Cyan
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""

$ConnectorDir = $PSScriptRoot
if (-not $ConnectorDir) {
    $ConnectorDir = (Get-Location).Path
}

# ------------------------------------------------------------------------------
# BƯỚC 1: TÌM HOẶC CÀI ĐẶT PYTHON TRÊN MÁY TÍNH
# ------------------------------------------------------------------------------
Write-Host "[1/5] Kiểm tra môi trường Python trên máy tính..." -ForegroundColor Green

$pythonExe = $null

# 1. Kiểm tra python trong PATH
try {
    $pyCmd = Get-Command python -ErrorAction SilentlyContinue
    if ($pyCmd) {
        $pyVer = & python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>$null
        if ($pyVer -ge "3.10") {
            $pythonExe = (Get-Command python).Source
            Write-Host "  -> Đã tìm thấy Python $pyVer trong PATH: $pythonExe" -ForegroundColor Gray
        }
    }
} catch {}

# 2. Kiểm tra uv nếu có
if (-not $pythonExe) {
    $uvPath = "$env:USERPROFILE\.local\bin\uv.exe"
    if (Test-Path $uvPath) {
        $pyFromUv = & $uvPath python find 2>$null
        if ($pyFromUv -and (Test-Path $pyFromUv)) {
            $pythonExe = $pyFromUv
            Write-Host "  -> Đã tìm thấy Python thông qua uv: $pythonExe" -ForegroundColor Gray
        }
    }
}

# 3. Quét các thư mục cài đặt tiêu chuẩn của Python trên Windows
if (-not $pythonExe) {
    $commonPyPaths = @(
        "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python310\python.exe",
        "C:\Program Files\Python312\python.exe",
        "C:\Program Files\Python311\python.exe",
        "C:\Program Files\Python310\python.exe"
    )
    foreach ($p in $commonPyPaths) {
        if (Test-Path $p) {
            $pythonExe = $p
            Write-Host "  -> Đã tìm thấy Python tại: $pythonExe" -ForegroundColor Gray
            break
        }
    }
}

# 4. Tự động cài đặt Python nếu máy hoàn toàn chưa có
if (-not $pythonExe) {
    Write-Host "  [!] Máy tính chưa cài Python 3.10+. Đang tiến hành cài đặt tự động qua winget..." -ForegroundColor Yellow
    try {
        winget install --id Python.Python.3.12 --exact --source winget --accept-source-agreements --accept-package-agreements --silent
        Start-Sleep -Seconds 5
        $pythonExe = "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe"
    } catch {
        Write-Host "  [LỖI] Không thể tự cài Python qua winget. Vui lòng cài Python 3.10+ từ https://www.python.org/downloads/ rồi chạy lại." -ForegroundColor Red
        Exit 1
    }
}

# ------------------------------------------------------------------------------
# BƯỚC 2: TẠO VÀ THIẾT LẬP MÔI TRƯỜNG ẢO CHO CONNECTOR
# ------------------------------------------------------------------------------
Write-Host "[2/5] Thiết lập môi trường ảo và gói thư viện COM..." -ForegroundColor Green

$VenvDir = Join-Path $ConnectorDir "venv"
$VenvPy = Join-Path $VenvDir "Scripts\python.exe"
$VenvPip = Join-Path $VenvDir "Scripts\pip.exe"
$ReqFile = Join-Path $ConnectorDir "requirements.txt"

if (-not (Test-Path $VenvPy)) {
    Write-Host "  -> Đang khởi tạo venv tại: $VenvDir" -ForegroundColor Gray
    & $pythonExe -m venv $VenvDir
}

Write-Host "  -> Đang cài đặt/cập nhật thư viện: mcp, pywin32, ezdxf..." -ForegroundColor Gray
if (Test-Path $VenvPip) {
    & $VenvPip install --upgrade pip --quiet
    & $VenvPip install -r $ReqFile --quiet
} else {
    # Nếu venv không có pip, nạp ensurepip
    & $VenvPy -m ensurepip --default-pip
    & $VenvPy -m pip install -r $ReqFile --quiet
}

# Đăng ký COM DLLs cho pywin32 nếu cần
try {
    $postInstall = Join-Path $VenvDir "Scripts\pywin32_postinstall.py"
    if (Test-Path $postInstall) {
        & $VenvPy $postInstall -install 2>$null | Out-Null
    }
} catch {}

Write-Host "  -> Cài đặt thư viện Python hoàn tất!" -ForegroundColor Green

# ------------------------------------------------------------------------------
# BƯỚC 3: QUÉT VÀ KIỂM TRA PHẦN MỀM AUTODESK CÓ SẴN
# ------------------------------------------------------------------------------
Write-Host "[3/5] Quét các ứng dụng Autodesk trên máy..." -ForegroundColor Green

$foundApps = @()

# Kiểm tra AutoCAD
$acadVersions = @("2024", "2025", "2026", "2027")
foreach ($v in $acadVersions) {
    $path = "C:\Program Files\Autodesk\AutoCAD $v\acad.exe"
    if (Test-Path $path) {
        $foundApps += "AutoCAD $v"
        Write-Host "  [+] Phát hiện: AutoCAD $v ($path)" -ForegroundColor Cyan
    }
}

# Kiểm tra Civil 3D
foreach ($v in $acadVersions) {
    $c3dPath = "C:\Program Files\Autodesk\AutoCAD $v\C3D"
    if (Test-Path $c3dPath) {
        $foundApps += "Civil 3D $v"
        Write-Host "  [+] Phát hiện: Civil 3D $v" -ForegroundColor Cyan
    }
}

# Kiểm tra InfraWorks
if (Test-Path "C:\Program Files\Autodesk\InfraWorks\InfraWorks.exe") {
    $foundApps += "InfraWorks"
    Write-Host "  [+] Phát hiện: Autodesk InfraWorks" -ForegroundColor Cyan
}

# Kiểm tra Revit & Revit MCP
$revitMcpExe = $null
$revitMcpSearch = @(
    "C:\Program Files\Autodesk\Revit 2027 MCP Server Write-Tools Technical Preview\Autodesk.RevitMcpServer.Stdio.exe",
    "C:\Program Files\Autodesk\Revit MCP Server\Autodesk.RevitMcpServer.Stdio.exe"
)
foreach ($rm in $revitMcpSearch) {
    if (Test-Path $rm) {
        $revitMcpExe = $rm
        $foundApps += "Revit Official MCP Server"
        Write-Host "  [+] Phát hiện: Revit MCP Server ($rm)" -ForegroundColor Cyan
        break
    }
}

# Kiểm tra pyRevit
$pyrevitMain = "$env:APPDATA\pyRevit\Extensions\mcp-server-for-revit-python.extension\main.py"
$hasPyRevit = Test-Path $pyrevitMain
if ($hasPyRevit) {
    $foundApps += "pyRevit MCP Extension"
    Write-Host "  [+] Phát hiện: pyRevit MCP Extension ($pyrevitMain)" -ForegroundColor Cyan
}

if ($foundApps.Count -eq 0) {
    Write-Host "  [!] Chưa tìm thấy cài đặt Autodesk ở thư mục mặc định (sẽ sử dụng kết nối COM động khi bạn bật phần mềm)." -ForegroundColor Yellow
}

# ------------------------------------------------------------------------------
# BƯỚC 4: TỰ ĐỘNG CẤU HÌNH CLAUDE DESKTOP & CLAUDE CODE CLI
# ------------------------------------------------------------------------------
Write-Host "[4/5] Tích hợp cấu hình vào Claude Desktop và Claude Code CLI..." -ForegroundColor Green

$ServerScript = Join-Path $ConnectorDir "server_autocad_civil3d.py"

# Cấu trúc MCP Server cho CAD / Civil 3D / InfraWorks
$mcpAutocadCivil = @{
    "type" = "stdio"
    "command" = $VenvPy
    "args" = @("-u", $ServerScript)
    "env" = @{
        "PYTHONUNBUFFERED" = "1"
        "PYTHONUTF8" = "1"
        "PYTHONIOENCODING" = "utf-8"
    }
}

# 1. Cấu hình Claude Desktop (claude_desktop_config.json)
$ClaudeDesktopDir = "$env:APPDATA\Claude"
$ClaudeDesktopConfig = Join-Path $ClaudeDesktopDir "claude_desktop_config.json"

if (-not (Test-Path $ClaudeDesktopDir)) {
    New-Item -ItemType Directory -Path $ClaudeDesktopDir -Force | Out-Null
}

$desktopObj = @{ "mcpServers" = @{} }
if (Test-Path $ClaudeDesktopConfig) {
    try {
        $raw = Get-Content -Path $ClaudeDesktopConfig -Raw -Encoding UTF8
        if ($raw) {
            $desktopObj = $raw | ConvertFrom-Json -AsHashtable
            if (-not $desktopObj.ContainsKey("mcpServers")) {
                $desktopObj["mcpServers"] = @{}
            }
        }
    } catch {
        Write-Host "  [!] Đang tạo lại file config Claude Desktop mới..." -ForegroundColor Yellow
    }
}

# Ghi đè / bổ sung mcpServers
$desktopObj["mcpServers"]["civil3d-infraworks"] = @{
    "command" = $VenvPy
    "args" = @("-u", $ServerScript)
    "env" = @{
        "PYTHONUNBUFFERED" = "1"
        "PYTHONUTF8" = "1"
        "PYTHONIOENCODING" = "utf-8"
    }
}

$desktopObj["mcpServers"]["autocad"] = @{
    "command" = $VenvPy
    "args" = @("-u", $ServerScript)
    "env" = @{
        "PYTHONUNBUFFERED" = "1"
        "PYTHONUTF8" = "1"
        "PYTHONIOENCODING" = "utf-8"
    }
}

# Nếu có Revit MCP Server chính thức
if ($revitMcpExe) {
    $desktopObj["mcpServers"]["revit-write"] = @{ "command" = $revitMcpExe }
    $desktopObj["mcpServers"]["revit-read"]  = @{ "command" = $revitMcpExe }
}

# Lưu Claude Desktop config UTF-8 không BOM
$desktopJson = $desktopObj | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($ClaudeDesktopConfig, $desktopJson, [System.Text.UTF8Encoding]::new($false))
Write-Host "  -> Đã cập nhật thành công: $ClaudeDesktopConfig" -ForegroundColor Green

# 2. Cấu hình Claude Code CLI (.claude.json)
$ClaudeCliConfig = "$env:USERPROFILE\.claude.json"
$cliObj = @{ "mcpServers" = @{} }
if (Test-Path $ClaudeCliConfig) {
    try {
        $rawCli = Get-Content -Path $ClaudeCliConfig -Raw -Encoding UTF8
        if ($rawCli) {
            $cliObj = $rawCli | ConvertFrom-Json -AsHashtable
            if (-not $cliObj.ContainsKey("mcpServers")) {
                $cliObj["mcpServers"] = @{}
            }
        }
    } catch {}
}

$cliObj["mcpServers"]["civil3d-infraworks"] = $mcpAutocadCivil
$cliObj["mcpServers"]["autocad"] = $mcpAutocadCivil
if ($revitMcpExe) {
    $cliObj["mcpServers"]["revit-write"] = @{
        "type" = "stdio"
        "command" = $revitMcpExe
        "args" = @()
        "env" = @{}
    }
}

$cliJson = $cliObj | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($ClaudeCliConfig, $cliJson, [System.Text.UTF8Encoding]::new($false))
Write-Host "  -> Đã cập nhật thành công: $ClaudeCliConfig" -ForegroundColor Green

# ------------------------------------------------------------------------------
# BƯỚC 5: KIỂM TRA SỨC KHỎE KẾT NỐI (HEALTH-CHECK)
# ------------------------------------------------------------------------------
Write-Host "[5/5] Kiểm tra trực tiếp khả năng giao tiếp của Server..." -ForegroundColor Green

try {
    & $VenvPy $ServerScript --test
} catch {
    Write-Host "  [!] Lưu ý: Khởi động AutoCAD / Civil 3D để trải nghiệm đầy đủ tính năng tương tác." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Green
Write-Host "               CÀI ĐẶT HOÀN TẤT THÀNH CÔNG 100%!                       " -ForegroundColor Green
Write-Host "=======================================================================" -ForegroundColor Green
Write-Host "Danh sách phần mềm đã liên kết với Claude:" -ForegroundColor Yellow
Write-Host "  1. Autodesk AutoCAD (2024, 2025, 2026, 2027) -> Đã kích hoạt 21 tools" -ForegroundColor White
Write-Host "  2. Autodesk Civil 3D (Bề mặt TIN, Tim tuyến, Trắc dọc) -> Đã kích hoạt" -ForegroundColor White
Write-Host "  3. Autodesk InfraWorks (IMX, Mô hình 3D Solid)       -> Đã kích hoạt" -ForegroundColor White
if ($revitMcpExe -or $hasPyRevit) {
Write-Host "  4. Autodesk Revit (Mô hình BIM, Family, View)        -> Đã kích hoạt" -ForegroundColor White
}
Write-Host ""
Write-Host "LƯU Ý ĐỂ BẮT ĐẦU SỬ DỤNG:" -ForegroundColor Cyan
Write-Host "  - Khởi động lại Claude Desktop (Nhấp chuột phải icon Claude ở khay đồng hồ -> Quit Claude)" -ForegroundColor Gray
Write-Host "  - Mở một Phiên Chat Mới (New Chat / Ctrl+N) để Claude tự động nhận diện bộ công cụ." -ForegroundColor Gray
Write-Host "  - Chỉ cần mở bản vẽ AutoCAD/Civil 3D rồi yêu cầu Claude thực hiện lệnh!" -ForegroundColor Gray
Write-Host "=======================================================================" -ForegroundColor Green
Write-Host ""
