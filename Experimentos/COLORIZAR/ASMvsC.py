import matplotlib.pyplot as plt
import numpy as np

asm = 5980263
c = 101898160
o3 = 21567776

y = []
y.append(asm)
y.append(c)
y.append(o3)



ind = np.arange(3) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('Comparacion de cantidad de ciclos entre ASM y distintas optimizaciones de C')
#plt.suptitle('de Rotar ASM y Rotar C', y=1.05, fontsize=17)
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM','C','O3'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('g')
rects1[1].set_color('b')
rects1[2].set_color('r')
plt.ylim(0, 102500000)

plt.show()

