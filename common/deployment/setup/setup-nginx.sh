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
    echo "$0 -i <IS_NODE_1_IP>"
    echo ""
    echo "-n: The number of nodes in the deployment."
    echo "-i: The IP of thunder node 1."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "n:i:h" opts; do
    case $opts in
    n)
        no_of_nodes=${OPTARG}
        ;;
    i)
        wso2_is_1_ip=("${OPTARG}")
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

echo ""
echo "Coping files..."
echo "============================================"
sudo cp resources/server.* /etc/nginx/ssl/is/
sudo cp resources/is.conf /etc/nginx/conf.d/

echo ""
echo "Adding IS IPs to conf file..."
echo "============================================"

if [[ -z $no_of_nodes ]]; then
    echo "Please provide the number of IS nodes in the deployment."
    exit 1
fi

sudo sed -i 's$server xxx.xxx.xxx.1:8090$server '$wso2_is_1_ip':8090$g' /etc/nginx/conf.d/is.conf || echo "error 1"

echo ""
echo "Increase Open FD Limit..."
echo "============================================"
sudo sh -c 'echo "fs.file-max = 65535" >> /etc/sysctl.conf'

echo ""
echo "Set soft and hard limit for ubuntu user..."
echo "============================================"
sudo sh -c 'echo "ubuntu       soft    nofile   4096" >> /etc/security/limits.conf'
sudo sh -c 'echo "ubuntu       hard    nofile   65535" >> /etc/security/limits.conf'

sudo sysctl -p

# Create or edit the nginx service override file
sudo mkdir -p /etc/systemd/system/nginx.service.d/
ls /etc/systemd/system/nginx.service.d/
echo "[Service]" | sudo tee /etc/systemd/system/nginx.service.d/override.conf
echo "LimitNOFILE=65535" | sudo tee -a /etc/systemd/system/nginx.service.d/override.conf

sudo systemctl daemon-reload

# nginx worker_rlimit_nofile Option
sudo sh -c 'echo "worker_rlimit_nofile 65535;" >> /etc/nginx/nginx.conf'

echo ""
echo "Adding workerconnection to nginx.conf file"
echo "============================================"
sudo sed -i 's/worker_connections 768/worker_connections 65535/g' /etc/nginx/nginx.conf || echo "error 1"

sudo service nginx restart
