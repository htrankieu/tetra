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
cases.append({'legend': '0W, constant', 'repo': 'results', 'suffix': '', 'comsol_file': 'T_cold.csv'})

I = []
Volt = []
power = []

# Process data for MOOSE
for item in Intensities:
    filename = cases[0]['repo'] + "/I" + str(item).zfill(2) + cases[0]['suffix'] + ".csv"
    print(f"Reading file: {filename}")
    data = read_csv_file(filename)
    I.append(item / 100.0)  # Current in Amps
    Volt.append(data['Vtop'][-1])  # Voltage
    power.append(data['P_load'][-1] * -1)  # Power (negated)

# Voltage vs Current Plot
plt.figure(figsize=(8, 6), dpi = 1000)
plt.rc('font', family='sans-serif', size=16)  # Increased font size to 16
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Current [A]")
plt.ylabel("Voltage [V]")

# Read COMSOL data for voltage
data_comsol_V = read_csv_file('V_comsol.csv')

# Plot MOOSE and COMSOL voltage data
plt.plot(I, Volt, linestyle='-', marker='', label='MOOSE')
plt.plot(data_comsol_V["I"], data_comsol_V["V"], linestyle='', marker='o', label='COMSOL')

# Add legend and finalize plot
ax.legend(frameon=False, prop={'size': 16}, loc='upper left')  # Increased legend font size
plt.tight_layout()
plt.savefig('Voltage_font.png')
plt.close()

# Power vs Current Plot
plt.figure(figsize=(8, 6), dpi=1000)
plt.rc('font', family='sans-serif', size=16)  # Increased font size to 16
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Current [A]")
plt.ylabel("Power [W]")

# Read COMSOL data for power
data_comsol_p = read_csv_file('power_comsol.csv')

# Plot MOOSE and COMSOL power data
plt.plot(I, power, linestyle='-', marker='', label='MOOSE')
plt.plot(data_comsol_p["I"], data_comsol_p["power"], linestyle='', marker='o', label='COMSOL')

# Add legend and finalize plot
ax.legend(frameon=False, prop={'size': 16}, loc='lower left')  # Increased legend font size
plt.tight_layout()
plt.savefig('power_font.png')
plt.close()
