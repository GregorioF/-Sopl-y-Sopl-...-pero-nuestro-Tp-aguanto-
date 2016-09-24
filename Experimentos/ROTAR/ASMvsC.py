import csv

data_csv = "rotar.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    rot = int(row['rotar'])
    
    ts[100].append(rot)

data2_csv = "rotarC.csv"

ts2 = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    rot1 = int(row['rotar'])
    
    ts2[30].append(rot1)



import matplotlib.pyplot as plt
import numpy as np


rotar = 1000000
for i in range(128):
	for t in ts[i]:
		rotar = min(rotar, t)

rotar2 = 1000000
for i in range(128):
	for t in ts2[i]:
		rotar2 = min(rotar2, t)


y = []
y.append(rotar)
y.append(rotar2)


ind = np.arange(2) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('Diferencias de Rotar ASM con Rotar C')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM','C'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('g')
rects1[1].set_color('b')

plt.ylim(0, 1050000)

plt.show()

