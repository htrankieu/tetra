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

# Case range
cases = range(0, 21)

# Initialize data containers
I = []
T_cold = []
disp = []

# Process data for MOOSE
for item in cases:
    filename = "results/I" + str(item).zfill(2) + ".csv"
    print(f"Reading file: {filename}")
    data = read_csv_file(filename)
    disp.append(data['disp'][-1])  # Displacement
    I.append(item / 10.0)  # Current in Amps
    T_cold.append(-1 * data['delta_T'][-1] + 273.15)  # Convert cold-side temperature to Kelvin

# Read COMSOL data
data_comsol_T = read_csv_file('T_cold_comsol.csv')
data_comsol_disp = read_csv_file('disp_comsol.csv')

# Convert COMSOL temperature to Kelvin
data_comsol_T['T'] = [temp + 273.15 for temp in data_comsol_T['T']]

# Plot: Cold Side Temperature vs Current
plt.figure(figsize=(8, 6), dpi = 1000)
plt.rc('font', family='sans-serif', size=16)  # Increased font size to 16
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Current [A]")
plt.ylabel("Cold side temperature [K]")  # Updated Y-axis label for Kelvin
plt.plot(I, T_cold, linestyle='-', marker='', color='cornflowerblue', label='MOOSE')
plt.plot(data_comsol_T["I"], data_comsol_T["T"], linestyle='--', marker='', color='orange', label='COMSOL')
ax.legend(frameon=False, prop={'size': 16}, loc='upper right')  # Increased legend font size
plt.tight_layout()
plt.savefig('T_cold_K.png')  # Updated filename to reflect Kelvin
plt.close()

# Plot: Displacement vs Current
plt.figure(figsize=(8, 6), dpi = 1000)
plt.rc('font', family='sans-serif', size=16)  # Increased font size to 16
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Current [A]")
plt.ylabel("Displacement [m]")
plt.plot(I, disp, linestyle='-', marker='', color='cornflowerblue', label='MOOSE')
plt.plot(data_comsol_disp["I"], data_comsol_disp["disp"], linestyle='--', marker='', color='orange', label='COMSOL')
ax.legend(frameon=False, prop={'size': 16}, loc='upper left')  # Increased legend font size
plt.tight_layout()
plt.savefig('disp_font.png')  # Displacement plot filename remains unchanged
plt.close()
