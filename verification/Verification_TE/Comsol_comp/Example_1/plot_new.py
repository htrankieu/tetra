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
cases.append({'legend': '0 W, constant', 'repo': 'results', 'suffix': '', 'comsol_file': 'T_cold.csv', 'color': 'cornflowerblue'})
cases.append({'legend': '0 W, temperature dependent', 'repo': 'results', 'suffix': '_var_prop', 'comsol_file': 'T_cold_var_prop.csv', 'color': 'indianred'})
cases.append({'legend': '10 mW, constant', 'repo': 'results_10mW', 'suffix': '', 'comsol_file': 'T_cold_10mW.csv', 'color': 'green'})
cases.append({'legend': '10 mW, temperature dependent', 'repo': 'results_10mW', 'suffix': '_var_prop', 'comsol_file': 'T_cold_10mW_var_prop.csv', 'color': 'orange'})

# Plotting setup
plt.figure(figsize=(8, 6), dpi=1000) # Tran-Kieu: Added dpi 6/25/2026
plt.rc('font', family='sans-serif', size=16)
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Current [A]")
plt.ylabel("Cold side temperature [K]")  # Updated Y-axis label
leg_items = []

# Process each case
for case in cases:
    I = []
    T_cold = []
    
    # Read the MOOSE simulation data
    for item in Intensities:
        filename = case['repo'] + "/I" + str(item).zfill(2) + case['suffix'] + ".csv"
        print(f"Reading file: {filename}")
        data = read_csv_file(filename)
        I.append(item / 10.0)  # Current in Amps
        # T_cold.append(data['T_cold'][-1] + 273.15)  # Convert temperature to Kelvin (?C + 273.15)
        T_cold.append(data['T_cold'][-1])  # Convert temperature to Kelvin (?C + 273.15)

    # Read the COMSOL data
    data_comsol_T = read_csv_file(case['comsol_file'])
    comsol_I = data_comsol_T["I"]
    # comsol_T = [temp + 273.15 for temp in data_comsol_T["T"]]  # Convert COMSOL temperatures to Kelvin
    comsol_T = [temp for temp in data_comsol_T["T"]]  # Convert COMSOL temperatures to Kelvin

    # Plot MOOSE simulation data
    plt.plot(I, T_cold, linestyle='-', marker='', color=case['color'])
    # Plot COMSOL data
    plt.plot(comsol_I, comsol_T, linestyle='', marker='o', color=case['color'])

    # Update legend items
    leg_items.append(case['legend'] + ', MOOSE')
    leg_items.append(case['legend'] + ', COMSOL')

# Finalize plot
ax.legend(leg_items, frameon=False, prop={'size': 14}, loc='upper right')
ax.set_xlim([0, 1.2])
plt.tight_layout()
plt.savefig('T_cold_K.png')  # Updated file name to reflect Kelvin
plt.close()
