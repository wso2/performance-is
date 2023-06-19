# Performance Analysis

This script generates performance plots based on CSV data files for different deployment types and scenarios. It reads the CSV files, filters the data based on concurrency ranges, and plots the 95th percentile of response time against concurrent users. The generated plots are saved in an 'output' folder.

## Prerequisites

- Python 3.x
- Required Python packages: pandas, matplotlib

## Getting Started

1. Clone the repository or download the `performance_analysis` folder.

2. Place your CSV data files in the same directory as the `performance_plots.py` script.
   1. Name the CSV files as follows
   2. Define the deployment types and their respective CSV files. If a CSV file is not present, it'll ignore it and continue with the rest of the CSVs.
    ```shell
    deployment_types = {
    'Single Node 4 Core': 'single_node_4_core.csv',
    'Two Node 2 Core': 'two_node_2_core.csv',
    'Two Node 4 Core': 'two_node_4_core.csv',
    'Three Node 4 Core': 'three_node_4_core.csv',
    'Four Node 4 Core': 'four_node_4_core.csv',
    }
   ```

3. Open a terminal or command prompt and navigate to the `performance_analysis` folder.

4. Install the required Python packages by running the following command:

   ```shell
   pip install pandas matplotlib
   ```

5. Run the script by executing the following command:

   ```shell
   python performance_plots.py
   ```

6. The script will process the CSV data files and generate performance plots for each scenario. The plots will be saved in an 'output' folder within the performance_analysis directory.

## Customization

If you want to modify the deployment types or concurrency ranges, you can update the `deployment_types` and `concurrency_ranges` dictionaries in the `performance_plots.py` script.

To change the upper and lower limit values for the response time, you can update the `upper_limit` and `lower_limit` variables in the script.

## Example CSV Data Format

The script expects the CSV data files to have the following format:

   ```csv
   Scenario Name,Concurrent Users,95th Percentile of Response Time (ms)
   Scenario 1,50,120
   Scenario 1,100,150
   ```

Each row represents a measurement of response time for a specific scenario and number of concurrent users.

## Directory Structure
After downloading or cloning the performance_analysis folder, the directory structure will look like this:

   ```css
   performance_analysis
    ├── performance_plots.py
    ├── single_node_4_core.csv
    ├── two_node_2_core.csv
    ├── two_node_4_core.csv
    ├── three_node_4_core.csv
    ├── four_node_4_core.csv
    └── output
          └── [scenario_folders_with_plots]
   ```




