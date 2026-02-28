#Requires -Version 5.1
$pluginName = "MLZ"
# الرابط المصلح بناءً على اسم الملف الجديد في حسابك
$pluginLink = "https://raw.githubusercontent.com/MLZDBD/MLZ-Plugin/main/MLZ_Clean_Version%20(2 ).zip"

$steamPath = (Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -Name "SteamPath" -ErrorAction SilentlyContinue).SteamPath
if (-not $steamPath) { exit 1 }

Write-Host "[*] Closing Steam..." -ForegroundColor Cyan
Get-Process -Name "steam*" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

$pluginsFolder = Join-Path $steamPath "plugins"
if (-not (Test-Path $pluginsFolder)) { New-Item -Path $pluginsFolder -ItemType Directory | Out-Null }
$pluginPath = Join-Path $pluginsFolder $pluginName
if (Test-Path $pluginPath) { Remove-Item $pluginPath -Recurse -Force -ErrorAction SilentlyContinue }

Write-Host "[*] Downloading MLZ Plugin..." -ForegroundColor Cyan
$tempZip = Join-Path $env:TEMP "MLZ.zip"
try {
    # استخدام -OutFile لضمان تحميل الملف بشكل صحيح
    Invoke-WebRequest -Uri $pluginLink -OutFile $tempZip -UseBasicParsing
    Expand-Archive -Path $tempZip -DestinationPath $pluginPath -Force
    Remove-Item $tempZip -Force
    Write-Host "[+] MLZ Installed Successfully!" -ForegroundColor Green
} catch {
    Write-Host "[!] Download Failed. Please check your internet or GitHub link." -ForegroundColor Red
}

Start-Process (Join-Path $steamPath "steam.exe")
Start-Sleep -Seconds 3
