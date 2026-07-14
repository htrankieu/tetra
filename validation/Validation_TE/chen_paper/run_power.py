# import matplotlib.pyplot as plt
import numpy as np
from thm_utilities import readCSVFile
import subprocess
import os

I = np.linspace(16, 2.5, 10)
Volt = []
power=[]

for (i, current) in enumerate(I):
   i_c = int(current * 10)
   base = 'pattern_' + str(i_c).zfill(2)
  #  command_list = ['ls', '-l', '> out']
   command_list = ['mpirun', '-n', '112','moose-dev-exec', '/projects/USU/Thermoelectric-Working/tetra_bitterroot/tetra/tetra-opt', '-i', 'module_cuboid_pattern_sq.i',
                        f'I={current}', f'Outputs/file_base={base}', '-w', '--use-split', '--split-file', 'pattern.cpa.gz']

   result = subprocess.run(command_list, capture_output=True, text=True)

   if result.returncode == 0:
    print("Command executed successfully:")
    print(result.stdout)
   else:
    print("Command failed with error:")
    print(result.stderr)
