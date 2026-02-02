from pathlib import Path

# Convert hex text lines in a_16.txt to binary records in a.txt
base_dir = Path(__file__).resolve().parent
src = base_dir / "a_16.txt"
dst = base_dir / "a.txt"

with src.open("r", encoding="utf-8") as s, dst.open("wb") as d:
    for line in s:
        hex_str = line.strip()
        if not hex_str:
            continue
        data = bytes.fromhex(hex_str)
        d.write(data + b"\n")  # write record bytes followed by LF
