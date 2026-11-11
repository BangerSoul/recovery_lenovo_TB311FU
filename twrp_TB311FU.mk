#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 TeamWin Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
-include vendor/twrp/config/common.mk

PRODUCT_DEVICE := TB311FU
PRODUCT_NAME := twrp_TB311FU
PRODUCT_BRAND := Lenovo
PRODUCT_MODEL := Lenovo Tab M11
PRODUCT_MANUFACTURER := Lenovo

# Recovery Configuration & Hardware Initialization Files
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/init.recovery.mt6768.rc:root/init.recovery.mt6768.rc \
    $(DEVICE_PATH)/init.recovery.mt6768.rc:recovery/root/init.recovery.mt6768.rc \
    $(DEVICE_PATH)/etc/recovery.fstab:root/system/etc/recovery.fstab \
    $(DEVICE_PATH)/etc/recovery.fstab:recovery/root/system/etc/recovery.fstab \
    $(DEVICE_PATH)/etc/recovery.fstab:root/first_stage_ramdisk/fstab.mt6768 \
    $(DEVICE_PATH)/etc/recovery.fstab:recovery/root/first_stage_ramdisk/fstab.mt6768 \
    $(DEVICE_PATH)/etc/twrp.flags:root/system/etc/twrp.flags \
    $(DEVICE_PATH)/etc/twrp.flags:recovery/root/system/etc/twrp.flags

PRODUCT_PACKAGES += \
    init.recovery.mt6768.rc \
    twrp.flags \
    recovery.fstab
