#!/bin/sh
set -eu
SERIAL="${1:-HNQ09EZD}"
echo "=== Switching Active Slot to B (Recovery) ==="
fastboot -s "$SERIAL" --set-active=b
fastboot -s "$SERIAL" reboot recovery
echo "Rebooting into TWRP recovery on slot B..."
