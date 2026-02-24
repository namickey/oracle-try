#!/usr/bin/env python2
# -*- coding: utf-8 -*-

INPUT_FILE = 'input_hex.txt'
OUTPUT_FILE = 'output_bin.dat'


def split_body_and_newline(line):
	if line.endswith('\r\n'):
		return line[:-2], '\r\n'
	if line.endswith('\n'):
		return line[:-1], '\n'
	if line.endswith('\r'):
		return line[:-1], '\r'
	return line, ''


def normalize_hex_text(hex_text):
	return ''.join(hex_text.split())


def convert_hex_file_to_binary(input_path, output_path):
	with open(input_path, 'rb') as src:
		lines = src.read().splitlines(True)

	with open(output_path, 'wb') as dst:
		for index, line in enumerate(lines, 1):
			body, newline = split_body_and_newline(line)
			hex_text = normalize_hex_text(body)

			if hex_text:
				if len(hex_text) % 2 != 0:
					raise ValueError('Line %d has odd-length hex data.' % index)
				try:
					binary_data = hex_text.decode('hex')
				except TypeError:
					raise ValueError('Line %d contains non-hex characters.' % index)
				dst.write(binary_data)

			if newline:
				dst.write(newline)


if __name__ == '__main__':
	convert_hex_file_to_binary(INPUT_FILE, OUTPUT_FILE)
