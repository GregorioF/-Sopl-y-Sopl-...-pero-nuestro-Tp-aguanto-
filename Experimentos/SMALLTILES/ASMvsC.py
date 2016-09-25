import csv

data_csv = "smalltilesASM.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smalA = int(row['small'])
    
    ts[30].append(smalA)

data2_csv = "smalltilesO2.csv"

ts2 = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal2 = int(row['small'])
    
    ts2[40].append(smal2)

data3_csv = "smalltilesO3.csv"
ts3 = [ [] for i in range(128)]
    
with open(data3_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal3 = int(row['small'])
    ts3[20].append(smal3)

data4_csv = "smalltilesO5.csv"
ts4 = [ [] for i in range(128)]

    
with open(data4_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal5 = int(row['small'])
    ts4[16].append(smal5)



import matplotlib.pyplot as plt
import numpy as np


smallA = 100000000000000
for i in range(128):
  for t in ts[i]:
    smallA = min(smallA, t)


small2 = 10000000000000
for i in range(128):
  for t in ts2[i]:
    small2 = min(small2,t)





small3 = 1000000000000000
for i in range(128):
  for t in ts3[i]:
    small3 = min(small3, t)



small5 = 10000000000000000
for i in range(128):
  for t in ts4[i]:
    small5 = min(small5, t)


y = []
y.append(smallA)
y.append(small2)
#y.append(small3)
#y.append(small5)


ind = np.arange(2) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('       Diferencias entre Smalltiles ASM y Smalltiles C')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM','C'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('b')
rects1[1].set_color('m')
#rects1[2].set_color('b')
#rects1[3].set_color('g')


plt.ylim(250000,15080000)

plt.show()

