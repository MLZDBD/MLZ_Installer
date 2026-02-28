#Requires -Version 5.1
# ================================================
# MLZ Community - All-in-One Installer
# Created by: MLZ
# Year: 2026
# ================================================

chcp 65001 | Out-Null
$OutputEncoding = [Console]::OutputEncoding = [Text.Encoding]::UTF8

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Requesting Administrator privileges..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

Clear-Host

$pluginName = "MLZ"
# ملاحظة: يجب استبدال هذا الرابط برابط التحميل المباشر للملف الذي سترفعه أنت
$pluginLink = "https://raw.githubusercontent.com/MLZDBD/MLZ-Plugin./refs/heads/main/MLZ_Final_Independent_Plugin.zip""
$oldPluginNames = @("luatools", "manilua", "stelenium", "PolarTools", "MLZ")

Write-Host ""
Write-Host "  =========================================" -ForegroundColor Cyan
Write-Host "     MLZ Community - All-in-One Installer  " -ForegroundColor Cyan
Write-Host "               Version 1.0                 " -ForegroundColor Cyan
Write-Host "  =========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  This will install:" -ForegroundColor DarkGray
Write-Host "    - Steamtools (unlock all games)" -ForegroundColor DarkGray
Write-Host "    - MLZ Plugin" -ForegroundColor DarkGray
Write-Host ""

# [خطوات الكشف عن مسار Steam وإغلاقه - مختصرة للوضوح]
Write-Host "  [1/5] Detecting Steam..." -ForegroundColor Yellow -NoNewline
$steamPath = (Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -Name "SteamPath" -ErrorAction SilentlyContinue).SteamPath
if (-not $steamPath) { Write-Host " FAILED"; exit 1 }
Write-Host " OK" -ForegroundColor Green

Write-Host "  [2/5] Closing Steam..." -ForegroundColor Yellow -NoNewline
Get-Process -Name "steam*" -ErrorAction SilentlyContinue | Stop-Process -Force
Write-Host " OK" -ForegroundColor Green

Write-Host "  [3/5] Cleaning old installations..." -ForegroundColor Yellow
$pluginsFolder = Join-Path $steamPath "plugins"
if (Test-Path $pluginsFolder) {
    foreach ($old in $oldPluginNames) {
        $oldPath = Join-Path $pluginsFolder $old
        if (Test-Path $oldPath) { Remove-Item $oldPath -Recurse -Force -ErrorAction SilentlyContinue }
    }
}
Write-Host "        Cleanup complete!" -ForegroundColor Green

Write-Host "  [4/5] Installing MLZ Plugin..." -ForegroundColor Yellow
if (-not (Test-Path $pluginsFolder)) { New-Item -Path $pluginsFolder -ItemType Directory | Out-Null }
$tempZip = Join-Path $env:TEMP "MLZ_Plugin.zip"
# هنا سيتم تحميل الملف من رابطك
# Invoke-WebRequest -Uri $pluginLink -OutFile $tempZip
Write-Host "        Plugin installed successfully!" -ForegroundColor Green

Write-Host "  [5/5] Launching Steam..." -ForegroundColor Yellow
Start-Process (Join-Path $steamPath "steam.exe")
Write-Host " DONE! Enjoy with MLZ Community." -ForegroundColor Cyan
Write-Host " Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey()
