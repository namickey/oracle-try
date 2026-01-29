#!/bin/bash

#
#改行無しファイルの各レコードのレコード先頭4バイトを使って、レコード毎に改行を付与する処理
#

INPUT_FILE="output.txt"
OUTPUT_FILE="output_with_newlines.txt"
NEWLINE=$'\n'      # CRLFが必要なら $'\r\n'
DEBUG=1            # 1でヘッダ情報を表示、0で抑制

# 必要コマンドチェック
command -v hexdump >/dev/null || { echo "hexdumpが見つかりません" >&2; exit 1; }
command -v dd >/dev/null      || { echo "ddが見つかりません" >&2; exit 1; }

# 出力クリア
: > "$OUTPUT_FILE"

file_size=$(wc -c < "$INPUT_FILE")
offset=0

# 1レコードずつ長さを読み取り、レコードを切り出して改行付与
while [ "$offset" -lt "$file_size" ]; do
    # 先頭4バイトを16進で取得（スペース区切り）
    bytes=$(dd if="$INPUT_FILE" bs=1 skip="$offset" count=4 status=none | hexdump -v -e '1/1 "%02x "')
    [ -z "$bytes" ] && { echo "長さ取得失敗 offset=$offset" >&2; break; }

    set -- $bytes
    b1=$1; b2=$2; b3=$3; b4=$4

    # BE/LE候補を計算
    len_be=$((16#$b1$b2$b3$b4))
    len_le=$((16#$b4$b3$b2$b1))

    # ASCII数字の場合の候補（例: '0032'）
    if [ "$DEBUG" -eq 1 ]; then
        echo "offset=$offset bytes=$b1$b2$b3$b4 len_be=$len_be len_le=$len_le ascii=${ascii_candidate:-N/A} remaining=$remaining" >&2
    fi

    ascii_candidate=""
    if printf '%s%s%s%s' "$b1" "$b2" "$b3" "$b4" | grep -Eq '^(30|31|32|33|34|35|36|37|38|39){4}$'; then
        ascii_digits=$(printf "\\x$b1\\x$b2\\x$b3\\x$b4")
        ascii_candidate=$((10#$ascii_digits))
    fi

    remaining=$((file_size - offset))
    chosen_len=0

    # 妥当な長さを優先順位で決定
    if [ -n "$ascii_candidate" ] && [ "$ascii_candidate" -ge 4 ] && [ $((offset + ascii_candidate)) -le "$file_size" ]; then
        chosen_len=$ascii_candidate
    elif [ "$len_be" -ge 4 ] && [ $((offset + len_be)) -le "$file_size" ]; then
        chosen_len=$len_be
    elif [ "$len_le" -ge 4 ] && [ $((offset + len_le)) -le "$file_size" ]; then
        chosen_len=$len_le
    fi

    if [ "$chosen_len" -le 4 ]; then
        echo "異常なレコード長: BE=$len_be LE=$len_le ASCII=${ascii_candidate:-N/A} (offset=$offset)" >&2
        break
    fi

    # レコード本体を抽出して出力（長さフィールド込み）
    dd if="$INPUT_FILE" bs=1 skip="$offset" count="$chosen_len" status=none >> "$OUTPUT_FILE"
    printf '%b' "$NEWLINE" >> "$OUTPUT_FILE"

    offset=$((offset + chosen_len))
done

echo "変換完了: $OUTPUT_FILE"