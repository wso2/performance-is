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
# Create DBs and start IS container.
# ----------------------------------------------------------------------------

rds_host=""
is_image_link=""
cpus=""
memory=""

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -r <db_ip>"
    echo ""
    echo "-r: The ip address of RDS"
    echo "-i: IS docker image link"
    echo "-c: Number of CPU cores for the IS node"
    echo "-m: Memory for the IS node (GB)"
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "n:r:i:c:m:h" opts; do
    case $opts in
    r)
        rds_host=${OPTARG}
        ;;
    i)
        is_image_link=${OPTARG}
        ;;
    c)
        cpus=${OPTARG}
        ;;
    m)
        memory=${OPTARG}
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

if [[ -z $rds_host ]]; then
    echo "Please provide the db instance ip address."
    exit 1
fi

if [[ -z $is_image_link ]]; then
    echo "Please provide the link to the IS docker image."
    exit 1
fi

if [[ -z $cpus ]]; then
    echo "Please provide the number of CPU cores for the IS node."
    exit 1
fi

if [[ -z $memory ]]; then
    echo "Please provide the memory for the IS node."
    exit 1
fi

echo ""
echo "Installing docker..."
echo "============================================"
if ! command -v docker >/dev/null 2>&1; then
    echo "docker is not installed! Installing docker.."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    #set docker user as a non root user
    sudo usermod -aG docker $USER
else
    echo "docker is already installed."
fi

echo ""
echo "Creating databases in RDS..."
echo "============================================"
mysql -h $rds_host -u wso2carbon -pwso2carbon < createDB.sql

echo ""
echo "Downloading WSO2 IS Docker container..."
echo "============================================"
curl -o wso2is.tar $is_image_link

echo ""
echo "Loading docker image..."
echo "============================================"
docker load -i wso2is.tar
docker images

echo ""
echo "Starting WSO2 IS docker container..."
echo "============================================"
docker run --name=wso2is -d -p 9443:9443 -p 4000:4000 -p 9763:9763 --cpus=$cpus --memory=$memory wso2is:5.8.0
sleep 100s
