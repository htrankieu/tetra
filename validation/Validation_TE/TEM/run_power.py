# import matplotlib.pyplot as plt
import numpy as np
from thm_utilities import readCSVFile
import subprocess
# from subprocess import check_output
import os

I = np.linspace(1.6, 2.5, 10)
Volt = []
power=[]

# plt.figure(figsize=(8, 6))
# plt.rc('font', family='sans-serif', size=14)
# ax = plt.subplot(1, 1, 1)
# ax.get_yaxis().get_major_formatter().set_useOffset(False)
for (i, current) in enumerate(I):
   i_c = int(current * 10)
   base = 'pattern_' + str(i_c).zfill(2)
  #  command_list = ['ls', '-l', '> out']
   command_list = ['mpirun', '-n', '112', '/projects/USU/Thermoelectric-Hailey/tetra-test/tetra/tetra-opt', '-i', 'module_cuboid_pattern_sq.i',
                        f'I={current}', f'Outputs/file_base={base}', '-w', '--use-split', '--split-file', 'pattern_mesh.cpa.gz']
  
  #  command_list = ['mpirun', '-n', '112','moose-dev-exec', '/projects/USU/Thermoelectric-Hailey/tetra-test/tetra/tetra-opt', '-i', 'module_cuboid_pattern_sq.i',
  #                       f'I={current}', f'Outputs/file_base={base}', '-w', '--use-split', '--split-file', 'pattern_mesh.cpa.gz']
  
  #  print(command_list)
  #  os.system('module load use.moose moose-dev-openmpi/2025.04.22')
  #  os.system('module list')
   result = subprocess.run(command_list, capture_output=True, text=True)

   if result.returncode == 0:
    print("Command executed successfully:")
    print(result.stdout)
   else:
    print("Command failed with error:")
    print(result.stderr)
  #  out = subprocess.check_output(command_list)
#    y.append(float(position.split(', ')[0]) + 0.02)
#    z.append(float(position.split(', ')[1])+0.02)
  #  result_name = "Pipe_only_out_TE"+str(i).zfill(2)+".csv"
#    print(result_name)
#    data = readCSVFile(result_name)
# #    # disp.append(data['disp'][-1])
# #    I.append(item/100.)
#    I.append(-1 *data['I_out'][-1])
#    Volt.append(data['U_load'][-1])
#    power.append(data['P_load'][-1])


# f, ax = plt.subplots(figsize=(8, 8))
# ax.set_xlim([0,0.16] )
# ax.set_ylim([0.05,0.25] )
# plt.rc('font', family='sans-serif', size=14)
# points = ax.scatter(y, z, c=power, s=9000, marker="s", cmap="viridis")

# f.colorbar(points, label = 'Power [W]')

# plt.axis('off')
# plt.tight_layout()
# plt.savefig('power.png', dpi=300)

# print(np.sum(power))


