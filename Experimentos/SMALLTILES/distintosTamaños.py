import csv

data_csv = "smalltiles320x1000.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal31 = float(row['small'])
    
    ts[20].append(smal31)

data2_csv = "smalltiles1000x320.csv"

ts2 = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal13 = float(row['small'])
    
    ts2[20].append(smal13)

data3_csv = "smalltiles200x1600.csv"
ts3 = [ [] for i in range(128)]
    
with open(data3_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal21 = float(row['small'])
    ts3[20].append(smal21)

data4_csv = "smalltiles1600x200.csv"
ts4 = [ [] for i in range(128)]

    
with open(data4_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal12 = float(row['small'])
    ts4[20].append(smal12)


data5_csv = "smalltiles640x500.csv"
ts5 = [ [] for i in range(128)]
   
with open(data5_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal65 = float(row['small'])
    ts5[20].append(smal65)

data6_csv = "smalltiles500x640.csv"
ts6 = [ [] for i in range(128)]
   
with open(data6_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smal56 = float(row['small'])
    ts6[20].append(smal56)

import matplotlib.pyplot as plt
import numpy as np

ind = 0
small31 = 0
for i in range(128):
  for t in ts[i]:
    small31 = small31 + t
    ind = ind +1

    
small31 = small31/ind
small31 = small31/80000

ind = 0
small13 = 0
for i in range(128):
  for t in ts2[i]:
    small13 = small13 + t
    ind = ind + 1

small13 = small13/ind
small13 = small13/80000
ind = 0
small21 = 0
for i in range(128):
  for t in ts3[i]:
    small21 = small21 + t
    ind = ind + 1
    
small21 = small21/ind
small21 = small21/80640
ind = 0
small12 = 0
for i in range(128):
  for t in ts4[i]:
    small12 = small12 + t
    ind = ind + 1
    
small12 = small12/ind
small12 = small12/80000
ind = 0
small65 = 0
for i in range(128):
  for t in ts5[i]:
    small65 = small65 + t
    ind = ind + 1
    
small65 = small65/ind
small65 = small65/80000
ind = 0
small56 = 0
for i in range(128):
  for t in ts6[i]:
    small56 = small56 + t
    ind = ind + 1
    
small56 = small56/ind
small56 = small56/80640


y = []

y.append(small65)
y.append(small56)
y.append(small13)
y.append(small31)
y.append(small12)
y.append(small21)
x = [1,2,3,4,5,6]
labels = ['640x500','500x640','1000x320','320x1000','1600x200','200x1600']
plt.xticks(x, labels)
plt.xlim(0,6.5)
plt.ylim(3,6.5)
plt.title('Ticks/Pixeles Procesados')
plt.plot(x,y,'ro')
plt.ylabel('Ticks')
plt.show()

