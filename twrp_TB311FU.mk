#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 TeamWin Recovery Project
# Copyright (C) 2026 OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

-include vendor/twrp/config/common.mk
-include vendor/recovery/config/common.mk
-include vendor/fox/config/common.mk

PRODUCT_DEVICE := TB311FU
PRODUCT_NAME := twrp_TB311FU
PRODUCT_BRAND := Lenovo
PRODUCT_MODEL := Lenovo Tab with Clear Case (TB311FU)
PRODUCT_MANUFACTURER := Lenovo

PRODUCT_PACKAGES += \
    init.recovery.mt6768.rc \
    twrp.flags \
    recovery.fstab \
    fstab.mt6768
