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


data4_csv = "rotarO3.csv"

ts4 = [ [] for i in range(128)]

with open(data4_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    O3 = int(row['rotar'])
    
    ts4[44].append(O3)



import matplotlib.pyplot as plt
import numpy as np

ind = 0
rota = []
rotar = 0
for i in range(128):
	for t in ts[i]:
		rotar = rotar + t
		ind = ind + 1
		rota.append(t)

rotar = rotar/ind		
stdRotar = np.std(rota)
ind = 0
rota2 = []
rotar2 = 0
for i in range(128):
	for t in ts2[i]:
		rotar2 = rotar2 + t
		ind = ind + 1
		rota2.append(t)

rotar2 = rotar2/ind
rota3 = []
o3 = 0
ind = 0
for i in range(128):
  for t in ts4[i]:
    o3 = o3 + t
    ind = ind + 1  
    rota3.append(t)

o3 = o3/ind    
stdO3 = np.std(rota3)
stdC = np.std(rota2)

stdd = []
stdd.append(stdRotar)
stdd.append(stdC)
stdd.append(stdO3)



y = []
y.append(rotar)

y.append(rotar2)

y.append(o3)



ind = np.arange(3) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width, yerr = stdd)

ax.set_ylabel('Ciclos')
ax.set_title('Comparacion de cantidad de ciclos entre ASM y distintas optimizaciones de C')
#plt.suptitle('de Rotar ASM y Rotar C', y=1.05, fontsize=17)
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM','C','O3:CONTROL'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('g')
rects1[1].set_color('b')
rects1[2].set_color('r')
plt.grid(linestyle = 'dotted' ,linewidth = 0.5)
plt.text(0.25, 550000, r'%8')
plt.text(2.25, 4763388, r'%100' )
plt.text(1.25, 15000000, r'%305')

print(rotar)
print(rotar2)
print(o3)

print((rotar*100)/o3)
print((rotar2*100)/o3)

plt.show()

