import matplotlib.pyplot as plt
import numpy as np

import csv

data_csv = "pixelarASM.csv"

tsASM = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    pix = float(row['pixelar'])
    
    tsASM[13].append(pix)

data2_csv = "pixelarC.csv"

tsC = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    pixC = float(row['pixelar'])
    
    tsC[9].append(pixC)

data3_csv = "pixelarO2.csv"

tsO2 = [ [] for i in range(128)]

with open(data3_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    pixO2 = float(row['pixelar'])
    
    tsO2[6].append(pixO2)

data4_csv = "pixelarO3.csv"

tsO3 = [ [] for i in range(128)]

with open(data4_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    pixO3 = float(row['pixelar'])
    
    tsO3[14].append(pixO3)


asm = 10000000000000000
for i in range(128):
	for t in tsASM[i]:
		asm = min(asm, t)

c = 10000000000000000
for i in range(128):
	for t in tsC[i]:
		c = min(c, t)

o2 = 10000000000000000
for i in range(128):
	for t in tsO2[i]:
		o2 = min(o2, t)


o3 = 10000000000000000
for i in range(128):
	for t in tsO3[i]:
		o3 = min(o3, t)
 

y = []
y.append(asm)
y.append(c)
#y.append(o2)
#y.append(o3)

ind = np.arange(2) 
width = .5     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('       Pixelar ASM y Pixelar C')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM', 'C'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))

plt.text(1.25, 14199999, r'%100')

plt.text(0.25, 620000, r'%4')


rects1[0].set_color('m')
rects1[1].set_color('b')



plt.grid(False)

#plt.ylim(30000,26000000)


plt.show()
