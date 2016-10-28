import matplotlib.pyplot as plt
import numpy as np
 
y = []
y.append(1380990)
y.append(71138704)

ind = np.arange(2) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')
ax.set_title('       Diferencias entre 	Combinar ASM y Combinar C')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('ASM','O3'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('c')
rects1[1].set_color('r')

plt.grid(True)

#plt.ylim(0,35000000)


plt.show()