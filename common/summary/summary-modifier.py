#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Copyright (c) 2020, WSO2 Inc. (http://wso2.org) All Rights Reserved.
#
# WSO2 Inc. licenses this file to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.
#
# -------------------------------------------------------------------------------------------
# Modify the summary csv file to extract only important data to be displayed in the md file.
# -------------------------------------------------------------------------------------------

import csv
import os

rows = []  # To store each row of the summary.csv file
scenarioCount = []  # To keep scenario count orderly
burst_keyword = "Burst"  # Keyword to identify burst scenarios

# Define the dictionary {Scenario_Name: Critical_Request_Name}
scenarios = {"Auth Code Grant Redirect With Consent": "Common Auth Login HTTP Request",
             "Password Grant Type": "GetToken_Password_Grant",
             "Client Credentials Grant Type": "Get Token Client Credential Grant",
             "OIDC Auth Code Grant Redirect With Consent": "Common Auth Login HTTP Request",
             "OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes": "Get tokens",
             "OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes and Groups": "Get tokens",
             "OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes Groups and Roles": "Get tokens",
             "OIDC Auth Code Grant Redirect Without Consent": "Common Auth Login HTTP Request",
             "OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes": "Get tokens",
             "OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes and Groups": "Get tokens",
             "OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes Groups and Roles": "Get tokens",
             "OIDC Password Grant Type": "GetToken_Password_Grant",
             "OIDC Password Grant Type Retrieve User Attributes": "GetToken_Password_Grant",
             "OIDC Password Grant Type Retrieve User Attributes and Groups": "GetToken_Password_Grant",
             "OIDC Password Grant Type Retrieve User Attributes Groups and Roles": "GetToken_Password_Grant",
             "SAML2 SSO Redirect Binding": "Identity Provider Login",
             "Token Exchange Grant": "GetToken_Token_Exchange_Grant"}

scenarios_critical_requests = scenarios.copy()

# Replace all values in the copied dictionary with an empty list
for key in scenarios_critical_requests:
    scenarios_critical_requests[key] = []

# Read generated result file and append each row to an array
with open('summary.csv') as file:
    reader = csv.reader(file)
    for row in reader:
        rows.append(row)

scenario = rows[1][0]  # Assign first scenario
count = 0  # Number of times each scenario appears
for row in rows[1:]:
    if scenario == row[0]:
        if scenarios.get(scenario) == row[3] or (burst_keyword + " " + scenarios.get(scenario)) == row[3]:
            scenarios_critical_requests[scenario].append(row[14])
        count += 1  # Increase the count when the same scenario appears
    else:
        scenarioCount.append(count)  # Append the count to the array when a new scenario name appears
        scenario = row[0]
        if scenarios.get(scenario) == row[3] or (burst_keyword + " " + scenarios.get(scenario)) == row[3]:
            scenarios_critical_requests[scenario].append(row[14])
        count = 1
scenarioCount.append(count)  # Append the count of the last scenario

concurrentUserCounts = 0  # Get number of different concurrent user counts
userCount = ""  # Assign reading value from the file
# Loop just for the first scenario to get the number of different concurrent user count
for i in range(scenarioCount[0]):
    if userCount != rows[1 + i][2]:
        concurrentUserCounts += 1  # Increase the count when a new number appears
        userCount = rows[1 + i][2]  # Assign the newly met count

# Write Scenario name, Concurrent Users, Throughput (Requests/sec), Average Response Time (ms) into a new file
with open('updated_summary.csv', 'w') as file:
    writer = csv.writer(file)
    writer.writerow([rows[0][0], rows[0][2], rows[0][14]])  # Write column names

    rowNumber = 1  # Row number of the original data file

    for count in scenarioCount:
        if burst_keyword in rows[rowNumber][3]:
            concurrentUserCounts = concurrentUserCounts * 2  # If burst scenario, double the concurrent user count
        for i in range(concurrentUserCounts):
            stepsCount = int(count / concurrentUserCounts)  # Get the number of steps for each scenario
            # 0 - Scenario name, 2 - Concurrent users, 7 - Throughput (Requests/sec), 8 - Average Response Time (ms)
            # Throughput and response time are rounded to first two decimal places
            # Read column wise for getting average throughput and total of average response times using numpy nd arrays

            # If burst enabled scenario, add another line for burst scenario
            if burst_keyword in rows[rowNumber][3]:
                writer.writerow(
                    [rows[rowNumber][0] + " [" + burst_keyword + "]", rows[rowNumber][2],
                     scenarios_critical_requests[rows[rowNumber][0]][i]])
            else:
                writer.writerow(
                    [rows[rowNumber][0], rows[rowNumber][2],
                     scenarios_critical_requests[rows[rowNumber][0]][i]])

            rowNumber += stepsCount  # Increment the row number for the next write

# Rename file to keep existing implementation as it is
os.rename(r'summary.csv', r'summary-original.csv')  # Rename summary.csv to summary-original.csv
os.rename(r'updated_summary.csv', r'summary.csv')  # Rename updated_summary.csv to summary.csv
