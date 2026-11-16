<#
.SYNOPSIS
    Non-destructive slot switch into TWRP Recovery on slot B for Lenovo Tab M11 (TB311FU).
#>
[CmdletBinding()]
param(
    [string]$Serial = "HNQ09EZD",
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"
$fb = (Get-Command fastboot -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source)
if (-not $fb -and (Test-Path "C:\platform-tools\fastboot.exe")) { $fb = "C:\platform-tools\fastboot.exe" }
if (-not $fb) { $fb = "fastboot" }

Write-Host "=== Switching Active Slot to B (Recovery) ===" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "[DRY RUN] Would execute:" -ForegroundColor Green
    Write-Host "  $fb -s $Serial --set-active=b" -ForegroundColor Yellow
    Write-Host "  $fb -s $Serial reboot recovery" -ForegroundColor Yellow
    exit 0
}

& $fb -s $Serial --set-active=b
& $fb -s $Serial reboot recovery
Write-Host "Rebooting into TWRP recovery on slot B..." -ForegroundColor Green
