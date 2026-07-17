import matplotlib.pyplot as plt
import numpy as np
from thm_utilities import readCSVFile
import subprocess
# from subprocess import check_output
import os

# I = np.linspace(0.0, 1.5, 16)
I = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5]
Volt = []
power=[]

for i in I:
   # i_c = int(current)
   base = 'current_' + str(i)
   # base = 'pattern_' + str(i_c).zfill(2)
#    y.append(float(position.split(', ')[0]) + 0.02)
#    z.append(float(position.split(', ')[1])+0.02)
   result_name = base + ".csv"
   data = readCSVFile(result_name)
  #  I.append(-1 *data['I_out'][-1])
   Volt.append(data['U_load'][-1])
   power.append(data['P_load'][-1])


plt.figure(figsize=(8, 6))
plt.rc('font', family='sans-serif', size=14)
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Current [A]")
plt.ylabel("Power [W]")

plt.plot(I, power, marker='', alpha=0.9, color='cornflowerblue',      label='base')

ax.legend(frameon=False, prop={'size':10})
plt.tight_layout()
plt.savefig('TEM_power.png', dpi=1000)

# print(np.sum(power))


