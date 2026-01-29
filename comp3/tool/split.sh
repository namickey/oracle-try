#!/bin/bash

#
#改行無しファイルの各レコードのレコード先頭4バイトを使って、レコード毎に改行を付与する処理
#

INPUT_FILE="output.txt"
OUTPUT_FILE="output_with_newlines.txt"

# 出力ファイルを初期化
> "$OUTPUT_FILE"

# hexdumpで全体を16進数に変換し、awkでレコードごとに処理
hexdump -v -e '1/1 "%02x"' "$INPUT_FILE" | \
awk '{
    while (length($0) > 0) {
        # 先頭16進文字列として、8文字（4バイト分）を取得
        len_hex = substr($0, 1, 8)
        $0 = substr($0, 9)
        
        # 16進数を10進数に変換
        cmd = "echo $((16#" len_hex "))"
        cmd | getline record_length
        close(cmd)
        
        # レコード全体を抽出（長さフィールドを含む）
        record_hex = len_hex substr($0, 1, (record_length - 4) * 2)
        $0 = substr($0, (record_length - 4) * 2 + 1)
        
        # 16進数をバイナリに戻して出力（改行付き）
        print record_hex
    }
}' | \
while read hex_line; do
    # xxdコマンドで16進数をバイナリに変換し、改行を追加
    echo "$hex_line" | xxd -r -p >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
done

echo "変換完了: $OUTPUT_FILE"