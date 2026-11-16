<#
.SYNOPSIS
    Deploy TWRP Recovery Vector to Secondary Slot (boot_b) on Lenovo Tab M11 (TB311FU).
.DESCRIPTION
    Flashes 32MB chained recovery_boot.img vector directly to boot_b, keeping boot_a (OS)
    and factory vendor_boot 100% untouched to preserve stock cryptographic integrity.
#>
[CmdletBinding()]
param(
    [string]$ImagePath = "recovery_boot.img",
    [string]$Serial = "HNQ09EZD",
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"

$fb = (Get-Command fastboot -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source)
if (-not $fb -and (Test-Path "C:\platform-tools\fastboot.exe")) {
    $fb = "C:\platform-tools\fastboot.exe"
}
if (-not $fb) { $fb = "fastboot" }

Write-Host "=== Deploying TWRP Recovery Vector to Slot B ===" -ForegroundColor Cyan
Write-Host "Target Image: $ImagePath" -ForegroundColor Yellow
Write-Host "Target Device: $Serial" -ForegroundColor Yellow

if (-not (Test-Path $ImagePath)) {
    throw "Target recovery image not found at: $ImagePath"
}

# Image size verification: must be strictly 32MB (33,554,432 bytes)
$size = (Get-Item $ImagePath).Length
if ($size -ne 33554432) {
    throw "Invalid recovery image size: $size B. Must be strictly 33,554,432 B (32 MB) to prevent LK 2-second reboot loops."
}

if ($DryRun) {
    Write-Host "[DRY RUN] Would execute: $fb -s $Serial flash boot_b `"$ImagePath`"" -ForegroundColor Green
    Write-Host "[DRY RUN] Safety confirmed: vendor_boot and vbmeta remain 100% factory stock." -ForegroundColor Green
    exit 0
}

Write-Host "Flashing recovery image to boot_b..." -ForegroundColor Yellow
& $fb -s $Serial flash boot_b $ImagePath

Write-Host "Verification: Reading back slot status..." -ForegroundColor Yellow
& $fb -s $Serial getvar current-slot
& $fb -s $Serial getvar slot-unbootable:b
& $fb -s $Serial getvar slot-retry-count:b

Write-Host "Deployment Complete! To boot into TWRP recovery at any time, run:" -ForegroundColor Green
Write-Host "  .\scripts\switch_to_recovery.ps1" -ForegroundColor Cyan
