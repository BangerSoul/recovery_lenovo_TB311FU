# recovery_lenovo_TB311FU

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Target: Lenovo Tab M11](https://img.shields.io/badge/Device-Lenovo%20Tab%20M11%20(TB311FU)-orange.svg)](https://www.lenovo.com)
[![Branch: main](https://img.shields.io/badge/Branch-main-success.svg)](https://github.com/BangerSoul/recovery_lenovo_TB311FU)
[![Branch: feature/orangefox-mt8786](https://img.shields.io/badge/Branch-orangefox--mt8786-orange.svg)](https://github.com/BangerSoul/recovery_lenovo_TB311FU/tree/feature/orangefox-mt8786)
[![Recovery: OrangeFox R12.1](https://img.shields.io/badge/Recovery-OrangeFox%20R12.1-ff5722.svg)](https://orangefox.tech)
[![Recovery: TWRP 3.7+](https://img.shields.io/badge/Recovery-TWRP%203.7%2B-blueviolet.svg)](https://twrp.me)

OrangeFox Recovery Project (R12.1) & Team Win Recovery Project (TWRP) recovery device tree, secondary slot `boot_b` chained boot vector deployment, BCB handling, and non-destructive slot switching suite for the **Lenovo Tab M11** (`TB311FU`, codename `poplar`, MediaTek Helio G88 / MT8786 / MT6768).

---

## 🌐 Lenovo Tab M11 (TB311FU / poplar) Open-Source Bringup Ecosystem

The complete open-source software stack for the **Lenovo Tab M11** (`TB311FU`, codename `poplar`, MediaTek Helio G88 / MT8786 / MT6768) is organized into five specialized, interconnected repositories under [@BangerSoul](https://github.com/BangerSoul):

| Repository | Role & Subsystem Scope | Target Stack | Key Deliverables & Artifacts | Badges & Links |
| :--- | :--- | :--- | :--- | :---: |
| [**`device_lenovo_TB311FU`**](https://github.com/BangerSoul/device_lenovo_TB311FU) | **Device Tree & RRO Overlays**<br>LineageOS device configuration, 90Hz display profiles, SystemUI/Framework RRO overlays, super partition budget management, and 5-tier diagnostic test suite. | Android 16 QPR2<br>LineageOS 23.2 / 22.1 | `TrebleOverlayLenovoTB311FU.apk`<br>`TrebleOverlayLenovoTB311FUSystemUI.apk`<br>`flash_lineage23_fastbootd.ps1`<br>E2E Diagnostic Test Suite | [![Device Tree](https://img.shields.io/badge/Repo-device__lenovo__TB311FU-blue.svg?logo=android)](https://github.com/BangerSoul/device_lenovo_TB311FU)<br>[![Releases](https://img.shields.io/badge/Releases-v1.0--lineage23-blue.svg)](https://github.com/BangerSoul/device_lenovo_TB311FU/releases) |
| [**`vendor_lenovo_TB311FU`**](https://github.com/BangerSoul/vendor_lenovo_TB311FU) | **Vendor Blobs & Hardware Policies**<br>Proprietary blobs, 4-speaker surround audio routing (`AUDIO_CHANNEL_OUT_QUAD`), Dolby Atmos DAP/DRC trees, AP500U active stylus IDC configs, and EROFS vendor repacking tools. | Android 16 QPR2<br>LineageOS 23.2 HALs | `vendor_stabilized.img` (EROFS LZ4)<br>`audio_policy_configuration.xml`<br>`audio_effects.xml`<br>`himax-touchscreen.idc` / `NVT-ts.idc` | [![Vendor Blobs](https://img.shields.io/badge/Repo-vendor__lenovo__TB311FU-orange.svg?logo=android)](https://github.com/BangerSoul/vendor_lenovo_TB311FU)<br>[![Releases](https://img.shields.io/badge/Releases-Assets-orange.svg)](https://github.com/BangerSoul/vendor_lenovo_TB311FU/releases) |
| [**`kernel_lenovo_TB311FU`**](https://github.com/BangerSoul/kernel_lenovo_TB311FU) | **PoplarKernel GKI 2.0 & AVB Vector**<br>Downstream Linux 6.6 LTS kernel, KernelSU-Next native integration, module signature bypass (`CONFIG_RFKILL=m`), permissive dm-verity, PWM >= 48 floor clamp, and 32MB LK AVB boot vector builder. | Linux 6.6 LTS GKI 2.0<br>Android 15 / 16 & Halium | PoplarKernel v1.2 AnyKernel3 Zip<br>32MB AVB Chained `boot.img`<br>Halium `Image.gz` / `dtbo.img`<br>CI/CD Automated Build Actions | [![Kernel](https://img.shields.io/badge/Repo-kernel__lenovo__TB311FU-teal.svg?logo=linux)](https://github.com/BangerSoul/kernel_lenovo_TB311FU)<br>[![Releases](https://img.shields.io/badge/Releases-v1.2-teal.svg)](https://github.com/BangerSoul/kernel_lenovo_TB311FU/releases) |
| [**`recovery_lenovo_TB311FU`**](https://github.com/BangerSoul/recovery_lenovo_TB311FU) | **TWRP 3.7+ Recovery & Slot B Vector**<br>Non-destructive custom recovery deployment to secondary slot `boot_b`, pristine factory `vendor_boot` & `vbmeta` preservation, BCB staging, and zero-risk slot switching. | Android Header v4<br>TWRP 3.7+ / OrangeFox | Slot B Chained `recovery_boot.img`<br>Turnkey Hybrid `vendor_boot.img`<br>Bootloader Control Block Tools<br>CI/CD Automated Build Actions | [![Recovery](https://img.shields.io/badge/Repo-recovery__lenovo__TB311FU-blueviolet.svg?logo=twrp)](https://github.com/BangerSoul/recovery_lenovo_TB311FU)<br>[![Releases](https://img.shields.io/badge/Releases-v1.0--twrp-blueviolet.svg)](https://github.com/BangerSoul/recovery_lenovo_TB311FU/releases) |
| [**`linux-lenovo-tb311fu`**](https://github.com/BangerSoul/linux-lenovo-tb311fu) | **Native Linux / PostmarketOS Port**<br>Alpine ARM64 + KDE Plasma Mobile 6 port, KWin Wayland 24-bit True Color fallback & rotation fix (`libkwin.so.6.7.5`), WMT Wi-Fi/BT daemons, quad ALSA UCM scenarios, and Fastbootd direct `system_a` flasher. | PostmarketOS<br>Alpine ARM64 / Plasma Mobile 6 | `device-lenovo-tb311fu` package<br>`linux-lenovo-tb311fu` package<br>`libkwin.so.6.7.5.patched`<br>Fastbootd `-S 64M` Rootfs Flasher | [![Linux Port](https://img.shields.io/badge/Repo-linux--lenovo--tb311fu-success.svg?logo=postmarketos)](https://github.com/BangerSoul/linux-lenovo-tb311fu)<br>[![Releases](https://img.shields.io/badge/Releases-v1.0--alpha-success.svg)](https://github.com/BangerSoul/linux-lenovo-tb311fu/releases) |

---

## Architecture: Secondary Slot Recovery Vector (`boot_b`)

In standard MediaTek GKI 2.0 architectures, flashing TWRP to `vendor_boot` breaks Little Kernel (LK) RSA4096 signature verification, causing immediate 2-second Orange State reboot loops and requiring full factory re-flashing.

To guarantee 100% factory firmware preservation and non-destructive recovery access:

1. **Factory Firmware Preservation:**
   - OEM `vendor_boot` remains **100% stock and untouched** on flash.
   - OEM `vbmeta` remains **100% factory signed** with `flags = 0x00`.
2. **Dual-Slot Allocation:**
   - **Slot `_a`**: Production OS (LineageOS 23.2 / GSI / PostmarketOS with PoplarKernel GKI 2.0).
   - **Slot `_b`**: Custom Recovery Vector (`recovery_boot.img` containing the TWRP ramdisk assembled in an Android Header v4 vector with aligned OEM VBMeta block).
3. **Non-Destructive Slot Switching:**
   - Transitioning into TWRP executes purely via slot switching:
     ```bash
     fastboot --set-active=b && fastboot reboot recovery
     ```
   - Returning to the primary OS switches back:
     ```bash
     fastboot --set-active=a && fastboot reboot
     ```
4. **Bootloader Control Block (BCB) Handling:**
   - Tools in `tools/dual_boot_manager.py` handle BCB message reading, formatting, and zeroing (`/dev/block/by-name/misc`), preventing stuck recovery boot loops.

---

## Deployment & Usage

### 1. Deploy Recovery Vector to Slot B
```powershell
.\scripts\deploy_recovery_boot_b.ps1 -ImagePath recovery_boot.img
```
*Validates the 32 MB (33,554,432 B) alignment and flashes exclusively to `boot_b`.*

### 2. Enter TWRP Recovery (Slot B)
- From Host Fastboot:
  ```powershell
  .\scripts\switch_to_recovery.ps1
  ```
- Or on Linux:
  ```bash
  ./scripts/switch_to_recovery.sh
  ```

### 3. Return to Production OS (Slot A)
- From Host Fastboot:
  ```powershell
  .\scripts\switch_to_os.ps1
  ```
- Or on Linux:
  ```bash
  ./scripts/switch_to_os.sh
  ```

---

## Included Tools & Verification Suites

- **`tools/dual_boot_manager.py`**: Python CLI managing dual-boot slot transitions, cryptographic AVB verification, and BCB staging.
- **`tools/verify_avb_chain.py`**: Cryptographic verifier for 32MB boot vectors, validating the OEM 2,432-byte VBMeta block and AVB footer.
- **`tools/test_kernel_recovery.py`**: Automated unit test suite verifying BCB serialization, AVB salt verification, and slot switching safety.

---

## Maintainer

- **Maintainer:** Azmathulla Shaik ([@BangerSoul](https://github.com/BangerSoul))
- **Email:** `iamshaikhazmathulla@outlook.com`
