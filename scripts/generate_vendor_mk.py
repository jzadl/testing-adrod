#!/usr/bin/env python3
"""Generate selene-vendor-files.mk from proprietary-files.txt.

Reads the curated blob list and generates a clean PRODUCT_COPY_FILES makefile
that is compatible with Android 11's build system (no VINTF, no APKs).
"""
import sys
import os

SKIP_PATTERNS = [
    "/vintf/",          # VINTF manifests must not be in PRODUCT_COPY_FILES
    "vintf/manifest",   # Also catch these
    ".apk",             # APKs need BUILD_PREBUILT, not PRODUCT_COPY_FILES
    ".jar",             # JARs need BUILD_PREBUILT too
]

def parse_line(line):
    """Parse a proprietary-files.txt line into (src_path, dst_path) or None."""
    line = line.strip()
    if not line or line.startswith("#"):
        return None
    
    # Lines starting with - are system partition files (skip for vendor mk)
    if line.startswith("-"):
        return None
    
    # Remove hash suffix (e.g., path|hash)
    if "|" in line:
        line = line.split("|")[0]
    
    # Handle rename syntax (src:dest)
    if ":" in line and not line.startswith("/"):
        # Could be a path with : that's not a rename, check carefully
        parts = line.split(":")
        if len(parts) == 2 and "/" in parts[0] and "/" in parts[1]:
            return (parts[0], parts[1])
    
    # Standard vendor/ file
    return (line, line)

def should_skip(path):
    """Check if a path should be skipped."""
    for pattern in SKIP_PATTERNS:
        if pattern in path:
            return True
    return False

def main():
    if len(sys.argv) < 3:
        print("Usage: generate_vendor_mk.py <proprietary-files.txt> <output.mk>")
        sys.exit(1)
    
    txt_path = sys.argv[1]
    mk_path = sys.argv[2]
    
    entries = []
    skipped = {"vintf": 0, "apk": 0, "system": 0, "comment": 0}
    
    with open(txt_path) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            if line.startswith("#"):
                skipped["comment"] += 1
                continue
            if line.startswith("-"):
                skipped["system"] += 1
                continue
            
            result = parse_line(line)
            if result is None:
                continue
            
            src, dst = result
            if should_skip(src):
                if "vintf" in src.lower():
                    skipped["vintf"] += 1
                elif ".apk" in src.lower():
                    skipped["apk"] += 1
                continue
            
            # Map vendor/ source to vendor/xiaomi/selene/proprietary/
            # The blobs are at vendor/xiaomi/selene/proprietary/<path>
            # Destination strips "vendor/" prefix since TARGET_COPY_OUT_VENDOR = vendor
            src_full = f"vendor/xiaomi/selene/proprietary/{src}"
            dst_stripped = dst
            if dst_stripped.startswith("vendor/"):
                dst_stripped = dst_stripped[len("vendor/"):]
            entries.append((src_full, f"$(TARGET_COPY_OUT_VENDOR)/{dst_stripped}"))
    
    # Generate makefile
    with open(mk_path, "w") as f:
        f.write("# Auto-generated from proprietary-files.txt\n")
        f.write("# DO NOT EDIT MANUALLY - run scripts/generate_vendor_mk.py instead\n\n")
        f.write("PRODUCT_COPY_FILES += \\\n")
        
        for i, (src, dst) in enumerate(entries):
            separator = " \\" if i < len(entries) - 1 else ""
            f.write(f"    {src}:{dst}{separator}\n")
    
    print(f"Generated {mk_path}")
    print(f"  Total entries: {len(entries)}")
    print(f"  Skipped: {skipped['vintf']} VINTF, {skipped['apk']} APKs, {skipped['system']} system files, {skipped['comment']} comments")

if __name__ == "__main__":
    main()
