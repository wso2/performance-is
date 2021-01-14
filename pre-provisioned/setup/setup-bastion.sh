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

lb_host=""
rds_host=""
lb_alias=loadbalancer

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -l <lb_host> -r <rds_host>"
    echo ""
    echo "-l: The hostname of Load balancer instance."
    echo "-r: The hostname of RDS instance."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "l:r:h" opts; do
    case $opts in
    l)
        lb_host=${OPTARG}
        ;;
    r)
        rds_host=${OPTARG}
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
echo "Extracting cloud performance distribution..."
echo "============================================"
tar -C /home/ubuntu/workspace -xzf /home/ubuntu/is-performance-cloud-*.tar.gz

echo ""
echo "Running JMeter setup script..."
echo "============================================"
cd /home/ubuntu || exit 0
workspace/setup/setup-jmeter-client-is.sh -g -k /home/ubuntu/private_key.pem \
            -i /home/ubuntu \
            -c /home/ubuntu \
            -f /home/ubuntu/apache-jmeter-*.tgz \
            -a $lb_alias -n "$lb_host"\
            -a rds -n "$rds_host"
sudo chown -R ubuntu:ubuntu workspace
sudo chown -R ubuntu:ubuntu apache-jmeter-*
sudo chown -R ubuntu:ubuntu /tmp/jmeter.log
sudo chown -R ubuntu:ubuntu jmeter.log

