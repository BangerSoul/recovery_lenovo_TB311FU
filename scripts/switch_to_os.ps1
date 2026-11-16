<#
.SYNOPSIS
    Non-destructive slot switch into Main OS on slot A for Lenovo Tab M11 (TB311FU).
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

Write-Host "=== Switching Active Slot to A (Production OS) ===" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "[DRY RUN] Would execute:" -ForegroundColor Green
    Write-Host "  $fb -s $Serial --set-active=a" -ForegroundColor Yellow
    Write-Host "  $fb -s $Serial reboot" -ForegroundColor Yellow
    exit 0
}

& $fb -s $Serial --set-active=a
& $fb -s $Serial reboot
Write-Host "Rebooting into Production OS on slot A..." -ForegroundColor Green
