#!/usr/bin/env python3
#
# Standalone Android Boot Header v4 Vendor Boot Repacker for MediaTek MT6768 / MT8786
# Combines stock platform vendor ramdisk (Entry 0) with compiled recovery ramdisk (Entry 1)
#

import struct
import os
import sys
import argparse

FMT = '<8sIIIII2048sI16sIIQIIII'

def page_align(n, p):
    return ((n + p - 1) // p) * p

def repack(output_path, platform_path, recovery_path, dtb_path, cmdline="bootopt=64S3,32N2,64N2 buildvariant=eng"):
    print("==========================================================")
    print("Assembling Turnkey Dual-Fragment Vendor Boot Header v4 Image")
    print(f"  Platform Ramdisk: {platform_path}")
    print(f"  Recovery Ramdisk: {recovery_path}")
    print(f"  DTB Table:        {dtb_path}")
    print(f"  Output Image:     {output_path}")
    print("==========================================================")

    with open(platform_path, "rb") as f:
        plat_data = f.read()

    with open(recovery_path, "rb") as f:
        rec_data = f.read()

    with open(dtb_path, "rb") as f:
        dtb_data = f.read()

    page_size = 4096
    kernel_addr = 0x40080000
    ramdisk_addr = 0x47c80000
    dtb_addr = 0x41f78000
    tags_addr = 0x4bc80000

    combined_ramdisk = plat_data + rec_data
    vendor_ramdisk_size = len(combined_ramdisk)

    # Entry 0: PLATFORM (type 1)
    entry0 = bytearray(108)
    struct.pack_into("<III", entry0, 0, len(plat_data), 0, 1)
    entry0[12:44] = b"\x00" * 32

    # Entry 1: RECOVERY (type 2)
    entry1 = bytearray(108)
    struct.pack_into("<III", entry1, 0, len(rec_data), len(plat_data), 2)
    entry1[12:44] = b"recovery" + b"\x00" * 24

    table_data = bytes(entry0) + bytes(entry1)
    table_size = len(table_data)
    table_entry_num = 2
    table_entry_size = 108
    bootconfig_size = 0

    header_size = struct.calcsize(FMT)

    cmdline_bytes = cmdline.encode("utf-8")
    if len(cmdline_bytes) < 2048:
        cmdline_bytes = cmdline_bytes + b"\x00" * (2048 - len(cmdline_bytes))

    name_bytes = b"\x00" * 16

    hdr = struct.pack(
        FMT,
        b"VNDRBOOT",
        4,
        page_size,
        kernel_addr,
        ramdisk_addr,
        vendor_ramdisk_size,
        cmdline_bytes,
        tags_addr,
        name_bytes,
        header_size,
        len(dtb_data),
        dtb_addr,
        table_size,
        table_entry_num,
        table_entry_size,
        bootconfig_size
    )

    with open(output_path, "wb") as out:
        # 1. Header padded to page_size
        out.write(hdr)
        pad_hdr = page_align(len(hdr), page_size) - len(hdr)
        out.write(b"\x00" * pad_hdr)

        # 2. Combined Ramdisk padded to page_size
        out.write(combined_ramdisk)
        pad_ramdisk = page_align(len(combined_ramdisk), page_size) - len(combined_ramdisk)
        out.write(b"\x00" * pad_ramdisk)

        # 3. DTB padded to page_size
        out.write(dtb_data)
        pad_dtb = page_align(len(dtb_data), page_size) - len(dtb_data)
        out.write(b"\x00" * pad_dtb)

        # 4. Table padded to page_size
        out.write(table_data)
        pad_table = page_align(len(table_data), page_size) - len(table_data)
        out.write(b"\x00" * pad_table)

    total_size = os.path.getsize(output_path)
    print(f"Successfully assembled vendor_boot.img: {total_size:,} bytes ({total_size / (1024*1024):.2f} MB)")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Repack Android Boot Header v4 vendor_boot")
    parser.add_argument("--output", required=True, help="Output vendor_boot.img path")
    parser.add_argument("--platform", required=True, help="Platform vendor ramdisk path")
    parser.add_argument("--recovery", required=True, help="Recovery ramdisk path")
    parser.add_argument("--dtb", required=True, help="DTB table path")
    parser.add_argument("--cmdline", default="bootopt=64S3,32N2,64N2", help="Kernel cmdline")
    args = parser.parse_args()

    repack(args.output, args.platform, args.recovery, args.dtb, args.cmdline)
