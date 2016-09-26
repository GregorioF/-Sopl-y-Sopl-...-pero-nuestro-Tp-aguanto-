import matplotlib.pyplot as plt
 
fig, (ax1, ax2) = plt.subplots(1, 2)

labels = 'Escribir y leer memoria', 'Resto del filtro'
sizes = [182109, 1190733 - 182109]
colors = ['gold', 'lightcoral']
explode = (0.1, 0)  # explode 1st slice

sizes1 = [20199890, 33843368 - 20199890]
colors1 = ['lightskyblue', 'yellowgreen']
 
# Plot

ax1.pie(sizes, autopct='%1.1f%%', explode=explode, colors=colors, shadow=True, startangle=90)

ax1.legend(labels, loc="best")

ax1.axis('equal')


ax2.pie(sizes1, autopct='%1.1f%%',explode=explode, colors=colors1, shadow=True, startangle=90)

ax2.legend(labels, loc="best")

ax2.axis('equal')
ax1.set_title('ASM')
ax2.set_title('C')
plt.show()