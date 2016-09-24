import csv

data_csv = "rotarRompiendo400x800.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    rot = int(row['rotar'])
    
    ts[30].append(rot)

data2_csv = "rotarRompiendo800x400.csv"

ts2 = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    romp = int(row['rompiendo'])
    
    ts2[30].append(romp)

data3_csv = "rotarSinRomper400x800.csv"
ts3 = [ [] for i in range(128)]

    
with open(data3_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    o5 = int(row['sinR'])
    
    ts3[30].append(o5)

data4_csv = "rotarSinRomper800x400.csv"
ts4 = [ [] for i in range(128)]

    
with open(data4_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    sinR8 = int(row['sinR8'])
    
    ts4[30].append(sinR8)


import matplotlib.pyplot as plt
import numpy as np


rotar = 1000000
for i in range(128):
	for t in ts[i]:
		rotar = min(rotar, t)

romper = 1000000
for i in range(128):
	for t in ts2[i]:
		romper = min(romper, t)

co5 = 1000000
for i in range(128):
	for t in ts3[i]:
		co5 = min(co5, t)

sinRomp = 1000000
for i in range(128):
  for t in ts4[i]:
    sinRomp = min(sinRomp, t)


y = []
y.append(co5)
y.append(rotar)
y.append(sinRomp)
y.append(romper)


ind = np.arange(4) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width, color='r')

ax.set_ylabel('Ciclos')
ax.set_title('Diferencias de Rotar ASM llenando de basura la cache')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('400x800', '400x800 Rompiendo', '800x400', '800x400 Rompiendo'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('b')
rects1[1].set_color('g')
rects1[2].set_color('r')
rects1[3].set_color('y')
plt.ylim(270000,281000)

plt.show()

