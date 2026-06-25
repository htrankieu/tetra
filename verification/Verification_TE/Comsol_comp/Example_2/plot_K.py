import matplotlib.pyplot as plt
import numpy as np
import csv

# Helper function to read CSV files into a dictionary format
def read_csv_file(filepath):
    data = {}
    with open(filepath, mode='r') as file:
        reader = csv.reader(file)
        headers = next(reader)  # Read the first row as headers
        for header in headers:
            data[header] = []  # Initialize empty lists for each column

        for row in reader:
            for i, value in enumerate(row):
                data[headers[i]].append(float(value))  # Convert values to float
    return data

# Read data from CSV files
data = read_csv_file('pleg_cuboid_tr_csv.csv')
data_comsol_T = read_csv_file('T_tr_comsol.csv')

# Convert temperatures from Celsius to Kelvin
data['T_cold'] = [temp + 273.15 for temp in data['T_cold']]  # Convert MOOSE cold side temperature
data_comsol_T['T'] = [temp + 273.15 for temp in data_comsol_T['T']]  # Convert COMSOL temperature

# Plot setup
plt.figure(figsize=(12, 8))
plt.rc('font', family='sans-serif', size=16)
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Time [s]")
plt.ylabel("Cold side temperature [K]")  # Updated Y-axis label for Kelvin

# Plot data
plt.plot(data['time'], data['T_cold'], linestyle='-', marker='', color='cornflowerblue')  # MOOSE data
plt.plot(data_comsol_T["time"], data_comsol_T["T"], linestyle='', marker='o', color='cornflowerblue')  # COMSOL data

# Add legend
ax.legend(['MOOSE', "COMSOL"], frameon=False, prop={'size': 16}, loc='lower right')

# Finalize and save plot
plt.tight_layout()
plt.savefig('T_cold_K.png')  # Updated filename to reflect Kelvin
plt.close()
