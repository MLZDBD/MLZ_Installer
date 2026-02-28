#Requires -Version 5.1
$pluginName = "MLZ"
# الرابط أدناه يشير إلى النسخة النظيفة التي تعمل 100%
$pluginLink = "https://raw.githubusercontent.com/MLZDBD/MLZ-Plugin./main/MLZ_Clean_Version.zip"

$steamPath = (Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -Name "SteamPath" ).SteamPath
if (-not $steamPath) { exit 1 }

Get-Process -Name "steam*" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

$pluginsFolder = Join-Path $steamPath "plugins"
if (-not (Test-Path $pluginsFolder)) { New-Item -Path $pluginsFolder -ItemType Directory }
$pluginPath = Join-Path $pluginsFolder $pluginName
if (Test-Path $pluginPath) { Remove-Item $pluginPath -Recurse -Force }

$tempZip = Join-Path $env:TEMP "MLZ.zip"
Invoke-WebRequest -Uri $pluginLink -OutFile $tempZip -UseBasicParsing
Expand-Archive -Path $tempZip -DestinationPath $pluginPath -Force
Remove-Item $tempZip -Force

Start-Process (Join-Path $steamPath "steam.exe")
Write-Host "MLZ Installed Successfully!" -ForegroundColor Green
Start-Sleep -Seconds 3
