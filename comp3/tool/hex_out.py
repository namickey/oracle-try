#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Read c.txt and write hex dump to d.txt, preserving newlines."""

import os
import sys


INPUT = "c.txt"
OUTPUT = "d.txt"


def _byte_value(ch):
	"""Return int value for a single byte in Py2/3."""
	if isinstance(ch, int):
		return ch
	return ord(ch)


def _byte_char(b):
	"""Return single-byte string for Py2/3."""
	if sys.version_info[0] >= 3:
		return bytes((b,))
	return chr(b)


def convert_to_hex_preserve_newlines():
	if not os.path.exists(INPUT):
		raise IOError("input file not found: {}".format(INPUT))

	with open(INPUT, "rb") as f_in, open(OUTPUT, "wb") as f_out:
		while True:
			chunk = f_in.read(8192)
			if not chunk:
				break
			for ch in chunk:
				b = _byte_value(ch)
				if b == 0x0A or b == 0x0D:
					f_out.write(_byte_char(b))
				else:
					f_out.write(("%02x" % b).encode("ascii"))


if __name__ == "__main__":
	convert_to_hex_preserve_newlines()
