#
# Copyright (C) 2026 TeamWin Recovery Project
# Copyright (C) 2026 OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# OrangeFox build environment variables for Lenovo Tab M11 (TB311FU / poplar)
export FOX_BUILD_DEVICE="TB311FU"
export FOX_VERSION="R12.1"
export OF_MAINTAINER="BangerSoul"

# MinUI Screen Dimensions (1200x1920 Portrait WUXGA)
export OF_SCREEN_H=1920
export OF_SCREEN_W=1200
export OF_STATUS_H=80
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_HIDE_NOTCH=1

# OrangeFox Engine Flags
export OF_USE_MAGISKBOOT=1
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
export OF_SUPPORT_ALL_VB_META_VERSIONS=1
export OF_AB_DEVICE=1
export OF_OTG_IS_SUPPORTED=1
export OF_DISABLE_MIUI_SPECIFIC_FEATURES=1
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
export OF_FLASHLIGHT_ENABLE=0
export OF_ALLOW_DISABLE_NAVBAR=0
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export FOX_REPLACE_BOOTIMAGE_DATE=1
export FOX_ASH_IS_BASH=1

# Register lunch combos
add_lunch_combo omni_TB311FU-eng
add_lunch_combo omni_TB311FU-userdebug
add_lunch_combo twrp_TB311FU-eng
add_lunch_combo twrp_TB311FU-userdebug
