#!/bin/bash
# Copyright 2018 WSO2 Inc. (http://wso2.org)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------------
# Restart Identity Server
# ----------------------------------------------------------------------------

default_waiting_time=100
waiting_time=$default_waiting_time
cpus=""
memory=""

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -c <cpus> -m <memory> [-w <waiting_time>]"
    echo ""
    echo "-c: Number of CPU cores for the IS node"
    echo "-m: Memory for the IS node (GB)"
    echo "-w: The waiting time in seconds until the server restart.."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "c:m:w:h" opts; do
    case $opts in
    c)
        cpus=${OPTARG}
        ;;
    m)
        memory=${OPTARG}
        ;;
    w)
        waiting_time=${OPTARG}
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

if [[ -z $cpus ]]; then
    echo "Please provide the number of CPU cores for the IS node."
    exit 1
fi

if [[ -z $memory ]]; then
    echo "Please provide the memory for the IS node."
    exit 1
fi

if [[ -z $waiting_time ]]; then
    echo "Please provide the waiting time."
    exit 1
fi

echo ""
echo "Killing IS docker container..."
sudo docker stop wso2is
sudo docker rm wso2is

echo ""
echo "Restarting IS docker container..."
cmd="docker run --name=wso2is -d -p 9443:9443 -p 4000:4000 -p 9763:9763 --cpus=$cpus --memory=$memory wso2is:5.8.0"
echo $cmd
sudo $cmd

echo ""
echo "Waiting $waiting_time seconds..."
sleep $waiting_time

echo ""
echo "Finished starting identity server..."
echo "======================================================"
