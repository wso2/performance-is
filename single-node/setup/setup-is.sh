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
# Setup IS pack.
# ----------------------------------------------------------------------------

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -n <wso2_is_ip> -r <db_ip>"
    echo ""
    echo "-i: The IP of wso2is node."
    echo "-r: The IP address of RDS."
    echo "-h: Display this help and exit."
    echo "-t: Keystore type."
    echo ""
}

while getopts "a:n:p:r:t:s:h" opts; do
    case $opts in
    a)
        is_host_alias=${OPTARG}
        ;;
    n)
        no_of_nodes=${OPTARG}
        ;;
    p)
        wso2_is_ip=${OPTARG}
        ;;
    r)
        db_instance_ip=${OPTARG}
        ;;
    t)
        keystore_type=${OPTARG}
        ;;
    s)
        session_db_instance_ip=${OPTARG}
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

if [[ -z $wso2_is_ip ]]; then
    echo "Please provide the WSO2 IS node IP address."
    exit 1
fi

if [[ -z $db_instance_ip ]]; then
    echo "Please provide the db instance IP address."
    exit 1
fi

if [[ -z $session_db_instance_ip ]]; then
    echo "Please provide the session db instance IP address."
    exit 1
fi

if [[ -z $keystore_type ]]; then
    echo "Please provide the keystore type."
    exit 1
fi

echo ""
echo "Copying Is server setup files..."
echo "-------------------------------------------"

sudo -u ubuntu scp setup/update-is-conf.sh "$is_host_alias":/home/ubuntu/
sudo -u ubuntu scp -r setup/resources/ "$is_host_alias":/home/ubuntu/
sudo -u ubuntu scp wso2is.zip "$is_host_alias":/home/ubuntu/
sudo -u ubuntu scp mysql-connector-j-*.jar "$is_host_alias":/home/ubuntu/

sudo -u ubuntu ssh "$is_host_alias" mkdir sar setup
sudo -u ubuntu scp workspace/setup/setup-common.sh "$is_host_alias":/home/ubuntu/setup/
sudo -u ubuntu scp workspace/sar/install-sar.sh "$is_host_alias":/home/ubuntu/sar/
sudo -u ubuntu scp workspace/is/restart-is.sh "$is_host_alias":/home/ubuntu/
sudo -u ubuntu ssh "$is_host_alias" sudo ./setup/setup-common.sh -p zip -p jq -p bc

setup_is_node_command="ssh -i ~/private_key.pem -o "StrictHostKeyChecking=no" -t ubuntu@$wso2_is_ip \
    ./update-is-conf.sh -n $no_of_nodes -r $db_instance_ip -t $keystore_type -s $session_db_instance_ip"

echo ""
echo "Running IS node setup script: $setup_is_node_command"
# Handle any error and let the script continue.
$setup_is_node_command || echo "Remote ssh command to setup is node failed."
