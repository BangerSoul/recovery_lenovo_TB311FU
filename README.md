# recovery_lenovo_TB311FU

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Target: Lenovo Tab M11](https://img.shields.io/badge/Device-Lenovo%20Tab%20M11%20(TB311FU)-orange.svg)](https://www.lenovo.com)
[![Branch: main](https://img.shields.io/badge/Branch-main-success.svg)](https://github.com/BangerSoul/recovery_lenovo_TB311FU)
[![Recovery: TWRP 3.7+](https://img.shields.io/badge/Recovery-TWRP%203.7%2B-blueviolet.svg)](https://twrp.me)

Team Win Recovery Project (TWRP) recovery device tree, secondary slot `boot_b` chained boot vector deployment, BCB handling, and non-destructive slot switching suite for the **Lenovo Tab M11** (`TB311FU`, codename `poplar`, MediaTek Helio G88 / MT8786 / MT6768).

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
