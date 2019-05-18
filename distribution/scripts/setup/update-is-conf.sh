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
    echo "-i: The IP of wso2is node."
    echo "-r: The IP address of RDS."
    echo "-w: The IP of other wso2is node."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "w:i:r:h" opts; do
    case $opts in
    w)
        wso2_is_1_ip=("${OPTARG}")
        ;;
    i)
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

if [[ -z $db_instance_ip ]]; then
    echo "Please provide the db instance ip address."
    exit 1
fi

if [[ -z $wso2_is_1_ip ]]; then
    echo "Please provide the WSO2 IS node 1 ip address."
    exit 1
fi

if [[ -z $wso2_is_2_ip ]]; then
    echo "Please provide the WSO2 IS node 2 ip address."
    exit 1
fi

sudo mkdir -p /etc/.java/.systemPrefs
cd /etc/.java/.systemPrefs
sudo touch .systemRootModFile
sudo chmod 544 .systemRootModFile
cd ..
sudo chmod 777 .systemPrefs/
cd ~

echo "unzipping is server"
unzip -q wso2is.zip

echo ""
echo "changing server name"
mv wso2is-* wso2is

sudo chown -R ubuntu:ubuntu wso2is

echo "changing permission for mysql connector"

chmod 644 mysql-connector-java-*.jar

carbon_home=$(realpath ~/wso2is)

echo ""
echo "Adding mysql connector to the pack..."
echo "============================================"
cp mysql-connector-java-*.jar $carbon_home/repository/components/lib/

echo ""
echo "Adding conf files to the pack..."
echo "============================================"
cp resources/master-datasources.xml $carbon_home/repository/conf/datasources/master-datasources.xml
cp resources/user-mgt.xml $carbon_home/repository/conf/user-mgt.xml
cp resources/registry.xml $carbon_home/repository/conf/registry.xml
cp resources/axis2.xml $carbon_home/repository/conf/axis2/axis2.xml
cp resources/hazelcast.properties $carbon_home/repository/conf/hazelcast.properties
cp resources/catalina-server.xml $carbon_home/repository/conf/tomcat/catalina-server.xml

echo ""
echo "Applying basic parameter changes..."
echo "============================================"
sed -i 's$<Name>jdbc/WSO2CarbonDB$<Name>jdbc/WSO2_IDENTITY_DB$g' $carbon_home/repository/conf/identity/identity.xml || echo "error 1"
sed -i 's/JVM_MEM_OPTS="-Xms256m -Xmx1024m"/JVM_MEM_OPTS="-Xms2g -Xmx2g"/g' $carbon_home/bin/wso2server.sh || echo "error 2"
sed -i "s|<url>jdbc:mysql://localhost|<url>jdbc:mysql://$db_instance_ip|g" $carbon_home/repository/conf/datasources/master-datasources.xml || echo "error 3"

sed -i 's$<Property name="enable">true</Property>$<Property name="enable">false</Property>$g' $carbon_home/repository/conf/identity/embedded-ldap.xml || echo "error 4"
sed -i 's$name="localMemberHost">127.0.0.1</parameter>$name="localMemberHost">'$wso2_is_1_ip'</parameter>$g' $carbon_home/repository/conf/axis2/axis2.xml || echo "error 5"
sed -i 's$<hostName>127.0.0.1</hostName>$<hostName>'$wso2_is_1_ip'</hostName>$g' $carbon_home/repository/conf/axis2/axis2.xml || echo "error 6"
sed -i 's$<hostName>127.0.0.2</hostName>$<hostName>'$wso2_is_2_ip'</hostName>$g' $carbon_home/repository/conf/axis2/axis2.xml || echo "error 7"

echo ""
echo "Applying tuning parameters..."
echo "============================================"
sed -i 's/CaseInsensitiveUsername">true/CaseInsensitiveUsername">false/' $carbon_home/repository/conf/user-mgt.xml
sed -i 's/<maxActive>50</<maxActive>300</' $carbon_home/repository/conf/datasources/master-datasources.xml
sed -i 's/maxThreads="250"/maxThreads="500"/' $carbon_home/repository/conf/tomcat/catalina-server.xml
sed -i 's/acceptCount="200"/acceptCount="500"/' $carbon_home/repository/conf/tomcat/catalina-server.xml
sed -i 's/<EnableSSOConsentManagement>true</<EnableSSOConsentManagement>false</' $carbon_home/repository/conf/identity/identity.xml

# Setting required for long running tests.
#sed -i 's/<CleanUpTimeout>20160</<CleanUpTimeout>240</' $carbon_home/repository/conf/identity/identity.xml
#sed -i 's/<CleanUpPeriod>1440</<CleanUpPeriod>120</' $carbon_home/repository/conf/identity/identity.xml

echo ""
echo "Starting WSO2 IS server..."
echo "============================================"
./wso2is/bin/wso2server.sh start
sleep 100s
