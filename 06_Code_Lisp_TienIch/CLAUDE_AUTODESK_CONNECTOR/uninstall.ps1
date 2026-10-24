[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Gỡ Bỏ Kết Nối Claude - Autodesk"

Write-Host "=======================================================================" -ForegroundColor Yellow
Write-Host "             GỠ BỎ KẾT NỐI CLAUDE AI VỚI AUTODESK                      " -ForegroundColor Red
Write-Host "=======================================================================" -ForegroundColor Yellow

# Gỡ khỏi Claude Desktop
$ClaudeDesktopConfig = "$env:APPDATA\Claude\claude_desktop_config.json"
if (Test-Path $ClaudeDesktopConfig) {
    try {
        $desktopObj = Get-Content -Path $ClaudeDesktopConfig -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
        if ($desktopObj.ContainsKey("mcpServers")) {
            $desktopObj["mcpServers"].Remove("civil3d-infraworks")
            $desktopObj["mcpServers"].Remove("autocad")
            $desktopJson = $desktopObj | ConvertTo-Json -Depth 10
            [System.IO.File]::WriteAllText($ClaudeDesktopConfig, $desktopJson, [System.Text.UTF8Encoding]::new($false))
            Write-Host "  -> Đã gỡ bỏ cấu hình khỏi Claude Desktop." -ForegroundColor Green
        }
    } catch {}
}

# Gỡ khỏi Claude Code CLI
$ClaudeCliConfig = "$env:USERPROFILE\.claude.json"
if (Test-Path $ClaudeCliConfig) {
    try {
        $cliObj = Get-Content -Path $ClaudeCliConfig -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
        if ($cliObj.ContainsKey("mcpServers")) {
            $cliObj["mcpServers"].Remove("civil3d-infraworks")
            $cliObj["mcpServers"].Remove("autocad")
            $cliJson = $cliObj | ConvertTo-Json -Depth 10
            [System.IO.File]::WriteAllText($ClaudeCliConfig, $cliJson, [System.Text.UTF8Encoding]::new($false))
            Write-Host "  -> Đã gỡ bỏ cấu hình khỏi Claude Code CLI." -ForegroundColor Green
        }
    } catch {}
}

Write-Host ""
Write-Host "Đã hoàn tất gỡ bỏ kết nối!" -ForegroundColor Green
