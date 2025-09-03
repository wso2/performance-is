#!/bin/bash -e
# Copyright (c) 2019, WSO2 Inc. (http://wso2.org) All Rights Reserved.
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
#
# ----------------------------------------------------------------------------
# edit is server script.
# ----------------------------------------------------------------------------

function update_postgres_config() {

    sed -i "s|{db_hostname}|$db_instance_ip|g" "$carbon_home/repository/conf/deployment.yaml" || echo "Editing deployment.yaml file failed!"
}

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -i <IS_NODE_IP> -r <RDS_IP> -w <OTHER_IS_NODE_IP> "
    echo ""
    echo "-r: The IP address of RDS."
    echo "-h: Display this help and exit."
    echo "-m: Database type."
    echo "-c: Case insensitivity of the username and attributes."
    echo ""
}

while getopts "n:r:m:h" opts; do
    case $opts in
    n)
        no_of_nodes=${OPTARG}
        ;;
    r)
        db_instance_ip=${OPTARG}
        ;;
    m)
        db_type=${OPTARG}
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

if [[ -z $db_instance_ip ]]; then
    echo "Please provide the db instance ip address."
    exit 1
fi

echo ""
echo "unzipping thunder server"
echo "-------------------------------------------"
unzip -q thunder.zip

echo ""
echo "changing server name"
echo "-------------------------------------------"
mv thunder-* thunder

sudo chown -R ubuntu:ubuntu thunder

carbon_home=$(realpath ~/thunder)

echo ""
echo "Adding deployment yaml file to the pack..."
echo "-------------------------------------------"
cp resources/deployment.yaml "$carbon_home"/repository/conf/deployment.yaml

echo ""
echo "Applying basic parameter changes..."
echo "-------------------------------------------"
if [[ $db_type == "postgres" ]]; then
    update_postgres_config
else
    echo "Unsupported database type: $db_type"
    exit 1
fi

echo ""
echo "Starting Thunder server..."
echo "-------------------------------------------"

echo ""
echo "Adding thunder.wso2.com to /etc/hosts..."
echo "-------------------------------------------"
sudo bash -c "echo '0.0.0.0 thunder.wso2.com' >> /etc/hosts"

cd "$carbon_home"
bash start.sh &
cd "../"
sleep 60s

