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

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -i <IS_NODE_IP> -r <RDS_IP> -w <OTHER_IS_NODE_IP> "
    echo ""
    echo "-i: The IP of wso2is node 1."
    echo "-j: The IP of wso2is node 3."
    echo "-k: The IP of wso2is node 4."
    echo "-r: The IP address of RDS."
    echo "-w: The IP of wso2is node 2."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "n:w:i:j:k:r:h" opts; do
    case $opts in
    n)
        no_of_nodes=${OPTARG}
        ;;
    w)
        wso2_is_1_ip=${OPTARG}
        ;;
    i)
        wso2_is_2_ip=${OPTARG}
        ;;
    j)
        wso2_is_3_ip=${OPTARG}
        ;;
    k)
        wso2_is_4_ip=${OPTARG}
        ;;
    r)
        db_instance_ip=${OPTARG}
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
echo "unzipping is server"
echo "-------------------------------------------"
unzip -q wso2is.zip

echo ""
echo "changing server name"
echo "-------------------------------------------"
mv wso2is-* wso2is

sudo chown -R ubuntu:ubuntu wso2is

echo ""
echo "changing permission for mysql connector"
echo "-------------------------------------------"
chmod 644 mysql-connector-java-*.jar

carbon_home=$(realpath ~/wso2is)

echo ""
echo "Adding mysql connector to the pack..."
echo "-------------------------------------------"
cp mysql-connector-java-*.jar "$carbon_home"/repository/components/lib/

echo ""
echo "Adding deployment toml file to the pack..."
echo "-------------------------------------------"
cp resources/deployment.toml "$carbon_home"/repository/conf/deployment.toml

echo ""
echo "Applying basic parameter changes..."
echo "-------------------------------------------"
sed -i 's/JVM_MEM_OPTS="-Xms256m -Xmx1024m"/JVM_MEM_OPTS="-Xms4g -Xmx4g"/g' \
  "$carbon_home"/bin/wso2server.sh || echo "Editing wso2server.sh file failed!"
sed -i "s|jdbc:mysql://wso2isdbinstance2.cd3cwezibdu8.us-east-1.rds.amazonaws.com|jdbc:mysql://$db_instance_ip|g" \
  "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"

if [[ -z $no_of_nodes ]]; then
    echo "Please provide the number of IS nodes in the deployment."
    exit 1
fi

if [[ $no_of_nodes -eq 1 ]]; then
    echo ""
    echo "Creating databases in RDS..."
    echo "============================================"
    mysql -h "$db_instance_ip" -u wso2carbon -pwso2carbon < resources/createDB.sql
fi
if [[ $no_of_nodes -gt 1 ]]; then
    sed -i "s|member_ip_1|$wso2_is_1_ip|g" "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"
    sed -i "s|member_ip_2|$wso2_is_2_ip|g" "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"
fi
if [[ $no_of_nodes -gt 2 ]]; then
    sed -i "s|member_ip_3|$wso2_is_3_ip|g" "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"
fi
if [[ $no_of_nodes -gt 3 ]]; then
    sed -i "s|member_ip_4|$wso2_is_4_ip|g" "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"
fi

echo ""
echo "Starting WSO2 IS server..."
echo "-------------------------------------------"
./wso2is/bin/wso2server.sh start
sleep 100s
