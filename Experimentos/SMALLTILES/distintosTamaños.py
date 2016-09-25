import csv

data_csv = "smalltiles400x800.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal48 = int(row['small'])
    
    ts[30].append(smal48)

data2_csv = "smalltiles800x400.csv"

ts2 = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal84 = int(row['small'])
    
    ts2[30].append(smal84)

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


small48 = 100000000
for i in range(128):
  for t in ts[i]:
    small48 = min(small48, t)


small84 = 1000000
for i in range(128):
  for t in ts2[i]:
    small84 = min(small84,t)





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
y.append(small48)
y.append(small84)
y.append(small56)
y.append(small65)
y.append(small21)
y.append(small12)


ind = np.arange(6) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('       Diferencias de Smalltiles ASM con 320000 pixeles')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('400x800','800x400','500x640','640x500','200x1600','1600x200'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('k')
rects1[1].set_color('y')
rects1[2].set_color('b')
rects1[3].set_color('g')
rects1[4].set_color('m')
rects1[5].set_color('r')

plt.ylim(200000,3280000)

plt.show()

