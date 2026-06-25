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
Intensities = range(0, 21)

# Case definitions
cases = []
cases.append({'legend': '0 W, constant', 'simfile': 'pleg_cuboid_csv_line_FINAL.csv', 'comsol_file': '_x.csv', 'color': 'cornflowerblue'})
cases.append({'legend': '0 W, temperature dependent', 'simfile': 'pleg_cuboid_var_prop_csv_line_FINAL.csv', 'comsol_file': '_x_var_prop.csv', 'color': 'indianred'})
cases.append({'legend': '10 mW, constant', 'simfile': 'pleg_cuboid_10mW_csv_line_FINAL.csv', 'comsol_file': '_x_10mW.csv', 'color': 'green'})
cases.append({'legend': '10 mW, temperature dependent', 'simfile': 'pleg_cuboid_10mW_var_prop_csv_line_FINAL.csv', 'comsol_file': '_x_10mW_var_prop.csv', 'color': 'orange'})

# Plot: Temperature vs Position
plt.figure(figsize=(8, 6), dpi=1000) # Tran-Kieu: Added dpi 6/25/2026
plt.rc('font', family='sans-serif', size=16)
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Position [m]")
plt.ylabel("Temperature [K]")  # Updated Y-axis label for Kelvin
leg_items = []

for case in cases:
    # Read MOOSE simulation data
    data = read_csv_file(case['simfile'])
    # Convert temperature to Kelvin
    sim_x = np.array(data['x']) - 0.0001  # Adjust x-position as in the original script
    # sim_T = np.array(data['T']) + 273.15  # Convert temperature to Kelvin
    sim_T = np.array(data['T'])  # Convert temperature to Kelvin

    # Read COMSOL data
    data_comsol_T = read_csv_file('T' + case['comsol_file'])
    comsol_x = np.array(data_comsol_T["x"]) * 1000  # Convert COMSOL x to mm as in the original script
    # comsol_T = np.array(data_comsol_T["T"]) + 273.15  # Convert temperature to Kelvin
    comsol_T = np.array(data_comsol_T["T"])  # Convert temperature to Kelvin

    # Plot MOOSE simulation data
    plt.plot(sim_x, sim_T, linestyle='-', marker='', color=case['color'])
    # Plot COMSOL data
    plt.plot(comsol_x, comsol_T, linestyle='', marker='o', color=case['color'])

    # Update legend items
    leg_items.append(case['legend'] + ', MOOSE')
    leg_items.append(case['legend'] + ', COMSOL')

ax.legend(leg_items, frameon=False, prop={'size': 14}, loc='lower left')
ax.set_xlim([0, 0.006]) # Added by Tran-Kieu 6/25/2026
plt.tight_layout()
plt.savefig('T_x_K.png')  # Updated filename to include "_K"
plt.close()

# Plot: Voltage vs Position
plt.figure(figsize=(8, 6), dpi=1000) # Tran-Kieu: Added dpi 6/25/2026
plt.rc('font', family='sans-serif', size=16)
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Position [m]")
plt.ylabel("Voltage [V]")  # Voltage plot remains unchanged except for the output filename
leg_items = []

for case in cases:
    # Read MOOSE simulation data
    data = read_csv_file(case['simfile'])
    sim_x = np.array(data['x']) - 0.0001  # Adjust x-position as in the original script
    sim_elec = np.array(data['elec'])  # Voltage values remain unchanged

    # Read COMSOL data
    data_comsol_T = read_csv_file('V' + case['comsol_file'])
    comsol_x = np.array(data_comsol_T["x"])  # x-position for COMSOL data
    comsol_V = np.array(data_comsol_T["V"])  # Voltage values remain unchanged

    # Plot MOOSE simulation data
    plt.plot(sim_x, sim_elec, linestyle='-', marker='', color=case['color'])
    # Plot COMSOL data
    plt.plot(comsol_x, comsol_V, linestyle='', marker='o', color=case['color'])

    # Update legend items
    leg_items.append(case['legend'] + ', MOOSE')
    leg_items.append(case['legend'] + ', COMSOL')

ax.legend(leg_items, frameon=False, prop={'size': 14}, loc='upper left')
ax.set_xlim([0, 0.006]) # Added by Tran-Kieu 6/25/2026
ax.set_ylim([0, 0.11])  # Set the Y-axis range for voltage
plt.tight_layout()
plt.savefig('V_x_K.png')  # Updated filename to include "_K"
plt.close()
