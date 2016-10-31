import matplotlib.pyplot as plt
import numpy as np

import csv

data_csv = "pixelarASM.csv"

tsASM = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    pix = float(row['pixelar'])
    
    tsASM[66].append(pix)

data2_csv = "pixelarC.csv"

tsC = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    pixC = float(row['pixelar'])
    
    tsC[36].append(pixC)



data4_csv = "pixelarO3.csv"

tsO3 = [ [] for i in range(128)]

with open(data4_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    pixO3 = float(row['pixelar'])
    
    tsO3[57].append(pixO3)

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
stdd.append(np.std(cA))
#stdd.append(np.std(o2A))
#stdd.append(np.std(o3A))

y = []
y.append(asm)
y.append(c)
#y.append(o2)
#y.append(o3)

ind = np.arange(2) 
width = .5     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width, yerr = stdd)

ax.set_ylabel('Ciclos')
ax.set_title('       Pixelar ASM y Pixelar C')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM', 'C'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))


print(c)
plt.text(1.25, 20000000, r'%100')

plt.text(0.25, 610000, r'%3')


rects1[0].set_color('r')
rects1[1].set_color('y')



plt.grid(False)

#plt.ylim(30000,26000000)


plt.show()
