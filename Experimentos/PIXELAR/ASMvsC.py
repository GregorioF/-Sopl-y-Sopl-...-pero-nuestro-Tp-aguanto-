import matplotlib.pyplot as plt
import numpy as np
 
y = []
y.append(348796)
y.append(25172722)
y.append(7192596)
y.append(3666364)
y.append(3499926)

ind = np.arange(5) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('       Diferencias entre Pixelar ASM y Pixelar C Optimizado')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM','C','O2','O3','O4'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('c')
rects1[1].set_color('r')
rects1[2].set_color('y')
rects1[3].set_color('m')
rects1[4].set_color('g')

plt.grid(True)

plt.ylim(30000,26000000)


plt.show()