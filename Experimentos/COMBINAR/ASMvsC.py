import matplotlib.pyplot as plt
import numpy as np

import csv

data_csv = "combinarASM.csv"

tsASM = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    comb = float(row['combinar'])
    
    tsASM[39].append(comb)

data2_csv = "combinarC.csv"

tsC = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    combC = float(row['combinar'])
    
    tsC[61].append(combC)



data4_csv = "combinarO3.csv"

tsO3 = [ [] for i in range(128)]

with open(data4_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    combO3 = float(row['combinar'])
    
    tsO3[58].append(combO3) 
 
ind = 0
asm = 0
asmA = []
for i in range(128):
	for t in tsASM[i]:
		asmA.append(t)
		ind = ind + 1
		asm = asm+t
		
asm = asm/ind
cA = []
ind = 0
c = 0
for i in range(128):
	for t in tsC[i]:
		cA.append(t)
		c = c+t
		ind = ind + 1
		
c = c/ind

o3A = []
ind = 0

o3 = 0
for i in range(128):
	for t in tsO3[i]:
		o3A.append(t)
		o3 = o3 + t
		ind = ind + 1
		
o3 = o3/ind
 
stdd = []
stdd.append(np.std(asmA))
#stdd.append(np.std(cA))
#stdd.append(np.std(o2A))
stdd.append(np.std(o3A))

y = []
y.append(asm)
#y.append(c)
#y.append(o2)
y.append(o3)

ind = np.arange(2) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width, yerr=stdd)

ax.set_ylabel('Ciclos')
ax.set_title('       Diferencias entre Combinar ASM y Combinar C')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM','O3:CONTROL'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
plt.text(0.25, 2382439, r'%4')
plt.text(1.25, 73159487, r'%100')
plt.text(0.17, 50000000, 'O0 : %141',
        bbox={'facecolor':'white', 'alpha':0.5, 'pad':10})
rects1[0].set_color('y')
rects1[1].set_color('m')

plt.grid(False)

#plt.ylim(0,35000000)


plt.show()
