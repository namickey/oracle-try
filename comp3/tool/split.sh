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

    INPUT_FILE="output.txt"
    OUTPUT_FILE="output_with_newlines.txt"
    NEWLINE=$'\n'      # CRLFが必要なら $'\r\n'

    command -v hexdump >/dev/null || { echo "hexdumpが見つかりません" >&2; exit 1; }
    command -v dd      >/dev/null || { echo "ddが見つかりません" >&2; exit 1; }

    : > "$OUTPUT_FILE"

    file_size=$(wc -c < "$INPUT_FILE")
    offset=0

    while [ "$offset" -lt "$file_size" ]; do
        # 先頭4バイトを読み出し（スペース区切りの16進に）
        bytes=$(dd if="$INPUT_FILE" bs=1 skip="$offset" count=4 status=none | hexdump -v -e '1/1 "%02x "') || break
        [ -z "$bytes" ] && { echo "長さ取得失敗 offset=$offset" >&2; break; }

        set -- $bytes; b1=$1; b2=$2; b3=$3; b4=$4

        # 4バイトがASCII数字(30-39)なら十進長とみなす（例 '30 34 30 30' -> 0400）
        length_ascii=""
        if printf '%s%s%s%s' "$b1" "$b2" "$b3" "$b4" | grep -Eq '^(30|31|32|33|34|35|36|37|38|39){4}$'; then
            length_ascii=$((10#$(printf "\\x$b1\\x$b2\\x$b3\\x$b4")))
        fi

        if [ -n "$length_ascii" ]; then
            record_length=$length_ascii
        else
            # フォールバック: ビッグエンディアン
            record_length=$((16#$b1$b2$b3$b4))
        fi

        # 妥当性チェック
        if [ "$record_length" -le 4 ] || [ $((offset + record_length)) -gt "$file_size" ]; then
            echo "異常なレコード長: $record_length (offset=$offset bytes=$b1$b2$b3$b4)" >&2
            break
        fi

        dd if="$INPUT_FILE" bs=1 skip="$offset" count="$record_length" status=none >> "$OUTPUT_FILE"
        printf '%b' "$NEWLINE" >> "$OUTPUT_FILE"

        offset=$((offset + record_length))
    done

    echo "変換完了: $OUTPUT_FILE"