# エンコード
def encode_comp3(value: str) -> bytes:
    if not isinstance(value, str):
        raise TypeError('value must be a string of digits')

    stripped = value.strip()

    # comp-3は最後の半バイトに符号を格納する
    if stripped.startswith('-'):
        sign_nibble = 'D'
        digits = stripped[1:]
    else:
        sign_nibble = 'C'
        digits = stripped.lstrip('+')

    if not digits:
        digits = '0'

    if not digits.isdigit():
        raise ValueError('value must contain only digits')

    # 符号半バイトを追加した総数が偶数になるように調整
    if len(digits) % 2 == 0:
        digits = '0' + digits

    bcd_str = digits + sign_nibble
    return bytes.fromhex(bcd_str)

# エンコード例: 12345 -> 0012345C

def printHex(data):
    print('0x ', end='')
    print(' '.join(f'{b:02X}' for b in data))

with open('comp3-toolout.txt', 'wb') as f:
    printHex(encode_comp3('00100'))
    printHex(encode_comp3('00200'))
    f.write('2pen       '.encode())
    f.write(encode_comp3('00100'))
    f.write('\n'.encode())
    f.write('2notebook  '.encode())
    f.write(encode_comp3('00200'))
    f.write('\n'.encode())
    f.write('2desk      '.encode())
    f.write(encode_comp3('16000'))
    f.write('\n'.encode())
    f.write('2paperclips'.encode())
    f.write(encode_comp3('00300'))
    f.write('\n'.encode())