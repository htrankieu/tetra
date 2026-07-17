import matplotlib.pyplot as plt
import numpy as np
from thm_utilities import readCSVFile
import subprocess
# from subprocess import check_output
import os


# expr_BiSbTeSe = read_csv_file('chen_data/expr_BiSbTeSe.csv')
expr_BiTe = readCSVFile('chen_data/expr_BiTe.csv')
# sim_BiSbTeSe = read_csv_file('chen_data/sim_BiSbTeSe.csv')
sim_BiTe = readCSVFile('chen_data/sim_BiTe.csv')


temperature = [325, 350, 375, 400, 425, 450, 475, 500]
temp_diff = []
voltage=[]

for t in temperature:

   base = 'temperature/temp_' + str(t)
   result_name = base +".csv"
   data = readCSVFile(result_name)
   temperature_diff = t - 300
   temp_diff.append(temperature_diff)
   voltage.append(data['U_load'][-1])


plt.figure(figsize=(8, 6))
plt.rc('font', family='sans-serif', size=14)
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.ylabel("Open-circuit Voltage [V]", fontsize=16)
plt.xlabel("Temperature Difference [T]", fontsize=16)



plt.plot(temp_diff, voltage, marker='', color='green', linewidth=3, label='TETRA')
plt.plot(sim_BiTe['T'], sim_BiTe['V'], label='Chen sim', color='orange', linewidth=3)
plt.plot(expr_BiTe['T'], expr_BiTe['V'], marker='s', markersize=10, linestyle="", label='Chen expr', color='cornflowerblue')

ax.legend(frameon=False, prop={'size':16})
plt.tight_layout()
plt.savefig('TEM_open_circuit_voltage.png', dpi=1000)