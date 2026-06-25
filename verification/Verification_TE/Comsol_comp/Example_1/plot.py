import matplotlib.pyplot as plt
import numpy as np
from thm_utilities import readCSVFile


Intensities = range(0,21)
# number = str(cases[4]).zfill(2)


cases=[]
cases.append({'legend':'0W, constant', 'repo':'results','suffix':'', 'comsol_file':'T_cold.csv', 'color':'cornflowerblue'})
cases.append({'legend':'0W, temperature dependent', 'repo':'results','suffix':'_var_prop', 'comsol_file':'T_cold_var_prop.csv', 'color':'indianred'})
cases.append({'legend':'10mW, constant', 'repo':'results_10mW','suffix':'', 'comsol_file':'T_cold_10mW.csv', 'color':'green'})
cases.append({'legend':'10mW, temperature dependent', 'repo':'results_10mW','suffix':'_var_prop', 'comsol_file':'T_cold_10mW_var_prop.csv', 'color':'orange'})


plt.figure(figsize=(8, 6))
plt.rc('font', family='sans-serif', size=14)
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Current [A]")
plt.ylabel("Cold side temperature [C]")
leg_items = []
for case in cases:
   I = []
   T_cold = []
   for item in Intensities:
    filename = case['repo']+"/I"+str(item).zfill(2)+case['suffix']+".csv"
    print(filename)
    data = readCSVFile(filename)
    # disp.append(data['disp'][-1])
    I.append(item/10.)
    # I.append(-1 *data['I_out'][-1])
    T_cold.append(data['T_cold'][-1])

   data_comsol_T = readCSVFile(case['comsol_file'])

   plt.plot(I, T_cold, linestyle='-', marker='',  color=case['color'])
   plt.plot(data_comsol_T["I"], data_comsol_T["T"], linestyle='', marker='o', color=case['color'])
   leg_items.append(case['legend']+', MOOSE')
   leg_items.append(case['legend']+', COMSOL')
ax.legend( leg_items, frameon=False, prop={'size':14}, loc='upper right')
ax.set_xlim([0,1.2])
ax.set_ylim([200,380])
plt.tight_layout()
plt.savefig('T_cold.png')
plt.close()
