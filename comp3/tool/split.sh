#!/bin/bash

#
#改行無しファイルの各レコードのレコード先頭4バイトを使って、レコード毎に改行を付与する処理
#

INPUT_FILE="output.txt"
OUTPUT_FILE="output_with_newlines.txt"
NEWLINE=$'\n'   # WindowsでCRLFが必要なら $'\r\n' に変更

# 出力ファイルを初期化
> "$OUTPUT_FILE"

file_size=$(stat -c%s "$INPUT_FILE")
offset=0

# 1レコードずつ長さを読み取り、レコードを切り出して改行付与
while [ "$offset" -lt "$file_size" ]; do
    # 先頭4バイトを16進文字列へ
    len_hex=$(dd if="$INPUT_FILE" bs=1 skip=$offset count=4 status=none | hexdump -v -e '1/1 "%02x"')
    [ -z "$len_hex" ] && break

    # 16進を10進に変換（長さフィールドを含む想定）
    record_length=$((16#$len_hex))

    # 異常値チェック
    if [ "$record_length" -le 4 ]; then
        echo "異常なレコード長: $record_length (offset=$offset)" >&2
        break
    fi

    # レコード本体を抽出して出力
    dd if="$INPUT_FILE" bs=1 skip=$offset count=$record_length status=none >> "$OUTPUT_FILE"
    printf '%b' "$NEWLINE" >> "$OUTPUT_FILE"

    # 次のレコードへ
    offset=$((offset + record_length))
done

echo "変換完了: $OUTPUT_FILE"