import csv

data_csv = "rotar.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    rot = int(row['rotar'])
    
    ts[30].append(rot)

data2_csv = "rotarSinSIMD.csv"

ts2 = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    sim = int(row['rotar'])
    
    ts2[27].append(sim)



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

   


y = []
y.append(2*rotar)
y.append(simd)

ind = np.arange(2) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('Diferencias de Rotar ASM usando SIMD y no usandolo')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('Con SIMD', 'Sin SIMD'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('m')
rects1[1].set_color('g')
plt.ylim(0,3200000)

plt.show()

