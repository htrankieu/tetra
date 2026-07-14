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

# Current range
I = np.linspace(0, 2.5, 26)

# Case definitions
cases = [
    {'case_folder': 'mesh_study_coarse/pattern_', 'legend': '0.4 mm', 'color': 'indianred'},
    {'case_folder': 'pattern_', 'legend': '0.2 mm', 'color': 'cornflowerblue'},
    {'case_folder': 'mesh_study_fine/pattern_', 'legend': '0.1 mm', 'color': 'green'}
]

# Power vs Current Plot
plt.figure(figsize=(8, 6))
plt.rc('font', family='sans-serif', size=16)  # Increased font size to 16
ax = plt.subplot(1, 1, 1)
ax.get_yaxis().get_major_formatter().set_useOffset(False)
plt.xlabel("Current [A]")
plt.ylabel("Power [W]")

# Process data for each mesh case
for mesh in cases:
    Volt = []
    power = []
    for (i, current) in enumerate(I):
        i_c = int(current * 10)
        base = mesh['case_folder'] + str(i_c).zfill(2)
        result_name = base + ".csv"
        
        # Read data from CSV
        data = read_csv_file(result_name)
        Volt.append(data['U_load'][-1])  # Load voltage
        power.append(data['P_load'][-1])  # Load power

    # Plot power data for each case
    plt.plot(I, power, marker='o', color=mesh['color'], label=mesh['legend'])

# Add legend and finalize plot
ax.legend(frameon=False, prop={'size': 16})  # Increased legend font size
plt.tight_layout()
plt.savefig('TEM_power_mesh_font.png', dpi=300)

# Set axis limits and save zoomed plot
ax.set_xlim([0.8, 1.5])
ax.set_ylim([2.6, 2.9])
plt.tight_layout()
plt.savefig('TEM_power_mesh_zoom_font.png', dpi=300)
plt.close()
