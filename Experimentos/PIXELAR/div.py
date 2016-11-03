import matplotlib.pyplot as plt
import numpy as np
 
y = []
y.append(352064)
y.append(880225)

ind = np.arange(2) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ticks')
ax.set_title('       Pixelar ASM')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('DIV SHIFT','DIV FLOAT'))
plt.text(0.25, 359999, r'%100')

plt.text(1.25, 889999, r'%250')
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('g')
rects1[1].set_color('m')


plt.grid(linestyle = 'dotted')

#plt.ylim(0,35000000)


plt.show()
