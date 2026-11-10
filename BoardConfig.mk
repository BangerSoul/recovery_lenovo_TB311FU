#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 TeamWin Recovery Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Device Path & Identification
DEVICE_PATH := device/lenovo/TB311FU

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a75

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_VARIANT := cortex-a55

# Board Platform & Chipset
TARGET_BOARD_PLATFORM := mt6768
TARGET_BOOTLOADER_BOARD_NAME := tb8786p1_64_k66
BOARD_HAS_NO_SELECT_SYSTEM := true
TARGET_NO_KERNEL := true
BOARD_KERNEL_IMAGE_NAME := kernel

# GKI 2.0 & Boot Header v4 Recovery Architecture
BOARD_BOOT_HEADER_VERSION := 4
BOARD_USES_VENDOR_BOOT := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)

# Dynamic Super Partition Geometry (9.00 GiB / 9,663,676,416 bytes)
BOARD_SUPER_PARTITION_SIZE := 9663676416
BOARD_SUPER_PARTITION_GROUPS := mtk_dynamic_partitions
BOARD_MTK_DYNAMIC_PARTITIONS_SIZE := 9659482112
BOARD_MTK_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor product system_ext odm

# Virtual A/B Slot Architecture
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    system \
    vendor \
    product \
    system_ext \
    odm

# Fastbootd Userspace Dynamic Partition Flashing
TW_INCLUDE_FASTBOOTD := true

# Cryptography & File-Based Encryption (FBE v2)
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
BOARD_USES_METADATA_PARTITION := true
PLATFORM_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 15
TW_PREPARE_DATA_MEDIA_EARLY := true

# MinUI Display Configuration (1920x1200 WUXGA Landscape)
TW_THEME := landscape_hdpi
TW_SCREEN_WIDTH := 1920
TW_SCREEN_HEIGHT := 1200
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
RECOVERY_GRAPHICS_FORCE_USE_LINELENGTH := true
TW_NO_SCREEN_BLANK := true

# Backlight & Brightness Mapping (11-bit PWM, 0 to 2047)
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 2047
TW_DEFAULT_BRIGHTNESS := 1200

# Touchscreen Digitizer & Input Calibration
TW_ROTATION := 0
TW_SUPPORT_INPUT_1_2_HACK := true
TW_INPUT_BLACKLIST := "hbtp_vm"

# Battery & Fuel Gauge Monitoring (MT6358 PMIC / SGM41512 Charger)
TW_NO_BATT_PERCENT := false
TW_BATTERY_SYSFS_PATH := "/sys/class/power_supply/battery"
TW_CUSTOM_BATTERY_PATH := "/sys/class/power_supply/battery"

# Storage Configuration & Mounts
TW_HAS_MTP := true
TW_USE_TOOLBOX := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_INTERNAL_STORAGE_PATH := "/data/media/0"
TW_INTERNAL_STORAGE_MOUNT_POINT := "data"
TW_EXTERNAL_STORAGE_PATH := "/external_sd"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"

# Recovery Device Directory Inclusion
TARGET_RECOVERY_DEVICE_DIRS += device/lenovo/TB311FU
