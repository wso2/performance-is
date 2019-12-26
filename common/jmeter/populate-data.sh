#!/bin/bash -e
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
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

host=""
port=""

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -i <host> -p <post> [-h]"
    echo ""
    echo "-i: Host where the data population scripts should be run against."
    echo "-p: Port where the data population scripts should be run against."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "i:p:h" opts; do
    case $opts in
    i)
        host=${OPTARG}
        ;;
    p)
        port=${OPTARG}
        ;;
    h)
        usage
        exit 0
        ;;
    \?)
        usage
        exit 1
        ;;
    esac
done

if [[ -z $host ]]; then
    echo "Please provide the host."
    exit 1
fi

if [[ -z $port ]]; then
    echo "Please provide the port."
    exit 1
fi

echo ""
echo "Running test data populating scripts..."
declare -a scripts=("TestData_SCIM2_Add_User.jmx" "TestData_Add_OAuth_Apps.jmx" "TestData_Add_SAML_Apps.jmx")
#    declare -a scripts=("TestData_Add_Super_Tenant_Users.jmx" "TestData_Add_OAuth_Apps.jmx" "TestData_Add_SAML_Apps.jmx" "TestData_Add_Tenants.jmx" "TestData_Add_Tenant_Users.jmx")
setup_dir="/home/ubuntu/workspace/jmeter/setup"

for script in "${scripts[@]}"; do
    script_file="$setup_dir/$script"
    command="jmeter -Jhost=$host -Jport=$port -n -t $script_file"
    echo "$command"
    echo ""
    $command
    echo ""
done

echo ""
echo "Test data population completed."
echo "============================================"
