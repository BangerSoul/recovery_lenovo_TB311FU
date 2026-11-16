#!/usr/bin/env python3
"""
kernel_recovery/test_kernel_recovery.py - Comprehensive Unit & Integration Tests
Milestone 3: Custom Kernel, Recovery Vector & Alternative OS Porting
Lenovo Tab M11 (TB311FU / poplar, MT8786 / MT6768)

Tests:
1. AVB 2.0 chained boot verification (valid and corrupted images).
2. vendor_boot salted SHA-256 hash descriptor pinning.
3. Dual-boot slot manager status, transitions, and zero-data-loss enforcement.
4. BCB message structure serialization, parsing, and zeroing.
5. End-to-end dry-run lifecycle and idempotency.
"""

import hashlib
import os
import struct
import sys
import unittest

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(CURRENT_DIR, ".."))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)
if CURRENT_DIR not in sys.path:
    sys.path.insert(0, CURRENT_DIR)

from kernel_recovery.verify_avb_chain import (
    verify_avb_chain,
    verify_vendor_boot_hash,
    verify_file,
    AVBVerificationError,
    EXPECTED_BOOT_SIZE,
    EXPECTED_OEM_KEY_SHA1,
    EXPECTED_AUTH_DIGEST,
    VENDOR_BOOT_PINNED_SIZE,
    VENDOR_BOOT_PINNED_HASH,
    AVB_SALT_HEX,
    AVB_SALT_BYTES,
)

from kernel_recovery.dual_boot_manager import (
    DualBootManager,
    DeviceTransport,
    create_bcb_message,
    parse_bcb_message,
    create_empty_bcb,
    verify_vbmeta_flag_byte,
    FORBIDDEN_DATA_COMMANDS,
)


class TestAVBChainVerification(unittest.TestCase):
    """Unit tests for verify_avb_chain.py cryptographic operations."""

    @classmethod
    def setUpClass(cls):
        cls.clean_boot_path = r"C:\platform-tools\poplar_boot_v12_clean.img"
        cls.rec_boot_path = r"C:\platform-tools\recovery_boot.img"
        cls.vendor_boot_path = r"C:\platform-tools\stock_vendor_boot.img"
        cls.stock_boot_path = r"C:\platform-tools\stock_boot.img"

        with open(cls.clean_boot_path, "rb") as f:
            cls.clean_boot_data = f.read()

        with open(cls.rec_boot_path, "rb") as f:
            cls.rec_boot_data = f.read()

        with open(cls.vendor_boot_path, "rb") as f:
            cls.vendor_boot_data = f.read()

    def test_01_poplar_kernel_clean_passes(self):
        """PoplarKernel v1.2 satisfies all AVB 2.0 chained invariants."""
        meta = verify_avb_chain(self.clean_boot_data, image_path="poplar_boot_v12_clean.img", verbose=False)
        self.assertEqual(meta["image_size"], 33554432)
        self.assertEqual(meta["vbmeta_offset"], 0xc52000)
        self.assertEqual(meta["vbmeta_offset"] % 4096, 0)
        self.assertEqual(meta["flags_byte_123"], 0x00)
        self.assertEqual(meta["public_key_sha1"].lower(), EXPECTED_OEM_KEY_SHA1.lower())
        self.assertEqual(meta["auth_digest"].lower(), EXPECTED_AUTH_DIGEST.lower())
        self.assertEqual(meta["header_version"], 4)
        self.assertEqual(meta["ramdisk_size"], 0)

    def test_02_recovery_boot_passes_with_ramdisk(self):
        """recovery_boot.img satisfies all AVB 2.0 invariants and contains TWRP ramdisk."""
        meta = verify_avb_chain(self.rec_boot_data, image_path="recovery_boot.img", require_ramdisk=True, verbose=False)
        self.assertEqual(meta["image_size"], 33554432)
        self.assertEqual(meta["vbmeta_offset"], 0xe28000)
        self.assertEqual(meta["vbmeta_offset"] % 4096, 0)
        self.assertEqual(meta["flags_byte_123"], 0x00)
        self.assertEqual(meta["public_key_sha1"].lower(), EXPECTED_OEM_KEY_SHA1.lower())
        self.assertEqual(meta["auth_digest"].lower(), EXPECTED_AUTH_DIGEST.lower())
        self.assertGreater(meta["ramdisk_size"], 1000000)

    def test_03_invalid_size_rejected(self):
        """Images not exactly 33,554,432 bytes must raise AVBVerificationError."""
        bad_data = self.clean_boot_data[:1000]
        with self.assertRaises(AVBVerificationError) as ctx:
            verify_avb_chain(bad_data, verbose=False)
        self.assertIn("size violation", str(ctx.exception).lower())

    def test_04_invalid_magic_rejected(self):
        """Images missing 'ANDROID!' magic must raise AVBVerificationError."""
        bad_data = bytearray(self.clean_boot_data)
        bad_data[0:8] = b"CORRUPT!"
        with self.assertRaises(AVBVerificationError) as ctx:
            verify_avb_chain(bytes(bad_data), verbose=False)
        self.assertIn("magic violation", str(ctx.exception).lower())

    def test_05_modified_flags_byte_rejected(self):
        """Mutated byte 123 (flags=0x03 as in --disable-verity) must raise AVBVerificationError."""
        bad_data = bytearray(self.clean_boot_data)
        vb_off = 0xc52000
        bad_data[vb_off + 123] = 0x03
        with self.assertRaises(AVBVerificationError) as ctx:
            verify_avb_chain(bytes(bad_data), verbose=False)
        self.assertIn("flags violation", str(ctx.exception).lower())

    def test_06_unaligned_vbmeta_rejected(self):
        """Un-aligned VBMeta offset in AVB footer must raise AVBVerificationError."""
        bad_data = bytearray(self.clean_boot_data)
        footer_pos = EXPECTED_BOOT_SIZE - 64
        # Offset in footer: magic(4) + vmaj(4) + vmin(4) + orig_sz(8) = 20
        # vbmeta_offset is at offset 20:28
        # Change offset to 0xc52001 (not 4096-aligned)
        bad_data[footer_pos + 20 : footer_pos + 28] = struct.pack(">Q", 0xc52001)
        with self.assertRaises(AVBVerificationError) as ctx:
            verify_avb_chain(bytes(bad_data), verbose=False)
        self.assertIn("page alignment violation", str(ctx.exception).lower())

    def test_07_corrupted_auth_digest_rejected(self):
        """Altered authentication block hash must raise AVBVerificationError."""
        bad_data = bytearray(self.clean_boot_data)
        vb_off = 0xc52000
        # In auth block, flip a byte
        bad_data[vb_off + 256 + 10] ^= 0xff
        with self.assertRaises(AVBVerificationError) as ctx:
            verify_avb_chain(bytes(bad_data), verbose=False)
        self.assertIn("digest mismatch", str(ctx.exception).lower())

    def test_08_vendor_boot_salt_hash_matches(self):
        """stock_vendor_boot.img matches Little Kernel unchained hash descriptor."""
        valid, comp_h, exp_h = verify_vendor_boot_hash(self.vendor_boot_data, verbose=False)
        self.assertTrue(valid)
        self.assertEqual(comp_h.lower(), VENDOR_BOOT_PINNED_HASH.lower())

    def test_09_corrupted_vendor_boot_fails(self):
        """Modified vendor_boot must fail hash descriptor check."""
        corrupted = bytearray(self.vendor_boot_data[:VENDOR_BOOT_PINNED_SIZE])
        corrupted[1000] ^= 0x5a
        valid, comp_h, exp_h = verify_vendor_boot_hash(bytes(corrupted), verbose=False)
        self.assertFalse(valid)
        self.assertNotEqual(comp_h.lower(), exp_h.lower())

    def test_10_verify_file_dispatcher(self):
        """verify_file correctly identifies boot and vendor_boot files."""
        self.assertTrue(verify_file(self.clean_boot_path, verbose=False))
        self.assertTrue(verify_file(self.rec_boot_path, verbose=False))
        self.assertTrue(verify_file(self.vendor_boot_path, verbose=False))
        self.assertTrue(verify_file(self.stock_boot_path, verbose=False))
        self.assertFalse(verify_file(r"C:\non_existent_file.img", verbose=False))


class TestDualBootManager(unittest.TestCase):
    """Unit and mock integration tests for dual_boot_manager.py."""

    def setUp(self):
        self.mgr = DualBootManager(mock=True, dry_run=True)

    def test_11_bcb_message_pack_and_parse(self):
        """create_bcb_message and parse_bcb_message roundtrip correctly."""
        msg = create_bcb_message(command="boot-recovery", recovery_args="recovery\n--show_text\n")
        self.assertEqual(len(msg), 2048)
        parsed = parse_bcb_message(msg)
        self.assertEqual(parsed["command"], "boot-recovery")
        self.assertEqual(parsed["recovery"], "recovery\n--show_text\n")

    def test_12_empty_bcb_all_zeros(self):
        """create_empty_bcb creates exactly 2048 zero bytes."""
        empty = create_empty_bcb()
        self.assertEqual(len(empty), 2048)
        self.assertTrue(all(b == 0 for b in empty))

    def test_13_vbmeta_flag_byte_inspector(self):
        """verify_vbmeta_flag_byte allows flags=0 and rejects flags=3."""
        valid_bytes = b"\x00" * 123 + b"\x00" + b"\x00" * 10
        invalid_bytes = b"\x00" * 123 + b"\x03" + b"\x00" * 10
        ok1, b1 = verify_vbmeta_flag_byte(valid_bytes)
        ok2, b2 = verify_vbmeta_flag_byte(invalid_bytes)
        self.assertTrue(ok1)
        self.assertEqual(b1, 0)
        self.assertFalse(ok2)
        self.assertEqual(b2, 3)

    def test_14_mock_status_query(self):
        """Status report in mock/simulated mode reflects valid state."""
        st = self.mgr.get_status()
        self.assertEqual(st["serial"], "HNQ09EZD")
        self.assertIn(st["active_slot"], ["a", "b"])
        self.assertTrue(st["slot_a_valid"])
        self.assertTrue(st["slot_b_valid"])
        self.assertTrue(st["zero_data_loss_safe"])

    def test_15_mock_verify_slot_a(self):
        """verify_slot_a passes against PoplarKernel v1.2 baseline."""
        passed, res = self.mgr.verify_slot_a(verbose=False)
        self.assertTrue(passed)
        self.assertEqual(res["checks"]["boot_a"], "PASS")
        self.assertEqual(res["checks"]["vendor_boot_a"], "PASS")
        self.assertEqual(res["checks"]["vbmeta_a"], "PASS")

    def test_16_mock_verify_slot_b(self):
        """verify_slot_b passes against TWRP recovery baseline."""
        passed, res = self.mgr.verify_slot_b(verbose=False)
        self.assertTrue(passed)
        self.assertEqual(res["checks"]["boot_b"], "PASS")
        self.assertEqual(res["checks"]["vendor_boot_b"], "PASS")
        self.assertEqual(res["checks"]["vbmeta_b"], "PASS")

    def test_17_mock_set_recovery_boot(self):
        """set_recovery_boot stages recovery in dry-run mode."""
        ok, msg = self.mgr.set_recovery_boot(dry_run=True)
        self.assertTrue(ok)
        self.assertIn("staged successfully", msg)

    def test_18_mock_set_os_boot(self):
        """set_os_boot stages OS baseline in dry-run mode."""
        ok, msg = self.mgr.set_os_boot(dry_run=True)
        self.assertTrue(ok)
        self.assertIn("staged successfully", msg)

    def test_19_zero_data_loss_enforcement(self):
        """Attempting to run a forbidden userdata wipe command raises RuntimeError."""
        transport = DeviceTransport(mock=True)
        # Test standard forbidden commands
        for forbidden in FORBIDDEN_DATA_COMMANDS:
            with self.assertRaises(RuntimeError) as ctx:
                transport._audit_command_safety(f"fastboot {forbidden}")
            self.assertIn("CRITICAL SAFETY VIOLATION", str(ctx.exception))

        # Test adversarial bypass attempts (e.g. format:f2fs, format:ext4, -w, rm -rf, blkdiscard, dd)
        adversarial_destructive = [
            "fastboot format:f2fs userdata",
            "fastboot format:ext4 userdata",
            "fastboot format:f2fs:0x1000 userdata",
            "fastboot -w",
            "fastboot erase userdata",
            "fastboot flash userdata raw.img",
            "rm -rf /data",
            "rm -r /data/user/0",
            "mkfs.ext4 /dev/block/by-name/userdata",
            "blkdiscard /dev/block/by-name/userdata",
            "dd if=/dev/zero of=/dev/block/by-name/userdata",
        ]
        for cmd in adversarial_destructive:
            with self.assertRaises(RuntimeError) as ctx:
                transport._audit_command_safety(cmd)
            self.assertIn("CRITICAL SAFETY VIOLATION", str(ctx.exception))

        # Verify legitimate safe commands pass audit
        safe_commands = [
            "fastboot flash boot_a boot.img",
            "fastboot flash vendor_a vendor_stabilized.img",
            "fastboot getvar is-userspace",
            "fastboot reboot",
            "fastboot --set-active=b",
            "cat /proc/partitions",
            "ls -la /sys/class/leds",
        ]
        for cmd in safe_commands:
            # Should not raise exception
            transport._audit_command_safety(cmd)

    def test_20_comprehensive_dry_run_lifecycle(self):
        """Comprehensive dry-run lifecycle test executes 8 gates with 100% success."""
        ok = self.mgr.test_dry_run()
        self.assertTrue(ok)


if __name__ == "__main__":
    unittest.main()
