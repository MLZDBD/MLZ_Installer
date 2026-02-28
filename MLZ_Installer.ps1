#Requires -Version 5.1
chcp 65001 | Out-Null
$OutputEncoding = [Console]::OutputEncoding = [Text.Encoding]::UTF8

# Check Admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

$pluginName = "MLZ"
$pluginLink = "https://raw.githubusercontent.com/MLZDBD/MLZ-Plugin./refs/heads/main/MLZ_Final_Independent_Plugin.zip"

# Detect Steam
$steamPath = (Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -Name "SteamPath" -ErrorAction SilentlyContinue ).SteamPath
if (-not $steamPath) { Write-Host "Steam not found!"; exit 1 }

# Close Steam
Stop-Process -Name "steam*" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Install
$pluginsFolder = Join-Path $steamPath "plugins"
if (-not (Test-Path $pluginsFolder)) { New-Item -Path $pluginsFolder -ItemType Directory | Out-Null }
$pluginPath = Join-Path $pluginsFolder $pluginName
if (Test-Path $pluginPath) { Remove-Item $pluginPath -Recurse -Force -ErrorAction SilentlyContinue }

$tempZip = Join-Path $env:TEMP "MLZ.zip"
Invoke-WebRequest -Uri $pluginLink -OutFile $tempZip -UseBasicParsing
Expand-Archive -Path $tempZip -DestinationPath $pluginPath -Force
Remove-Item $tempZip -Force

# Launch
Start-Process (Join-Path $steamPath "steam.exe")
Write-Host "MLZ Installed Successfully!" -ForegroundColor Cyan
Start-Sleep -Seconds 3
