import random

f = open('kokyaku.csv', 'w')

addrList=('東京', '神奈川', '千葉', '埼玉', '栃木', '茨城', '群馬', '長野', '新潟')

datamax=10000
keta=5

datamax=100000
keta=6

datamax=1000000
keta=7

for x in range(datamax):
	xx = str(x).rjust(keta, '0')
	#print(xx)
	f.write(xx)
	f.write(',')
	f.write(xx+'さん')
	f.write(',')
	f.write(addrList[random.randint(0, 8)]+str(random.randint(1, 9))+'-'+str(random.randint(1, 1000)))
	f.write('\n')




