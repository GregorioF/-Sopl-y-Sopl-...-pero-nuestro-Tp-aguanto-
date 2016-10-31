import csv

data_csv = "rotar.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    rot = int(row['rotar'])
    
    ts[45].append(rot)

data2_csv = "rotarSinSIMD.csv"

ts2 = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    sim = int(row['rotar'])
    
    ts2[30].append(sim)

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

import matplotlib.pyplot as plt
import numpy as np


ind = 0
rotar = 0
for i in range(128):
  for t in ts[i]:
    rotar = rotar + t
    ind = ind + 1

rotar = rotar/ind

ind = 0
simd = 0
for i in range(128):
  for t in ts2[i]:
    simd = simd + t
    ind = ind + 1
    
simd = simd/ind

ind = 0
o2 = 0
for i in range(128):
  for t in ts3[i]:
	ind = ind +1
	o2 = o2 + t
o2 = o2/ind


    
ind = 0
o3 = 0
for i in range(128):
  for t in ts4[i]:
    o3 = o3 + t 
    ind = ind + 1
o3 = o3/ind

y = []
y.append(rotar)
y.append(simd)
y.append(o2)
y.append(o3)

ind = np.arange(4) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('Diferencias de Rotar ASM con y sin SIMD')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('Con SIMD', 'Sin SIMD', 'O2', 'O3:CONTROL'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('m')
rects1[1].set_color('g')
rects1[2].set_color('y')
rects1[3].set_color('r')
#plt.ylim(0,4550000)
plt.text(3.25, 4700000, r'%100')
plt.text(1.25, 4450000, r'%94')
plt.text(2.25, 5150000, r'%109')
plt.text(0.25, 385000, r'%8')
#plt.grid(True)
plt.show()

