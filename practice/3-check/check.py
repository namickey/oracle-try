
f = open('../4-import/check-result.txt', 'w')
for line in open('../2-export/check-req.txt', ):
    if line.startswith('1'):
        continue
    print(line[14:])
    if int(line[14:]) < 1000:
        print('aa')

