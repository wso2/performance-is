#!/bin/bash -e
# Copyright (c) 2019, wso2 Inc. (http://wso2.org) All Rights Reserved.
#
# wso2 Inc. licenses this file to you under the Apache License,
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
# Setup is scripts.
# ----------------------------------------------------------------------------

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -i <IS_NODE_IP> -r <RDS_IP> -w <OTHER_IS_NODE_IP> "
    echo ""
    echo "-i: The IP of wso2is node."
    echo "-r: The IP address of RDS."
    echo "-w: The IP of other wso2is node."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "w:i:r:h" opts; do
    case $opts in
    i)
        wso2_is_1_ip=("${OPTARG}")
        ;;
    w)
        wso2_is_2_ip=("${OPTARG}")
        ;;
    r)
        db_instance_ip=("${OPTARG}")
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

if [[ -z $wso2_is_1_ip ]]; then
    echo "Please provide the WSO2 IS node 1 ip address."
    exit 1
fi

if [[ -z $wso2_is_2_ip ]]; then
    echo "Please provide the WSO2 IS node 2 ip address."
    exit 1
fi

if [[ -z $db_instance_ip ]]; then
    echo "Please provide the db instance ip address."
    exit 1
fi

copy_is_server_edit_command="scp -i ~/private_key.pem -o "StrictHostKeyChecking=no" /home/ubuntu/workspace/setup/update-is-conf.sh ubuntu@$wso2_is_1_ip:/home/ubuntu/"
copy_is_server_resources_command="scp -r -i ~/private_key.pem -o "StrictHostKeyChecking=no" /home/ubuntu/workspace/setup/resources/ ubuntu@$wso2_is_1_ip:/home/ubuntu/"
copy_is_server_command="scp -i ~/private_key.pem -o "StrictHostKeyChecking=no" /home/ubuntu/wso2is.zip ubuntu@$wso2_is_1_ip:/home/ubuntu/wso2is.zip"
copy_mysql_connector_command="scp -i ~/private_key.pem -o "StrictHostKeyChecking=no" /home/ubuntu/mysql-connector-java-*.jar ubuntu@$wso2_is_1_ip:/home/ubuntu/"

echo ""
echo "Copying Is server setup files..."
echo $copy_is_server_edit_command
$copy_is_server_edit_command
echo $copy_is_server_resources_command
$copy_is_server_resources_command
echo $copy_is_server_command
$copy_is_server_command
echo $copy_mysql_connector_command
$copy_mysql_connector_command

setup_is_node_command="ssh -i ~/private_key.pem -o "StrictHostKeyChecking=no" -t ubuntu@$wso2_is_1_ip ./update-is-conf.sh -r $db_instance_ip -w $wso2_is_1_ip -i $wso2_is_2_ip"

echo ""
echo "Running IS node setup script: $setup_is_node_command"
# Handle any error and let the script continue.
$setup_is_node_command || echo "Remote ssh command to setup is node failed."
