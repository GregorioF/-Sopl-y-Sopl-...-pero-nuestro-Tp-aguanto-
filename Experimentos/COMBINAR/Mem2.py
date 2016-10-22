import csv

data_csv = "tiemposTotalPorIteracion.csv"

ts = [ [] for i in range(128)]

with open(data_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    rot = float(row['tiempos'])
    
    ts[38].append(rot)

total = 10000000000000000
for i in range(128):
  for t in ts[i]:
    total = min(total, t)


data2_csv = "tiemposEscribirPorIteracion.csv"

ts2 = [ [] for i in range(128)]

with open(data2_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    rot1 = float(row['tiempos'])
    
    ts2[63].append(rot1)

escribir = 10000000000000000
for i in range(128):
  for t in ts2[i]:
    escribir = min(escribir, t)

data3_csv = "tiemposLeerPorIteracion.csv"

ts3 = [ [] for i in range(128)]

with open(data3_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    O2 = float(row['tiempos'])
    
    ts3[69].append(O2)

leer = 10000000000000000
for i in range(128):
  for t in ts3[i]:
    leer = min(leer, t)


data4_csv = "tiemposProcesarPorIteracion.csv"

ts4 = [ [] for i in range(128)]

with open(data4_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    O3 = float(row['tiempos'])
    
    ts4[67].append(O3)

procesar = 10000000000000000
for i in range(128):
  for t in ts4[i]:
    procesar = min(procesar, t)


import matplotlib.pyplot as plt
import numpy as np


fig, (ax1, ax2) = plt.subplots(1, 2)

labels = 'Escribir', 'Leer', 'Procesar'
sizes = [escribir, leer, procesar]
colors = ['gold', 'lightcoral', 'lightskyblue']
explode = (0.1, 0)  # explode 1st slice

sizes1 = [20199890, 33843368 - 20199890]
colors1 = ['lightskyblue', 'yellowgreen']
 
# Plot

ax1.pie(sizes, autopct='%1.1f%%', colors=colors, shadow=True, startangle=90)

ax1.legend(labels, loc="best")

ax1.axis('equal')


#ax2.pie(sizes1, autopct='%1.1f%%',explode=explode, colors=colors1, shadow=True, startangle=90)

#ax2.legend(labels, loc="best")

#ax2.axis('equal')
ax1.set_title('C')
#ax2.set_title('NULL')

#print(total)
#print(procesar+leer+escribir)

plt.show()

