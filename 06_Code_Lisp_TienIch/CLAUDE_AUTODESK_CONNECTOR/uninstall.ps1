[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Go Bo Ket Noi Claude - Autodesk"

Write-Host "=======================================================================" -ForegroundColor Yellow
Write-Host "             GO BO KET NOI CLAUDE AI VOI AUTODESK                      " -ForegroundColor Red
Write-Host "=======================================================================" -ForegroundColor Yellow

# Go khoi Claude Desktop
$ClaudeDesktopConfig = "$env:APPDATA\Claude\claude_desktop_config.json"
if (Test-Path $ClaudeDesktopConfig) {
    try {
        $desktopObj = Get-Content -Path $ClaudeDesktopConfig -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
        if ($desktopObj.ContainsKey("mcpServers")) {
            $desktopObj["mcpServers"].Remove("civil3d-infraworks")
            $desktopObj["mcpServers"].Remove("autocad")
            $desktopJson = $desktopObj | ConvertTo-Json -Depth 10
            [System.IO.File]::WriteAllText($ClaudeDesktopConfig, $desktopJson, [System.Text.UTF8Encoding]::new($false))
            Write-Host "  -> Da go bo cau hinh khoi Claude Desktop." -ForegroundColor Green
        }
    } catch {}
}

# Go khoi Claude Code CLI
$ClaudeCliConfig = "$env:USERPROFILE\.claude.json"
if (Test-Path $ClaudeCliConfig) {
    try {
        $cliObj = Get-Content -Path $ClaudeCliConfig -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
        if ($cliObj.ContainsKey("mcpServers")) {
            $cliObj["mcpServers"].Remove("civil3d-infraworks")
            $cliObj["mcpServers"].Remove("autocad")
            $cliJson = $cliObj | ConvertTo-Json -Depth 10
            [System.IO.File]::WriteAllText($ClaudeCliConfig, $cliJson, [System.Text.UTF8Encoding]::new($false))
            Write-Host "  -> Da go bo cau hinh khoi Claude Code CLI." -ForegroundColor Green
        }
    } catch {}
}

Write-Host ""
Write-Host "Da hoan tat go bo ket noi!" -ForegroundColor Green
