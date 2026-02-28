#Requires -Version 5.1
$pluginName = "MLZ"
# الرابط المباشر لملفك على GitHub
$pluginLink = "https://raw.githubusercontent.com/MLZDBD/MLZ-Plugin/main/MLZ.zip"

$steamPath = (Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -Name "SteamPath" -ErrorAction SilentlyContinue ).SteamPath
if (-not $steamPath) { exit 1 }

Write-Host "[*] Cleaning old versions and closing Steam..." -ForegroundColor Cyan
Get-Process -Name "steam*" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

$pluginsFolder = Join-Path $steamPath "plugins"
if (-not (Test-Path $pluginsFolder)) { New-Item -Path $pluginsFolder -ItemType Directory | Out-Null }

# حذف أي نسخة قديمة لضمان ظهور النسخة الجديدة
Get-ChildItem $pluginsFolder | Where-Object { $_.Name -match "MLZ|luatools|polar" } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "[*] Downloading MLZ PRO Version..." -ForegroundColor Cyan
$tempZip = Join-Path $env:TEMP "MLZ.zip"
try {
    Invoke-WebRequest -Uri $pluginLink -OutFile $tempZip -UseBasicParsing
    Expand-Archive -Path $tempZip -DestinationPath (Join-Path $pluginsFolder $pluginName) -Force
    Remove-Item $tempZip -Force
    Write-Host "[+] MLZ PRO Installed Successfully!" -ForegroundColor Green
} catch {
    Write-Host "[!] Download Failed. Please check your GitHub link." -ForegroundColor Red
}

Start-Process (Join-Path $steamPath "steam.exe")
Start-Sleep -Seconds 3
