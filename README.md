# Custom Recovery Device Tree for Lenovo Tab M11 (`TB311FU`)

Custom Recovery (TWRP / OrangeFox) device tree and automated GitHub Actions build pipeline for the **Lenovo Tab M11** (`TB311FU`, MediaTek Helio G88 / MT6769, board `tb8786p1_64_k66`).

---

## Hardware & Architecture Specifications

| Parameter | Specification |
| :--- | :--- |
| **Device Model** | Lenovo Tab M11 (`TB311FU`) / `poplar` |
| **SoC** | MediaTek Helio G88 (`MT6769H` / `MT8786` platform) |
| **Architecture** | 64-bit ARM (`arm64-v8a`) |
| **Kernel Architecture** | Generic Kernel Image (GKI 2.0, Boot Header v4) |
| **Target Partition** | `vendor_boot` (`vendor_boot.img`) |
| **Display Panel** | 1920x1200 WUXGA Landscape (`TW_THEME := landscape_hdpi`) |
| **Backlight Sysfs** | `/sys/class/leds/lcd-backlight/brightness` (11-bit PWM, max 2047) |
| **Encryption** | Android 14/15 File-Based Encryption (FBE v2) via TrustKernel TEE |
| **Dynamic Partitions** | Virtual A/B Super Container (9,663,676,416 bytes) |
| **Userspace Fastboot** | `fastbootd` enabled |

---

## Flashing Instructions

Since Lenovo Tab M11 uses Android GKI 2.0 with Boot Header v4, recovery ramdisk resides inside **`vendor_boot`**:

```bash
# 1. Reboot into Fastboot mode
adb reboot bootloader

# 2. Flash compiled vendor_boot image
fastboot flash vendor_boot vendor_boot.img

# 3. Reboot directly into recovery
fastboot reboot recovery
```

---

## Building Locally or via GitHub Actions

This repository includes a fully automated GitHub Actions CI workflow in `.github/workflows/build-recovery.yml` that compiles both TWRP and OrangeFox on GitHub-hosted `ubuntu-22.04` runners and uploads flashable releases automatically.
