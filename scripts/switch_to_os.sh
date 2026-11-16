#!/bin/sh
set -eu
SERIAL="${1:-HNQ09EZD}"
echo "=== Switching Active Slot to A (Production OS) ==="
fastboot -s "$SERIAL" --set-active=a
fastboot -s "$SERIAL" reboot
echo "Rebooting into Production OS on slot A..."
