import csv

data_csv = "smalltiles320x1000.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal31 = int(row['small'])
    
    ts[45].append(smal31)

data2_csv = "smalltiles1000x320.csv"

ts2 = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal13 = int(row['small'])
    
    ts2[29].append(smal13)

data3_csv = "smalltiles200x1600.csv"
ts3 = [ [] for i in range(128)]
    
with open(data3_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal21 = int(row['small'])
    ts3[30].append(smal21)

data4_csv = "smalltiles1600x200.csv"
ts4 = [ [] for i in range(128)]

    
with open(data4_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal12 = int(row['small'])
    ts4[46].append(smal12)


data5_csv = "smalltiles640x500.csv"
ts5 = [ [] for i in range(128)]
   
with open(data5_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal65 = int(row['small'])
    ts5[53].append(smal65)

data6_csv = "smalltiles500x640.csv"
ts6 = [ [] for i in range(128)]
   
with open(data6_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal56 = int(row['small'])
    ts6[42].append(smal56)

import matplotlib.pyplot as plt
import numpy as np


small31 = 10000000000000000000
for i in range(128):
  for t in ts[i]:
    small31 = min(small31, t)


small13 = 1000000000000000000
for i in range(128):
  for t in ts2[i]:
    small13 = min(small13,t)

small21 = 1000000000000000
for i in range(128):
  for t in ts3[i]:
    small21 = min(small21, t)



small12 = 10000000000000000
for i in range(128):
  for t in ts4[i]:
    small12 = min(small12, t)

small65 = 10000000000000000000
for i in range(128):
  for t in ts5[i]:
    small65 = min(small65, t)

small56 = 10000000000000000000
for i in range(128):
  for t in ts6[i]:
    small56 = min(small56, t)


y = []

print(small56 - small65)

y.append(small65)
y.append(small56)
y.append(small13)
y.append(small31)
y.append(small12)
y.append(small21)


ind = np.arange(6) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('       Diferencias de Smalltiles ASM con imagenes de 320000 pixeles')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('640x500','500x640','1000x320','320x1000','1600x200','200x1600'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('k')
rects1[1].set_color('y')
rects1[2].set_color('b')
rects1[3].set_color('g')
rects1[4].set_color('m')
rects1[5].set_color('r')

plt.ylim(2500000,3300000)

plt.show()

