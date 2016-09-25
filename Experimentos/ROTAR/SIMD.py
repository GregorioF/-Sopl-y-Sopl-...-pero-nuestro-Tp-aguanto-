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



rotar = 100000000000000
for i in range(128):
  for t in ts[i]:
    rotar = min(rotar, t)




simd = 10000000000000
for i in range(128):
  for t in ts2[i]:
    simd = min(simd,t)

   
o2 = 100000000000000000
for i in range(128):
  for t in ts3[i]:
    o2 = min(o2,t)

o3 = 100000000000000000
for i in range(128):
  for t in ts4[i]:
    o3 = min(o3,t)  


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
ax.set_title('Diferencias de Rotar ASM usando SIMD y no usandolo')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('Con SIMD', 'Sin SIMD', 'O2', 'O3'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('m')
rects1[1].set_color('g')
rects1[2].set_color('y')
rects1[3].set_color('r')
plt.ylim(0,3350000)

plt.show()

