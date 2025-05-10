
f = open('../4-import/check-result.txt', 'w')
for line in open('../2-export/check-req.txt', ):
    if not line.startswith('2'):
        continue
    print(line[1:4])
    print(line[14:].strip())
    if int(line[14:].strip()) < 1000:
        f.write(line[1:4] + 'OK' + '\n')
    else:
        f.write(line[1:4] + 'NG' + '\n')
