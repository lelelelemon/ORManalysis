import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse, Polygon

fig = plt.figure()
ax1 = fig.add_subplot(111)
ax1.bar(range(1, 5), [3,4,5,6], color='red', edgecolor='black')
ax1.bar(range(1, 5), [1, 1, 1, 1], bottom=[3,4,5,6], color='blue', edgecolor='black')
ax1.set_xticks([1.5, 2.5, 3.5, 4.5])

plt.show()
