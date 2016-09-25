import csv

data_csv = "rotarRompiendo400x800.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    romp48 = int(row['rotar'])
    
    ts[30].append(romp48)

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

a = []

romper48 = 100000000
for i in range(128):
  for t in ts[i]:
    romper48 = min(romper48, t)
    a.append(t)

varianza1 = np.std(a)


b = []
romper84 = 1000000
for i in range(128):
  for t in ts2[i]:
    romper84 = min(romper84,t)
    b.append(t)
   
varianza2 = np.std(b)


c = []
rotar48 = 1000000
for i in range(128):
  for t in ts3[i]:
    rotar48 = min(rotar48, t)
    c.append(t)
   

varianza3 = np.std(c)

print(varianza3)

d = []
rotar84 = 100000000
for i in range(128):
  for t in ts4[i]:
    d.append(t)
    rotar84 = min(rotar84, t)

varianza4 = np.std(d)

y = []
y.append(rotar48)
y.append(romper48)
y.append(rotar84)
y.append(romper84)

std = []
std.append(varianza1)
std.append(varianza2)
std.append(varianza3)
std.append(varianza4)


ind = np.arange(4) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('Diferencias de Rotar ASM llenando de basura la cache')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('400x800', '400x800 Rompiendo', '800x400', '800x400 Rompiendo'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('m')
rects1[1].set_color('g')
rects1[2].set_color('r')
rects1[3].set_color('y')
plt.ylim(275000,282000)

plt.show()

