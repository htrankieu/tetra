import matplotlib.pyplot as plt
import numpy as np
from thm_utilities import readCSVFile



data = readCSVFile('pleg_cuboid_tr_csv.csv')
data_comsol_T = readCSVFile('T_tr_comsol.csv')

plt.figure(figsize=(12, 8))
plt.rc('font', family='sans-serif', size=14)
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Time [s]")
plt.ylabel("Cold side temperature [C]")



data_comsol_T = readCSVFile('T_tr_comsol.csv')

plt.plot(data['time'], data['T_cold'], linestyle='-', marker='',color='cornflowerblue')
plt.plot(data_comsol_T["time"], data_comsol_T["T"], linestyle='', marker='o', color='cornflowerblue')

ax.legend( ['MOOSE', "COMSOL"], frameon=False, prop={'size':14}, loc='lower right')
# ax.set_xlim([0,1.2])
plt.tight_layout()
plt.savefig('T_cold.png')
plt.close()
