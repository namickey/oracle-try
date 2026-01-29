#!/usr/bin/env python3
"""Split variable-length records and add newlines (ASCII-length first, else BE binary)."""

import sys
from pathlib import Path


INPUT = Path("output.txt")
OUTPUT = Path("output_with_newlines.txt")
NEWLINE = b"\n"  # change to b"\r\n" for CRLF


def read_length(b: bytes) -> int:
	if len(b) < 4:
		raise ValueError("length field too short")
	if all(ord("0") <= x <= ord("9") for x in b[:4]):
		return int(b[:4].decode("ascii"))
	return int.from_bytes(b[:4], "big")


def split_file() -> None:
	size = INPUT.stat().st_size
	offset = 0
	with INPUT.open("rb") as f_in, OUTPUT.open("wb") as f_out:
		while offset < size:
			head = f_in.read(4)
			if not head:
				break
			if len(head) < 4:
				print(f"警告: 不完全な長さフィールド offset={offset}", file=sys.stderr)
				break

			rec_len = read_length(head)
			if rec_len <= 4 or offset + rec_len > size:
				print(f"異常なレコード長: {rec_len} (offset={offset})", file=sys.stderr)
				break

			body_len = rec_len - 4
			body = f_in.read(body_len)
			if len(body) < body_len:
				print(f"警告: 不完全なレコード offset={offset}", file=sys.stderr)
				break

			f_out.write(head)
			f_out.write(body)
			f_out.write(NEWLINE)

			offset += rec_len


if __name__ == "__main__":
	try:
		split_file()
	except FileNotFoundError as e:
		print(f"エラー: {e}", file=sys.stderr)
		sys.exit(1)
