def comp4_to_int(b: bytes) -> int:
    """
    4バイト COMP（Big Endian、符号付き2進数）を整数に変換する。
    b は bytes型で長さ4であること。
    """
    if len(b) != 4:
        raise ValueError("COMP4 must be 4 bytes")

    # Big Endian, signed
    return int.from_bytes(b, byteorder="big", signed=True)

def comp3_to_int(b: bytes) -> int:
    """
    COMP-3 を整数に変換（符号付き）
    """
    hex_str = b.hex().upper()
    # 最後のニブルが符号
    sign_nibble = hex_str[-1]
    num_str = hex_str[:-1]

    sign = 1
    if sign_nibble in ("D", "B"):
        sign = -1

    return sign * int(num_str)


def iter_records(file_path: str):
    with open(file_path, "rb") as f:
        while True:
            header = f.read(4)
            if not header:
                break

            rec_len = comp4_to_int(header)

            if rec_len <= 0:
                raise ValueError(f"Invalid record length: {rec_len}")

            body = f.read(rec_len - 4)  # 先頭4バイトは長さ情報
            if len(body) != rec_len - 4:
                raise EOFError("Unexpected EOF")

            yield body


# 例：正数
print(comp4_to_int(bytes.fromhex("000004D2")))  # -> 1234

# 例：負数
print(comp4_to_int(bytes.fromhex("FFFFFB2E")))  # -> -1234

for x in iter_records("record.bin"):
    print(x.hex().upper())
    print(comp3_to_int(x[:3]))  # 先頭3バイトをCOMP-3として解釈
    print(x[3:].decode("utf-8"))  # 残りを文字列として解釈

with open("record.bin", "rb") as f:
    #16進文字列として出力
    print(f.read().hex().upper())
