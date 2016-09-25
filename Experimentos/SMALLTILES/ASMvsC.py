import csv

data_csv = "smalltilesASM.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smalA = int(row['small'])
    
    ts[30].append(smalA)

data5_csv = "smalltiles.csv"

ts5 = [ [] for i in range(128)]

with open(data5_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smalC = int(row['small'])
    
    ts5[23].append(smalC)

data2_csv = "smalltilesO2.csv"

ts2 = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal2 = int(row['small'])
    
    ts2[23].append(smal2)

data3_csv = "smalltilesO3.csv"
ts3 = [ [] for i in range(128)]
    
with open(data3_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal3 = int(row['small'])
    ts3[2].append(smal3)

data4_csv = "smalltilesO4.csv"
ts4 = [ [] for i in range(128)]

    
with open(data4_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal4 = int(row['small'])
    ts4[33].append(smal4)



import matplotlib.pyplot as plt
import numpy as np


smallA = 10000000000000000000
for i in range(128):
  for t in ts[i]:
    smallA = min(smallA, t)


small2 = 10000000000000000000
for i in range(128):
  for t in ts2[i]:
    small2 = min(small2,t)



small3 = 10000000000000000000
for i in range(128):
  for t in ts3[i]:
    small3 = min(small3, t)



small4 = 10000000000000000000
for i in range(128):
  for t in ts4[i]:
    small4 = min(small4, t)


smallC = 10000000000000000000
for i in range(128):
  for t in ts5[i]:
    smallC = min(smallC, t)



y = []
y.append(smallA)
y.append(smallC)
y.append(small2)
y.append(small3)
y.append(small4)


ind = np.arange(5) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('       Diferencias entre Smalltiles ASM y Smalltiles C')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM','C','O2','O3','O4'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('b')
rects1[1].set_color('r')
rects1[2].set_color('g')
rects1[3].set_color('y')
rects1[4].set_color('c')
plt.grid(True)

plt.ylim(250000,12080000)

plt.show()

