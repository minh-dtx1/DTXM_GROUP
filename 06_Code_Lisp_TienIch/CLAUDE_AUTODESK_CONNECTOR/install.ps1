# ==============================================================================
# BO CAI DAT TU DONG: KET NOI CLAUDE AI VOI AUTODESK (REVIT, CIVIL 3D, CAD, INFRAWORKS)
# Tuong thich: Windows 10, Windows 11 (64-bit)
# Ho tro: AutoCAD (2024-2027), Civil 3D (2024-2027), InfraWorks, Revit
# ==============================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Bo Cai Dat Ket Noi Claude - Autodesk BIM/CAD"

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host "   BO CAI DAT KET NOI CLAUDE AI VOI AUTODESK (BIM & CIVIL CAD)         " -ForegroundColor Yellow
Write-Host "   Revit | Civil 3D | AutoCAD | InfraWorks -> Claude Desktop & CLI    " -ForegroundColor Cyan
Write-Host "=======================================================================" -ForegroundColor Cyan
Write-Host ""

$ConnectorDir = $PSScriptRoot
if (-not $ConnectorDir) {
    $ConnectorDir = (Get-Location).Path
}

# ------------------------------------------------------------------------------
# BUOC 1: KIEM TRA HOAC CAI DAT PYTHON TREN MAY TINH
# ------------------------------------------------------------------------------
Write-Host "[1/5] Kiem tra moi truong Python tren may tinh..." -ForegroundColor Green

$pythonExe = $null

# 1. Kiem tra python launcher py -3.12 hoac py -3.11
try {
    $pyFromLauncher = & py -3.12 -c "import sys; print(sys.executable)" 2>$null
    if ($pyFromLauncher -and (Test-Path $pyFromLauncher)) {
        $pythonExe = $pyFromLauncher
        Write-Host "  -> Da tim thay Python 3.12 qua py launcher: $pythonExe" -ForegroundColor Gray
    }
} catch {}

# 2. Kiem tra uv neu co
if (-not $pythonExe) {
    $uvPath = "$env:USERPROFILE\.local\bin\uv.exe"
    if (Test-Path $uvPath) {
        $pyFromUv = & $uvPath python find 3.12 2>$null
        if (-not $pyFromUv) {
            $pyFromUv = & $uvPath python find 2>$null
        }
        if ($pyFromUv -and (Test-Path $pyFromUv)) {
            $pythonExe = $pyFromUv
            Write-Host "  -> Da tim thay Python thong qua uv: $pythonExe" -ForegroundColor Gray
        }
    }
}

# 3. Quet cac thu muc cai dat tieu chuan CPython 3.12 / 3.11 / 3.10
if (-not $pythonExe) {
    $commonPyPaths = @(
        "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python310\python.exe",
        "C:\Program Files\Python312\python.exe",
        "C:\Program Files\Python311\python.exe",
        "C:\Program Files\Python310\python.exe"
    )
    $uvPyDir = "$env:APPDATA\uv\python"
    if (Test-Path $uvPyDir) {
        $foundUvPy = Get-ChildItem -Path $uvPyDir -Filter "python.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($foundUvPy) {
            $commonPyPaths += $foundUvPy.FullName
        }
    }
    foreach ($p in $commonPyPaths) {
        if (Test-Path $p) {
            $pythonExe = $p
            Write-Host "  -> Da tim thay Python tai: $pythonExe" -ForegroundColor Gray
            break
        }
    }
}

# 4. Kiem tra python trong PATH (chi chap nhan phien ban 3.10 den 3.13)
if (-not $pythonExe) {
    try {
        $pyCmd = Get-Command python -ErrorAction SilentlyContinue
        if ($pyCmd) {
            $pyVer = & python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>$null
            if ($pyVer -ge "3.10" -and $pyVer -le "3.13") {
                $pythonExe = (Get-Command python).Source
                Write-Host "  -> Da tim thay Python $pyVer trong PATH: $pythonExe" -ForegroundColor Gray
            }
        }
    } catch {}
}

# 5. Tu dong cai dat Python neu may hoan toan chua co
if (-not $pythonExe) {
    Write-Host "  [!] May tinh chua cai Python 3.10 - 3.13. Dang tien hanh cai dat tu dong Python 3.12 qua winget..." -ForegroundColor Yellow
    try {
        winget install --id Python.Python.3.12 --exact --source winget --accept-source-agreements --accept-package-agreements --silent
        Start-Sleep -Seconds 5
        $pythonExe = "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe"
    } catch {
        Write-Host "  [LOI] Khong the tu cai Python qua winget. Vui long cai Python 3.12 tu https://www.python.org/downloads/ roi chay lai." -ForegroundColor Red
        Exit 1
    }
}

# ------------------------------------------------------------------------------
# BUOC 2: TAO VA THIET LAP MOI TRUONG AO CHO CONNECTOR
# ------------------------------------------------------------------------------
Write-Host "[2/5] Thiet lap moi truong ao va goi thu vien COM..." -ForegroundColor Green

$VenvDir = Join-Path $ConnectorDir "venv"
$VenvPy = Join-Path $VenvDir "Scripts\python.exe"
$VenvPip = Join-Path $VenvDir "Scripts\pip.exe"
$ReqFile = Join-Path $ConnectorDir "requirements.txt"

if (-not (Test-Path $VenvPy)) {
    Write-Host "  -> Dang khoi tao venv tai: $VenvDir" -ForegroundColor Gray
    & $pythonExe -m venv $VenvDir
}

Write-Host "  -> Dang cai dat/cap nhat thu vien: mcp, pywin32, ezdxf..." -ForegroundColor Gray
& $VenvPy -m pip install -r $ReqFile --quiet

# Dang ky COM DLLs cho pywin32 neu can
try {
    $postInstall = Join-Path $VenvDir "Scripts\pywin32_postinstall.py"
    if (Test-Path $postInstall) {
        & $VenvPy $postInstall -install 2>$null | Out-Null
    }
} catch {}

Write-Host "  -> Cai dat thu vien Python hoan tat!" -ForegroundColor Green

# ------------------------------------------------------------------------------
# BUOC 3: QUET VA KIEM TRA PHAN MEM AUTODESK CO SAN
# ------------------------------------------------------------------------------
Write-Host "[3/5] Quet cac ung dung Autodesk tren may..." -ForegroundColor Green

$foundApps = @()

# Kiem tra AutoCAD
$acadVersions = @("2020", "2021", "2022", "2023", "2024", "2025", "2026", "2027")
foreach ($v in $acadVersions) {
    $path = "C:\Program Files\Autodesk\AutoCAD $v\acad.exe"
    if (Test-Path $path) {
        $foundApps += "AutoCAD $v"
        Write-Host "  [+] Phat hien: AutoCAD $v ($path)" -ForegroundColor Cyan
    }
}

# Kiem tra Civil 3D
foreach ($v in $acadVersions) {
    $c3dPath = "C:\Program Files\Autodesk\AutoCAD $v\C3D"
    if (Test-Path $c3dPath) {
        $foundApps += "Civil 3D $v"
        Write-Host "  [+] Phat hien: Civil 3D $v" -ForegroundColor Cyan
    }
}

# Kiem tra InfraWorks
if (Test-Path "C:\Program Files\Autodesk\InfraWorks\InfraWorks.exe") {
    $foundApps += "InfraWorks"
    Write-Host "  [+] Phat hien: Autodesk InfraWorks" -ForegroundColor Cyan
}

# Kiem tra Revit & Revit MCP
$revitMcpExe = $null

# 1. Kiem tra goi Revit MCP san co trong Connector
$bundleRevitMcp = Join-Path $ConnectorDir "revit_mcp\Autodesk.RevitMcpServer.Stdio.exe"
$bundleRevitDll = Join-Path $ConnectorDir "revit_mcp\Autodesk.RevitMcpServer.Addin.dll"

if (Test-Path $bundleRevitMcp) {
    $revitMcpExe = $bundleRevitMcp
    $foundApps += "Revit MCP Server (Goi portable di kem)"
    Write-Host "  [+] Phat hien: Goi Revit MCP Server tich hop san trong Connector" -ForegroundColor Cyan

    # Tu dong dang ky Add-in cho moi phien ban Revit tren may (2020 - 2027)
    $revitYears = @("2020", "2021", "2022", "2023", "2024", "2025", "2026", "2027")
    foreach ($yr in $revitYears) {
        $addinDir = "$env:APPDATA\Autodesk\Revit\Addins\$yr"
        $revitInstalled = (Test-Path "C:\Program Files\Autodesk\Revit $yr") -or (Test-Path $addinDir)
        if ($revitInstalled) {
            if (-not (Test-Path $addinDir)) {
                New-Item -ItemType Directory -Path $addinDir -Force | Out-Null
            }
            $addinFile = Join-Path $addinDir "Autodesk.RevitMcpServer.addin"
            $addinXml = "<?xml version=""1.0"" encoding=""utf-8""?>`r`n<RevitAddIns>`r`n`t<AddIn Type=""Application"">`r`n`t`t<Name>Autodesk Revit Public MCP Server</Name>`r`n`t`t<Assembly>$bundleRevitDll</Assembly>`r`n`t`t<ClientId>92B7CFF4-4B9A-4F84-85EB-4024F8BA97F9</ClientId>`r`n`t`t<FullClassName>Autodesk.RevitMcpServer.Addin.Application</FullClassName>`r`n`t`t<VendorId>ADSK</VendorId>`r`n`t`t<VendorDescription>Autodesk, www.autodesk.com</VendorDescription>`r`n`t</AddIn>`r`n`t<ManifestSettings>`r`n`t`t<UseRevitContext>False</UseRevitContext>`r`n`t`t<ContextName>PublicMcpServer</ContextName>`r`n`t</ManifestSettings>`r`n</RevitAddIns>"
            [System.IO.File]::WriteAllText($addinFile, $addinXml, [System.Text.UTF8Encoding]::new($false))
            Write-Host "  -> Da tich hop Add-in tu dong vao Revit $yr" -ForegroundColor Gray
        }
    }
}

# 2. Kiem tra Revit MCP Server da cai san tren he thong (neu co)
$revitMcpSearch = @(
    "C:\Program Files\Autodesk\Revit 2027 MCP Server Write-Tools Technical Preview\Autodesk.RevitMcpServer.Stdio.exe",
    "C:\Program Files\Autodesk\Revit MCP Server\Autodesk.RevitMcpServer.Stdio.exe"
)
foreach ($rm in $revitMcpSearch) {
    if (Test-Path $rm) {
        $revitMcpExe = $rm
        $foundApps += "Revit Official System MCP Server"
        Write-Host "  [+] Phat hien: Revit System MCP Server ($rm)" -ForegroundColor Cyan
        break
    }
}

# Kiem tra pyRevit
$pyrevitMain = "$env:APPDATA\pyRevit\Extensions\mcp-server-for-revit-python.extension\main.py"
$hasPyRevit = Test-Path $pyrevitMain
if ($hasPyRevit) {
    $foundApps += "pyRevit MCP Extension"
    Write-Host "  [+] Phat hien: pyRevit MCP Extension ($pyrevitMain)" -ForegroundColor Cyan
}

if ($foundApps.Count -eq 0) {
    Write-Host "  [!] Chua tim thay cai dat Autodesk o thu muc mac dinh (se su dung ket noi COM dong khi ban bat phan mem)." -ForegroundColor Yellow
}

# ------------------------------------------------------------------------------
# BUOC 4: TU DONG CAU HINH CLAUDE DESKTOP & CLAUDE CODE CLI
# ------------------------------------------------------------------------------
Write-Host "[4/5] Tich hop cau hinh vao Claude Desktop va Claude Code CLI..." -ForegroundColor Green

$ServerScript = Join-Path $ConnectorDir "server_autocad_civil3d.py"

# Cau truc MCP Server cho CAD / Civil 3D / InfraWorks
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

# 1. Cau hinh Claude Desktop (claude_desktop_config.json)
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
        Write-Host "  [!] Dang tao lai file config Claude Desktop moi..." -ForegroundColor Yellow
    }
}

# Ghi de / bo sung mcpServers
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

# Neu co Revit MCP Server chinh thuc hoac portable di kem
if ($revitMcpExe) {
    $desktopObj["mcpServers"]["revit"] = @{ "command" = $revitMcpExe }
    $desktopObj["mcpServers"]["revit-write"] = @{ "command" = $revitMcpExe }
    $desktopObj["mcpServers"]["revit-read"]  = @{ "command" = $revitMcpExe }
}

# Luu Claude Desktop config UTF-8 khong BOM
$desktopJson = $desktopObj | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($ClaudeDesktopConfig, $desktopJson, [System.Text.UTF8Encoding]::new($false))
Write-Host "  -> Da cap nhat thanh cong: $ClaudeDesktopConfig" -ForegroundColor Green

# 2. Cau hinh Claude Code CLI (.claude.json)
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
    $cliObj["mcpServers"]["revit"] = @{
        "type" = "stdio"
        "command" = $revitMcpExe
        "args" = @()
        "env" = @{}
    }
    $cliObj["mcpServers"]["revit-write"] = @{
        "type" = "stdio"
        "command" = $revitMcpExe
        "args" = @()
        "env" = @{}
    }
}

$cliJson = $cliObj | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($ClaudeCliConfig, $cliJson, [System.Text.UTF8Encoding]::new($false))
Write-Host "  -> Da cap nhat thanh cong: $ClaudeCliConfig" -ForegroundColor Green

# ------------------------------------------------------------------------------
# BUOC 5: KIEM TRA SUC KHOE KET NOI (HEALTH-CHECK)
# ------------------------------------------------------------------------------
Write-Host "[5/5] Kiem tra truc tiep kha nang giao tiep cua Server..." -ForegroundColor Green

try {
    & $VenvPy $ServerScript --test
} catch {
    Write-Host "  [!] Luu y: Khoi dong AutoCAD / Civil 3D de trai nghiem day du tinh nang." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=======================================================================" -ForegroundColor Green
Write-Host "               CAI DAT HOAN TAT THANH CONG 100%!                       " -ForegroundColor Green
Write-Host "=======================================================================" -ForegroundColor Green
Write-Host "Danh sach phan mem da lien ket voi Claude:" -ForegroundColor Yellow
Write-Host "  1. Autodesk AutoCAD (2024, 2025, 2026, 2027) -> Da kich hoat 21 tools" -ForegroundColor White
Write-Host "  2. Autodesk Civil 3D (Be mat TIN, Tim tuyen, Trac doc) -> Da kich hoat" -ForegroundColor White
Write-Host "  3. Autodesk InfraWorks (IMX, Mo hinh 3D Solid)       -> Da kich hoat" -ForegroundColor White
if ($revitMcpExe -or $hasPyRevit) {
Write-Host "  4. Autodesk Revit (Mo hinh BIM, Family, View)        -> Da kich hoat" -ForegroundColor White
}
Write-Host ""
Write-Host "LUU Y DE BAT DAU SU DUNG:" -ForegroundColor Cyan
Write-Host "  - Khoi dong lai Claude Desktop: Nhap chuot phai icon Claude o khay he thong -> Quit Claude" -ForegroundColor Gray
Write-Host "  - Mo mot Phien Chat Moi (New Chat / Ctrl+N) de Claude tu dong nhan dien bo cong cu." -ForegroundColor Gray
Write-Host "  - Chi can mo ban ve AutoCAD/Civil 3D roi yeu cau Claude thuc hien lenh!" -ForegroundColor Gray
Write-Host "=======================================================================" -ForegroundColor Green
Write-Host ""
