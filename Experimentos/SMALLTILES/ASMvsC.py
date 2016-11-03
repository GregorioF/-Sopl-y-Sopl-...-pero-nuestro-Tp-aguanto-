import csv

data_csv = "smalltilesASM.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smalA = float(row['small'])
    
    ts[30].append(smalA)

data5_csv = "smalltiles.csv"

ts5 = [ [] for i in range(128)]

with open(data5_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    smalC = float(row['small'])
    
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

ind = 0
a = []
smallA = 0
for i in range(128):
  for t in ts[i]:
	  ind = ind + 1
	  smallA = smallA + t
	  a.append(t)

stdA = np.std(a)
smallA = smallA/ind

s2 = []
ind = 0
small2 = 0
for i in range(128):
  for t in ts2[i]:
	  ind = ind + 1
	  small2 = small2 + t
	  s2.append(t)

std2 = np.std(s2)
small2 = small2/ind


s3 = []

ind = 0
small3 = 0
for i in range(128):
  for t in ts3[i]:
	  ind = ind + 1
	  small3 = small3 + t
	  s3.append(t)

small3 = small3/ind
std3 = np.std(s3)

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
y.append(small2)
y.append(small3)

stdd = []

stdd.append(stdA)
stdd.append(std2)
stdd.append(std3)

ind = np.arange(3) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width, yerr = stdd)

ax.set_ylabel('Ticks')
ax.set_title('       Diferencias entre Smalltiles ASM y Smalltiles C')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM','O2','O3:CONTROL'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('b')
rects1[1].set_color('r')
rects1[2].set_color('g')
plt.grid(linestyle = 'dotted')
print(small2)
print(small3)
print((smallA*100)/small3)
print((small2*100)/small3)
print((smallC*100)/small3)
plt.text(0.25, 530000, r'%15')
plt.text(1.25, 4312981, r'%130')
plt.text(2.25, 3317645, r'%100')
plt.text(0.17, 5000000, 'O0 : %372',
        bbox={'facecolor':'white', 'alpha':0.5, 'pad':10})
plt.show()

