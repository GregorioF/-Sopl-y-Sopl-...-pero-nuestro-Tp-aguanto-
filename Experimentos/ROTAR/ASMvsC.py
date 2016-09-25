import csv

data_csv = "rotar.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    rot = int(row['rotar'])
    
    ts[100].append(rot)


data2_csv = "rotarC.csv"

ts2 = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    rot1 = int(row['rotar'])
    
    ts2[30].append(rot1)


data3_csv = "rotarO2.csv"

ts3 = [ [] for i in range(128)]

with open(data3_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    O2 = int(row['rotar'])
    
    ts3[33].append(O2)


data4_csv = "rotarO3.csv"

ts4 = [ [] for i in range(128)]

with open(data4_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    O3 = int(row['rotar'])
    
    ts4[44].append(O3)

data5_csv = "rotarO4.csv"

ts5 = [ [] for i in range(128)]

with open(data5_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    O4 = int(row['rotar'])
    
    ts5[54].append(O4)


import matplotlib.pyplot as plt
import numpy as np


rotar = 10000000000000000
for i in range(128):
	for t in ts[i]:
		rotar = min(rotar, t)

rotar2 = 1000000000000000
for i in range(128):
	for t in ts2[i]:
		rotar2 = min(rotar2, t)

o2 = 100000000000000000
for i in range(128):
  for t in ts3[i]:
    o2 = min(o2,t)

o3 = 100000000000000000
for i in range(128):
  for t in ts4[i]:
    o3 = min(o3,t)  

o4 = 100000000000000000
for i in range(128):
  for t in ts5[i]:
    o4 = min(o4,t)  


y = []
y.append(rotar)

y.append(rotar2)
y.append(o2)
y.append(o3)
y.append(o4)


ind = np.arange(5) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('Comparacion de cantidad de ciclos entre ASM y distintas optimizaciones de C')
#plt.suptitle('de Rotar ASM y Rotar C', y=1.05, fontsize=17)
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM','C','O2','O3','O4'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('g')
rects1[1].set_color('b')
rects1[2].set_color('r')
rects1[3].set_color('y')
rects1[4].set_color('m')
plt.ylim(0, 12000000)

plt.show()

