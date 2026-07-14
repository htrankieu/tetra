import matplotlib.pyplot as plt
import numpy as np
from thm_utilities import readCSVFile
import subprocess
# from subprocess import check_output
import os

I = np.linspace(0, 2.5, 26)

cases=[{'case_folder':'mesh_study_coarse/pattern_', 'legend':'0.4 mm', 'color':'indianred'},
       {'case_folder':'pattern_', 'legend':'0.2 mm', 'color':'cornflowerblue'},
       {'case_folder':'mesh_study_fine/pattern_', 'legend':'0.1 mm', 'color':'green'}]


plt.figure(figsize=(8, 6))
plt.rc('font', family='sans-serif', size=14)
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Current [A]")
plt.ylabel("Power [W]")

for mesh in cases:
   Volt = []
   power=[]
   for (i, current) in enumerate(I):
      i_c = int(current * 10)
      base = mesh['case_folder'] + str(i_c).zfill(2)
      result_name = base +".csv"
      data = readCSVFile(result_name)
      Volt.append(data['U_load'][-1])
      power.append(data['P_load'][-1])


   plt.plot(I, power, marker='o', color=mesh['color'],  label=mesh['legend'])

ax.legend(frameon=False, prop={'size':14})
plt.tight_layout()
plt.savefig('TEM_power_mesh.png', dpi=300)

ax.set_xlim([0.8, 1.5])
ax.set_ylim([2.6, 2.9])
plt.tight_layout()
plt.savefig('TEM_power_mesh_zoom.png', dpi=300)

# print(np.sum(power))


