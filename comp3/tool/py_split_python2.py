#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""Split variable-length records and add newlines (ASCII-length first, else BE binary)."""

from __future__ import print_function

import os
import sys


INPUT = "b.txt"
OUTPUT = "c.txt"
NEWLINE = b"\n"  # change to b"\r\n" for CRLF



def read_length(b):
	if len(b) < 2:
		raise ValueError("length field too short")
	if all(ord("0") <= ord(x) <= ord("9") for x in b[:2]):
		return int(b[:2].decode("ascii"))
	value = 0
	for ch in b[:2]:
		value = (value << 8) | ord(ch)
	return value


def split_file():
	size = os.path.getsize(INPUT)
	offset = 0
	with open(INPUT, "rb") as f_in, open(OUTPUT, "wb") as f_out:
		while offset < size:
			head = f_in.read(2)
			if not head:
				break
			if len(head) < 2:
				print(u"警告: 不完全な長さフィールド offset={}".format(offset), file=sys.stderr)
				break

			rec_len = read_length(head)
			if rec_len <= 2 or offset + rec_len > size:
				print(u"異常なレコード長: {} (offset={})".format(rec_len, offset), file=sys.stderr)
				break

			body_len = rec_len - 2
			body = f_in.read(body_len)
			if len(body) < body_len:
				print(u"警告: 不完全なレコード offset={}".format(offset), file=sys.stderr)
				break

			f_out.write(head)
			f_out.write(body)
			f_out.write(NEWLINE)

			offset += rec_len


if __name__ == "__main__":
	try:
		split_file()
	except IOError as e:
		print(u"エラー: {}".format(e), file=sys.stderr)
		sys.exit(1)
