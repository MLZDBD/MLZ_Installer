#Requires -Version 5.1
$pluginName = "MLZ"
# الرابط المباشر والبسيط
$pluginLink = "https://raw.githubusercontent.com/MLZDBD/MLZ-Plugin/main/MLZ.zip"

$steamPath = (Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -Name "SteamPath" -ErrorAction SilentlyContinue ).SteamPath
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
    # محاولة التحميل مع تجاهل شهادات الأمان لضمان النجاح
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $pluginLink -OutFile $tempZip -UseBasicParsing -TimeoutSec 30
    
    if (Test-Path $tempZip) {
        Expand-Archive -Path $tempZip -DestinationPath $pluginPath -Force
        Remove-Item $tempZip -Force
        Write-Host "[+] MLZ Installed Successfully!" -ForegroundColor Green
    } else {
        throw "File not downloaded"
    }
} catch {
    Write-Host "[!] Download Failed. Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "[!] Please make sure the file 'MLZ.zip' exists in your GitHub repository." -ForegroundColor Yellow
}

Start-Process (Join-Path $steamPath "steam.exe")
Start-Sleep -Seconds 3
