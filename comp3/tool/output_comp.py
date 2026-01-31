record_len_hex1 = "0000000A" # 10バイトのレコード長（4バイトヘッダ + 6バイト本文）
record_len_hex2 = "0000000B" # 11バイトのレコード長（4バイトヘッダ + 7バイト本文）
body_hex1 = "00123C616263"  # レコード本文（6バイト）
body_hex2 = "09876C41424344"  # レコード本文（7バイト）
with open("record.bin", "wb") as f:
    f.write(bytes.fromhex(record_len_hex1))
    f.write(bytes.fromhex(body_hex1))
    f.write(bytes.fromhex(record_len_hex2))
    f.write(bytes.fromhex(body_hex2))
    f.write(bytes.fromhex(record_len_hex1))
    f.write(bytes.fromhex(body_hex1))
    f.write(bytes.fromhex(record_len_hex2))
    f.write(bytes.fromhex(body_hex2))
