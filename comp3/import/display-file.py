def printHex(data):
    print(' '.join(f'{b:02X}' for b in data))

for x in open('comp3-toolout.txt', 'rb'):
    print(x)