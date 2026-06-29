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

# Intensity range
Intensities = range(0, 26)

# Case definition
cases = []
cases.append({'legend': '0W, constant', 'repo': 'results_constant', 'suffix': '', 'comsol_file': 'T_cold.csv'})

I = []
Volt = []
power = []

# Process data for MOOSE
for item in Intensities:
    filebase = cases[0]['repo'] + "/I" + str(item).zfill(2)
    I_bc = item / 100.0  # Current boundary condition
    filename = filebase + ".csv"
    print(f"Reading file: {filename}")

    data = read_csv_file(filename)
    I.append(item / 100.0)  # Current in Amps
    Volt.append(data['Vtop'][-1])  # Voltage
    power.append(data['P_load'][-1] * -1)  # Power (negated)

# Constants for analytic solution
k = 1.6  # Thermal conductivity [W/m-K]
A = 1e-6  # Cross-sectional area [m^2]
l = 5.8e-3  # Length [m]
alpha = 200e-6  # Seebeck coefficient [V/K]
sigma = 1.1e5  # Electrical conductivity [S/m]

# Derived constants
coeff_th = k * A / l  # Thermal conductance [W/K]
R = l / (A * sigma)  # Electrical resistance [Ohms]
T_h = 373.15  # Hot side temperature [K]
T_c = 273.15  # Cold side temperature [K]

# Analytic functions for power and voltage
def power_ann(current):
    return alpha * current * (T_h - T_c) - R * current**2

def voltage_ann(current):
    return alpha * (T_h - T_c) - R * current

# Compute analytic solutions
P_ann = [power_ann(item) for item in I]
V_ann = [-voltage_ann(item) for item in I]  # Negate voltage as in the original script

# Voltage vs Current Plot
plt.figure(figsize=(8, 6), dpi=1000) # Tran-Kieu: Added dpi 6/29/2026
plt.rc('font', family='sans-serif', size=16)  # Increased font size to 16
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Current [A]")
plt.ylabel("Voltage [V]")

# Plot MOOSE and analytic voltage data
plt.plot(I, Volt, linestyle='-', marker='', label='MOOSE')
plt.plot(I, V_ann, linestyle='', marker='o', label='Analytic')

# Add legend and finalize plot
ax.legend(frameon=False, prop={'size': 16}, loc='upper left')  # Increased legend font size
plt.tight_layout()
plt.savefig('Voltage_constant_font.png')
plt.close()

# Power vs Current Plot
plt.figure(figsize=(8, 6), dpi=1000) # Tran-Kieu: Added dpi 6/29/2026
plt.rc('font', family='sans-serif', size=16)  # Increased font size to 16
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Current [A]")
plt.ylabel("Power [W]")

# Plot MOOSE and analytic power data
plt.plot(I, power, linestyle='-', marker='', label='MOOSE')
plt.plot(I, P_ann, linestyle='', marker='o', label='Analytic')

# Add legend and finalize plot
ax.legend(frameon=False, prop={'size': 16}, loc='upper left')  # Increased legend font size
plt.tight_layout()
plt.savefig('power_constant_font.png')
plt.close()
