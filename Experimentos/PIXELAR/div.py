import matplotlib.pyplot as plt
import numpy as np
 
y = []
y.append(419088)
y.append(927610)

std = []
std.append(171480)
std.append(180780)


ind = np.arange(2) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width, yerr = std)

ax.set_ylabel('Ticks')
ax.set_title('       Pixelar ASM')
#ax.set_subtitle(' formas e igual cantidad de pixeles')
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('DIV SHIFT','DIV FLOAT'))
plt.text(0.25, 419088, r'%45')

plt.text(1.25, 927610, r'%100')
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('g')
rects1[1].set_color('m')
print()

plt.grid(linestyle = 'dotted')

#plt.ylim(0,35000000)


plt.show()
