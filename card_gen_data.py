import random

f = open('card.csv', 'w')



datamax=10000
keta=5

datamax=1000000
keta=7

for x in range(datamax):
	xx = str(x).rjust(keta, '0')
	#print(xx)
	f.write(xx.rjust(16, '0'))
	f.write(',')
	f.write(xx)
	f.write(',')
	f.write(str(int(random.randint(1, 10000)/10000)))
	f.write('\n')




