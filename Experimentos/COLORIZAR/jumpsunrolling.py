import matplotlib.pyplot as plt
import numpy as np

asm = 5980263
jmp = 5977453
ur = 5873712

y = []
y.append(asm)
y.append(jmp)
y.append(ur)



ind = np.arange(3) 
width = .75     

fig, ax = plt.subplots()
rects1 = ax.bar(ind, y, width)

ax.set_ylabel('Ciclos')

#plt.suptitle('de Rotar ASM y Rotar C', y=1.05, fontsize=17)
ax.set_xticks(ind + 0.4)
ax.set_xticklabels(('Original','Modificaciones Jump-Predictor','Unrolling 32 ciclos'))
plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
rects1[0].set_color('b')
rects1[1].set_color('y')
rects1[2].set_color('m')
plt.ylim(0, 6050000)

plt.show()

