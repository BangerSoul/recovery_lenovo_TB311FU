#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 The LineageOS Project
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

# Target Architecture
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

# MediaTek MT6768 / MT8786 Physical DRAM Architecture (Base 0x40000000)
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_OFFSET := 0x00080000
BOARD_RAMDISK_OFFSET := 0x07c80000
BOARD_DTB_OFFSET := 0x0bc80000
BOARD_TAGS_OFFSET := 0x0bc80000
BOARD_PAGE_SIZE := 4096
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 buildvariant=eng

# GKI 2.0 & Boot Header v4 Recovery Architecture
BOARD_BOOT_HEADER_VERSION := 4
BOARD_VENDOR_BOOT_HEADER_VERSION := 4
BOARD_USES_VENDOR_BOOT := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
TARGET_NO_RECOVERY := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION) --base $(BOARD_KERNEL_BASE) --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --dtb_offset $(BOARD_DTB_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET) --pagesize $(BOARD_PAGE_SIZE)

# Dynamic Super Partition Geometry (11.00 GiB / 11,811,160,064 bytes)
BOARD_SUPER_PARTITION_SIZE := 11811160064
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 11809062912
BOARD_MAIN_PARTITION_LIST := system vendor product system_ext

# Virtual A/B Slot Architecture
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    vendor_boot \
    dtbo \
    vbmeta \
    system \
    vendor \
    product \
    system_ext

# Android Verified Boot (AVB 2.0)
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true

# Recovery FSTAB Configuration
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab

# AOSP Standard Recovery UI & Security
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
BOARD_USES_METADATA_PARTITION := true
PLATFORM_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 16
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)

# Recovery UI Theme Configuration (MinUI 1200x1920 WUXGA)
TARGET_SCREEN_WIDTH := 1200
TARGET_SCREEN_HEIGHT := 1920
DEVICE_SCREEN_WIDTH := 1200
DEVICE_SCREEN_HEIGHT := 1920
TW_SCREEN_WIDTH := 1200
TW_SCREEN_HEIGHT := 1920
TW_THEME := portrait_hdpi

# Recovery Device Directory Inclusion
TARGET_RECOVERY_DEVICE_DIRS += device/lenovo/TB311FU
