import csv

data_csv = "tiemposTotal.csv"

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


data2_csv = "tiemposEscribir.csv"

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

data3_csv = "tiemposLeer.csv"

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


data4_csv = "tiemposProcesar.csv"

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



data5_csv = "tiemposEscribirCombinar.csv"

ts5 = [ [] for i in range(128)]

with open(data5_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    rot5 = float(row['tiempos'])
    
    ts5[49].append(rot5)

escribirC = 10000000000000000
for i in range(128):
  for t in ts5[i]:
    escribirC = min(escribirC, t)

data6_csv = "tiemposLeerCombinar.csv"

ts6 = [ [] for i in range(128)]

with open(data6_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    O6 = float(row['tiempos'])
    
    ts6[49].append(O6)

leerC = 10000000000000000
for i in range(128):
  for t in ts6[i]:
    leerC = min(leerC, t)


data7_csv = "tiemposProcesarCombinar.csv"

ts7 = [ [] for i in range(128)]

with open(data7_csv) as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    O7 = float(row['tiempos'])
    
    ts7[49].append(O7)

procesarC = 10000000000000000
for i in range(128):
  for t in ts7[i]:
    procesarC = min(procesarC, t)



import matplotlib.pyplot as plt
import numpy as np


fig, (ax1, ax2) = plt.subplots(1, 2)

labels = 'Escribir', 'Leer', 'Procesar'
sizes = [escribir, leer, procesar]
colors = ['gold', 'lightcoral', 'lightskyblue']
explode = (0.1, 0)  # explode 1st slice

sizes1 = [leerC,  procesarC, escribirC]
colors1 = ['yellowgreen','purple','red']
 
# Plot

ax1.pie(sizes, autopct='%1.1f%%', colors=colors, shadow=True, startangle=90)

ax1.legend(labels, loc="best")

ax1.axis('equal')


ax2.pie(sizes1, autopct='%1.1f%%', colors=colors1, shadow=True, startangle=90)

ax2.legend(labels, loc="best")

ax2.axis('equal')
ax1.set_title('C')
ax2.set_title('ASM')

print(total)
print(procesar+leer+escribir)

plt.show()

