# デコード
def decode_comp3(packed_bytes):
    # 16進数文字列に変換
    hex_str = packed_bytes.hex()
    # 最後の文字（符号）を取り除く
    numeric_part = hex_str[:-1]
    # 数値に変換
    value = int(numeric_part)
    # 符号の判定（Dは負）
    if hex_str[-1] == 'd' or hex_str[-1] == 'D':
        value = -value
    return value

# エンコード
def encode_comp3(value):
    # comp-3は最後の半バイトに符号を格納する
    sign_nibble = 'C' if value >= 0 else 'D'
    digits = str(abs(value)) or '0'

    # 符号半バイトを追加した総数が偶数になるように調整
    if len(digits) % 2 == 0:
        digits = '0' + digits

    bcd_str = digits + sign_nibble
    return bytes.fromhex(bcd_str)

def printHex(data):
    print(' '.join(f'{b:02X}' for b in data))

def output_file(filename, data):
    with open(filename, 'wb') as f:
        f.write(data)

# 例: 0012345C (12345)
data = b'\x00\x12\x34\x5C'
data = b'\x12\x34\x5C'
printHex(data)
print(decode_comp3(data)) # 出力: 12345

# エンコード例: 12345 -> 0012345C
encoded = encode_comp3(12345)
printHex(encoded)
output_file('a.txt', encoded)

encoded = encode_comp3(1234)
printHex(encoded)

encoded = encode_comp3(9876)
printHex(encoded)

encoded = encode_comp3(5432154321)
printHex(encoded)
output_file('b.txt', encoded)