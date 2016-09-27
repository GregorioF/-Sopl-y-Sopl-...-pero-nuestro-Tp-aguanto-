import matplotlib.pyplot as plt
import numpy as np

ur = 35285958
asm = 21050994

y = []
y.append(asm)

y.append(ur)



ind = np.arange(2) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
#plt.suptitle('de Rotar ASM y Rotar C', y=1.05, fontsize=17)
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('Original','Unrolling completo'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('r')
rects1[1].set_color('g')

plt.ylim(0, 37000000)

plt.show()

