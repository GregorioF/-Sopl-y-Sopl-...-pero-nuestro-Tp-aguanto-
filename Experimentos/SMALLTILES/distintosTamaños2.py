import matplotlib.pyplot as plt
import numpy as np

y = []

y.append(300110.625/80000)
y.append(447756.500/86400)
y.append(364287.438/80000)
y.append(321996.156/80000)
y.append(299306.156/80000)
y.append(393780.656/80000)
x = [1,2,3,4,5,6]
labels = ['640x500','500x640','1000x320','320x1000','1600x200','200x1600']
plt.xticks(x, labels)
plt.xlim(0,6.5)
plt.ylim(3,6.5)

plt.plot(x,y,'ro')
plt.ylabel('Ticks')
plt.show()

