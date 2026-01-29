#!/bin/bash

#
#改行無しファイルの各レコードのレコード先頭4バイトを使って、レコード毎に改行を付与する処理
#

INPUT_FILE="output.txt"
OUTPUT_FILE="output_with_newlines.txt"
NEWLINE=$'\n'      # CRLFが必要なら $'\r\n'
ENDIAN="be"        # be (big endian) / le (little endian)

# 必要コマンドチェック
command -v od >/dev/null || { echo "odが見つかりません" >&2; exit 1; }
command -v dd >/dev/null || { echo "ddが見つかりません" >&2; exit 1; }

# 出力クリア
: > "$OUTPUT_FILE"

file_size=$(wc -c < "$INPUT_FILE")
offset=0

# 1レコードずつ長さを読み取り、レコードを切り出して改行付与
while [ "$offset" -lt "$file_size" ]; do
    # 4バイト長を直接10進で取得
    if [ "$ENDIAN" = "be" ]; then
        record_length=$(od -An -tu4 --endian=big -N4 -j"$offset" "$INPUT_FILE" | tr -d '[:space:]')
    else
        record_length=$(od -An -tu4 --endian=little -N4 -j"$offset" "$INPUT_FILE" | tr -d '[:space:]')
    fi

    [ -z "$record_length" ] && { echo "長さ取得失敗 offset=$offset" >&2; break; }

    # 異常値チェック（長さフィールドを含む想定）
    if [ "$record_length" -le 4 ] || [ $((offset + record_length)) -gt "$file_size" ]; then
        echo "異常なレコード長: $record_length (offset=$offset)" >&2
        break
    fi

    # レコード本体を抽出して出力（長さフィールド込み）
    dd if="$INPUT_FILE" bs=1 skip="$offset" count="$record_length" status=none >> "$OUTPUT_FILE"
    printf '%b' "$NEWLINE" >> "$OUTPUT_FILE"

    offset=$((offset + record_length))
done

echo "変換完了: $OUTPUT_FILE"