import numpy as np
import matplotlib.pyplot as plt
x = arange(0,1,0.1)
y = -(np.log10(1 - x))
plt.plot(x, y)
