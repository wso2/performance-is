#!/usr/bin/env bash
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
    echo "$0 -i <IS_NODE_1_IP> -w <IS_NODE_2_IP>"
    echo ""
    echo "-i: The IP of wso2is node 1."
    echo "-w: The IP of wso2is node 2."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "i:w:h" opts; do
    case $opts in
    i)
        wso2_is_1_ip=("${OPTARG}")
        ;;
    w)
        wso2_is_2_ip=("${OPTARG}")
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

echo $wso2_is_1_ip
echo $wso2_is_2_ip

echo ""
echo "Coping files..."
echo "============================================"
sudo cp resources/server.* /etc/nginx/ssl/is/
sudo cp resources/is.conf /etc/nginx/conf.d/

echo ""
echo "Adding IS IPs to conf file..."
echo "============================================"
sudo sed -i 's$server xxx.xxx.xxx.1:9443$server '$wso2_is_1_ip':9443$g' /etc/nginx/conf.d/is.conf || echo "error 1"
sudo sed -i 's$server xxx.xxx.xxx.2:9443$server '$wso2_is_2_ip':9443$g' /etc/nginx/conf.d/is.conf || echo "error 1"

echo ""
echo "Adding workerconnection to nginx.conf file"
echo "============================================"
sudo sed -i 's/worker_connections 768/worker_connections 1500/g' /etc/nginx/nginx.conf || echo "error 1"

sudo service nginx restart
