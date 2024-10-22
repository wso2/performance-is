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
# Setup the bastion node to be used as the JMeter client.
# ----------------------------------------------------------------------------

no_of_nodes=""
wso2_is_1_ip=""
wso2_is_2_ip=""
wso2_is_3_ip=""
wso2_is_4_ip=""
lb_host=""
rds_host=""
session_rds_host=""
wso2is_host_alias=wso2is
wso2is_1_host_alias=wso2is1
wso2is_2_host_alias=wso2is2
wso2is_3_host_alias=wso2is3
wso2is_4_host_alias=wso2is4
lb_alias=loadbalancer

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -w <wso2_is_1_ip> -i <wso2_is_2_ip> -l <lb_host> -r <rds_host> -s <session_rds_host>"
    echo ""
    echo "-w: The private IP of WSO2 IS node 1."
    echo "-i: The private IP of WSO2 IS node 2."
    echo "-j: The private IP of WSO2 IS node 3."
    echo "-k: The private IP of WSO2 IS node 4."
    echo "-l: The private hostname of Load balancer instance."
    echo "-r: The private hostname of RDS instance."
    echo "-s: The private hostname of the session Database RDS instance."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "n:w:i:j:k:l:r:s:h" opts; do
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
    l)
        lb_host=${OPTARG}
        ;;
    r)
        rds_host=${OPTARG}
        ;;
    s)
        session_rds_host=${OPTARG}
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

if [[ -z $lb_host ]]; then
    echo "Please provide the private hostname of Load balancer instance."
    exit 1
fi

if [[ -z $rds_host ]]; then
    echo "Please provide the private hostname of the RDS instance."
    exit 1
fi

if [[ -z $session_rds_host ]]; then
    echo "Please provide the private hostname of the session Database RDS instance."
    exit 1
fi

function get_ssh_hostname() {
    sudo -u ubuntu ssh -G "$1" | awk '/^hostname / { print $2 }'
}

echo ""
echo "Setting up required files..."
echo "============================================"
cd /home/ubuntu || exit 0
mkdir workspace
cd workspace || exit 0

echo ""
echo "Extracting is performance distribution..."
echo "============================================"
tar -C /home/ubuntu/workspace -xzf /home/ubuntu/is-performance-*.tar.gz

echo ""
echo "Running JMeter setup script..."
echo "============================================"
cd /home/ubuntu || exit 0

if [[ -z $no_of_nodes ]]; then
    echo "Please provide the number of IS nodes in the deployment."
    exit 1
elif [[ $no_of_nodes -eq 1 ]]; then
    workspace/setup/setup-jmeter-client-is.sh -g -k /home/ubuntu/private_key.pem \
                -i /home/ubuntu \
                -c /home/ubuntu \
                -f /home/ubuntu/apache-jmeter-*.tgz \
                -a $wso2is_host_alias -n "$wso2_is_1_ip" \
                -a loadbalancer -n "$wso2_is_1_ip"\
                -a rds -n "$rds_host"\
                -a sessionrds -n "$session_rds_host"
elif [[ $no_of_nodes -eq 2 ]]; then
    workspace/setup/setup-jmeter-client-is.sh -g -k /home/ubuntu/private_key.pem \
                -i /home/ubuntu \
                -c /home/ubuntu \
                -f /home/ubuntu/apache-jmeter-*.tgz \
                -a $wso2is_1_host_alias -n "$wso2_is_1_ip" \
                -a $wso2is_2_host_alias -n "$wso2_is_2_ip" \
                -a $lb_alias -n "$lb_host"\
                -a rds -n "$rds_host"\
                -a sessionrds -n "$session_rds_host"
elif [[ $no_of_nodes -eq 3 ]]; then
    workspace/setup/setup-jmeter-client-is.sh -g -k /home/ubuntu/private_key.pem \
                -i /home/ubuntu \
                -c /home/ubuntu \
                -f /home/ubuntu/apache-jmeter-*.tgz \
                -a $wso2is_1_host_alias -n "$wso2_is_1_ip" \
                -a $wso2is_2_host_alias -n "$wso2_is_2_ip" \
                -a $wso2is_3_host_alias -n "$wso2_is_3_ip" \
                -a $lb_alias -n "$lb_host"\
                -a rds -n "$rds_host"\
                -a sessionrds -n "$session_rds_host"
elif [[ $no_of_nodes -eq 4 ]]; then
    workspace/setup/setup-jmeter-client-is.sh -g -k /home/ubuntu/private_key.pem \
                -i /home/ubuntu \
                -c /home/ubuntu \
                -f /home/ubuntu/apache-jmeter-*.tgz \
                -a $wso2is_1_host_alias -n "$wso2_is_1_ip" \
                -a $wso2is_2_host_alias -n "$wso2_is_2_ip" \
                -a $wso2is_3_host_alias -n "$wso2_is_3_ip" \
                -a $wso2is_4_host_alias -n "$wso2_is_4_ip" \
                -a $lb_alias -n "$lb_host"\
                -a rds -n "$rds_host"\
                -a sessionrds -n "$session_rds_host"
else
    echo "Invalid value for no_of_nodes. Please provide a valid number."
    exit 1
fi

sudo chown -R ubuntu:ubuntu workspace
sudo chown -R ubuntu:ubuntu apache-jmeter-*
sudo chown -R ubuntu:ubuntu /tmp/jmeter.log
sudo chown -R ubuntu:ubuntu jmeter.log

echo ""
echo "Coping files to NGinx instance..."
echo "============================================"
sudo -u ubuntu scp -r /home/ubuntu/workspace/setup/resources/ $lb_alias:/home/ubuntu/
sudo -u ubuntu scp /home/ubuntu/workspace/setup/setup-nginx.sh $lb_alias:/home/ubuntu/

echo ""
echo "Setting up NGinx..."
echo "============================================"

if [[ $no_of_nodes -eq 1 ]]; then
    echo ""
    echo "Setting up IS instance..."
    echo "============================================"
    sudo -u ubuntu ssh $wso2is_host_alias mkdir sar setup
    sudo -u ubuntu scp workspace/setup/setup-common.sh $wso2is_host_alias:/home/ubuntu/setup/
    sudo -u ubuntu scp workspace/sar/install-sar.sh $wso2is_host_alias:/home/ubuntu/sar/
    sudo -u ubuntu scp workspace/is/restart-is.sh $wso2is_host_alias:/home/ubuntu/
    sudo -u ubuntu ssh $wso2is_host_alias sudo ./setup/setup-common.sh -p zip -p jq -p bc
elif [[ $no_of_nodes -eq 2 ]]; then
    sudo -u ubuntu ssh $lb_alias ./setup-nginx.sh -n "$no_of_nodes" -i "$wso2_is_1_ip" -w "$wso2_is_2_ip"
elif [[ $no_of_nodes -eq 3 ]]; then
    sudo -u ubuntu ssh $lb_alias ./setup-nginx.sh -n "$no_of_nodes" -i "$wso2_is_1_ip" -w "$wso2_is_2_ip" -j "$wso2_is_3_ip"
elif [[ $no_of_nodes -eq 4 ]]; then
    sudo -u ubuntu ssh $lb_alias ./setup-nginx.sh -n "$no_of_nodes" -i "$wso2_is_1_ip" -w "$wso2_is_2_ip" -j "$wso2_is_3_ip" -k "$wso2_is_4_ip"
fi

