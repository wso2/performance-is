#!/usr/bin/env bash
# Copyright (c) 2018, wso2 Inc. (http://wso2.org) All Rights Reserved.
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

wso2_is_1_ip=""
wso2_is_2_ip=""
lb_host=""
rds_host=""

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -w <wso2_is_1_ip> -i <wso2_is_2_ip> -l <lb_host> -r <rds_host>"
    echo ""
    echo "-w: The private IP of WSO2 IS node 1."
    echo "-i: The private IP of WSO2 IS node 2."
    echo "-l: The private hostname of Load balancer instance."
    echo "-r: The private hostname of RDS instance."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "w:i:l:r:h" opts; do
    case $opts in
    w)
        wso2_is_1_ip=${OPTARG}
        ;;
    i)
        wso2_is_2_ip=${OPTARG}
        ;;
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

if [[ -z $wso2_is_1_ip ]]; then
    echo "Please provide the private IP of WSO2 IS node 1."
    exit 1
fi

if [[ -z $wso2_is_2_ip ]]; then
    echo "Please provide the private IP of WSO2 IS node 1."
    exit 1
fi

if [[ -z $lb_host ]]; then
    echo "Please provide the private hostname of Load balancer instance."
    exit 1
fi

if [[ -z $rds_host ]]; then
    echo "Please provide the private hostname of the RDS instance."
    exit 1
fi

function get_ssh_hostname() {
    sudo -u ubuntu ssh -G $1 | awk '/^hostname / { print $2 }'
}

apt-get -y update
apt-get -y install git
apt-get install -y mysql-client
apt-get install -y realpath

# Only required when Ubuntu 14 is used.
echo ""
echo "Upgrading ssh to version 7.4"
echo "============================================"
apt install -y build-essential libssl-dev zlib1g-dev
wget "https://fastly.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.4p1.tar.gz"
tar xfz openssh-7.4p1.tar.gz
cd openssh-7.4p1
./configure
make
make install
service ssh restart

echo ""
echo "Installing maven 3.5"
echo "============================================"
wget http://www-us.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar -C /opt/ -xzf apache-maven-3.5.4-bin.tar.gz
export M2_HOME="/opt/apache-maven-3.5.4"
export PATH=$PATH:"/opt/apache-maven-3.5.4"
update-alternatives --install "/usr/bin/mvn" "mvn" "/opt/apache-maven-3.5.4/bin/mvn" 0
update-alternatives --set mvn /opt/apache-maven-3.5.4/bin/mvn
rm apache-maven-3.5.4-bin.tar.gz

echo ""
echo "Installing Java..."
echo "============================================"
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get install -y oracle-java8-installer

echo ""
echo "Setting up required files..."
echo "============================================"
cd /home/ubuntu
mkdir workspace
cd workspace
# todo change repo url
git clone https://github.com/vihanga-liyanage/performance-is
cd performance-is
# todo remove checkout command.
git checkout test-automation-4
mvn clean install

echo ""
echo "Extracting is performance distribution..."
echo "============================================"
tar -C ../ -xzf distribution/target/is-performance-distribution-*.tar.gz

echo ""
echo "Running JMeter setup script..."
echo "============================================"
cd /home/ubuntu
workspace/setup/setup-jmeter-client-is.sh -g -k /home/ubuntu/private_key.pem \
            -i /home/ubuntu \
            -c /home/ubuntu \
            -f /home/ubuntu/apache-jmeter-*.tgz \
            -a wso2is1 -n $wso2_is_1_ip \
            -a wso2is2 -n $wso2_is_2_ip \
            -a loadbalancer -n $lb_host \
            -a rds -n $rds_host
sudo chown -R ubuntu:ubuntu workspace
sudo chown -R ubuntu:ubuntu apache-jmeter-*
sudo chown -R ubuntu:ubuntu /tmp/jmeter.log

echo ""
echo "Setting up IS instances..."
echo "============================================"
wso2is_1_host_alias=wso2is1
wso2is_2_host_alias=wso2is2

sudo -u ubuntu ssh $wso2is_1_host_alias mkdir sar setup
sudo -u ubuntu scp workspace/setup/setup-common.sh $wso2is_1_host_alias:/home/ubuntu/setup/
sudo -u ubuntu scp workspace/sar/install-sar.sh $wso2is_1_host_alias:/home/ubuntu/sar/
sudo -u ubuntu scp workspace/is/restart-is.sh $wso2is_1_host_alias:/home/ubuntu/
sudo -u ubuntu ssh $wso2is_1_host_alias sudo ./setup/setup-common.sh -p zip -p jq -p bc
sudo -u ubuntu ssh $wso2is_1_host_alias sudo apt-get install -y realpath

sudo -u ubuntu ssh $wso2is_2_host_alias mkdir sar setup
sudo -u ubuntu scp workspace/setup/setup-common.sh $wso2is_2_host_alias:/home/ubuntu/setup/
sudo -u ubuntu scp workspace/sar/install-sar.sh $wso2is_2_host_alias:/home/ubuntu/sar/
sudo -u ubuntu scp workspace/is/restart-is.sh $wso2is_2_host_alias:/home/ubuntu/
sudo -u ubuntu ssh $wso2is_2_host_alias sudo ./setup/setup-common.sh -p zip -p jq -p bc
sudo -u ubuntu ssh $wso2is_2_host_alias sudo apt-get install -y realpath
