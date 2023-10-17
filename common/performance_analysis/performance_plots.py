#!/usr/bin/env python
# -*- coding: utf-8 -*-
#  Copyright 2023 WSO2, LLC. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
# This script generates performance plots based on CSV data files for different deployment types and scenarios.
# It reads the CSV files, filters the data based on concurrency ranges, and plots the 95th percentile of response time against concurrent users.
# The generated plots are saved in an 'output' folder.
# ----------------------------------------------------------------------------

import pandas as pd
import matplotlib.pyplot as plt
import os
from collections import defaultdict
import textwrap

# Define the deployment types and their respective CSV files and colors
deployment_types = {
    'Single Node 4 Core': {
        'csv_file': 'single_node_4_core.csv',
        'color': 'royalblue'
    },
    'Two Node 2 Core': {
        'csv_file': 'two_node_2_core.csv',
        'color': 'darkcyan'
    },
    'Two Node 4 Core': {
        'csv_file': 'two_node_4_core.csv',
        'color': 'orange'
    },
    'Three Node 4 Core': {
        'csv_file': 'three_node_4_core.csv',
        'color': 'rosybrown'
    },
    'Four Node 4 Core': {
        'csv_file': 'four_node_4_core.csv',
        'color': 'purple'
    }
}

# Define the concurrency ranges and values
concurrency_ranges = {
    '50-500': [50, 100, 150, 300, 500],
    '500-3000': [500, 1000, 1500, 2000, 2500, 3000],
    '50-3000': [50, 100, 150, 300, 500, 1000, 1500, 2000, 2500, 3000]
}

# Define the upper and lower limit values and colors
limits = {
    'upper': {
        'value': 2000,
        'color': 'red',
        'label': 'Upper Limit: 2000 ms'
    },
    'lower': {
        'value': 500,
        'color': 'green',
        'label': 'Lower Limit: 500 ms'
    }
}


# Get unique scenario names from the deployment type CSV files
def get_unique_scenarios():
    scenarios = set()
    for deployment_type in deployment_types.values():
        csv_file = deployment_type['csv_file']
        if os.path.isfile(csv_file):
            data = pd.read_csv(csv_file)
            scenarios.update(data['Scenario Name'].unique())
    return scenarios


# Create a folder to store the images
def create_output_folder():
    output_folder = 'output'
    os.makedirs(output_folder, exist_ok=True)
    return output_folder


# Create a subfolder for the scenario
def create_scenario_folder(output_folder, scenario):
    scenario_folder = os.path.join(output_folder, scenario.replace(' ', '_'))
    os.makedirs(scenario_folder, exist_ok=True)
    return scenario_folder


# Get the scenario data for each deployment type
def get_scenario_data(scenario, deployment_types):
    lines_data = defaultdict(lambda: ([], []))
    for deployment_type, details in deployment_types.items():
        csv_file = details['csv_file']
        if os.path.isfile(csv_file):
            deployment_data = pd.read_csv(csv_file)
            scenario_data = deployment_data[deployment_data['Scenario Name'] == scenario]
            if not scenario_data.empty:
                concurrent_users = scenario_data['Concurrent Users']
                response_times = scenario_data['95th Percentile of Response Time (ms)']
                lines_data[deployment_type] = (concurrent_users, response_times)
    return lines_data


# Plot and save the graph
def plot_and_save_graph(concurrency_range, scenario_folder, lines_data, scenario):
    plt.figure()
    for deployment_type, data in lines_data.items():
        if not any(concurrency_range[0] <= concurrency <= concurrency_range[-1] for concurrency in data[0]):
            continue

        filtered_concurrency = [concurrency for concurrency, response_time in zip(data[0], data[1]) if concurrency_range[0] <= concurrency <= concurrency_range[-1]]
        filtered_response_times = [response_time for concurrency, response_time in zip(data[0], data[1]) if concurrency_range[0] <= concurrency <= concurrency_range[-1]]

        # Get the color for the deployment type
        color = deployment_types[deployment_type]['color']

        plt.plot(filtered_concurrency, filtered_response_times, label=deployment_type, color=color)

    # Wrap the title text if it's long
    wrapped_title = '\n'.join(textwrap.wrap(scenario, width=50))  # Adjust width as needed
    plt.title(wrapped_title)
    plt.xlabel('Concurrent Users')
    plt.ylabel('95th Percentile of Response Time (ms)')

    # Add legend with upper and lower bound labels
    legend_labels = list(lines_data.keys())
    plt.legend(legend_labels, loc='upper left')

    plt.grid(True)

    # Save the graph as an image in the scenario folder
    filepath = os.path.join(scenario_folder, f'{concurrency_range[0]}_{concurrency_range[-1]}_lines.png')
    plt.savefig(filepath)

    # Display the graph
    plt.show()


# Main execution
def main():
    scenarios = get_unique_scenarios()
    output_folder = create_output_folder()

    for scenario in scenarios:
        scenario_folder = create_scenario_folder(output_folder, scenario)
        lines_data = get_scenario_data(scenario, deployment_types)

        min_concurrency = float('inf')
        max_concurrency = float('-inf')
        for data in lines_data.values():
            min_concurrency = min(min_concurrency, min(data[0]))
            max_concurrency = max(max_concurrency, max(data[0]))

        if min_concurrency == 50 and max_concurrency == 3000:
            plot_and_save_graph(concurrency_ranges['50-3000'], scenario_folder, lines_data, scenario)
            plot_and_save_graph(concurrency_ranges['50-500'], scenario_folder, lines_data, scenario)

        if min_concurrency == 50 and max_concurrency == 500:
            plot_and_save_graph(concurrency_ranges['50-500'], scenario_folder, lines_data, scenario)

        if min_concurrency == 500 and max_concurrency == 3000:
            plot_and_save_graph(concurrency_ranges['500-3000'], scenario_folder, lines_data, scenario)


if __name__ == '__main__':
    main()
