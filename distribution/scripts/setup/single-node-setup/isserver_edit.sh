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
# ----------------------------------------------------------------------------
# edit is server script.
# ----------------------------------------------------------------------------


function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -d <wso2is_path>"
    echo ""
    # echo "-d: The path to wso2is server"
    echo "-l: The ip address of RDS"
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "d:l:h" opts; do
    case $opts in
    # d)
    #     is_server+=("${OPTARG}")
    #     ;;
    l)
        db_instance_ip+=("${OPTARG}")
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

echo "unzipping is server"
unzip wso2is.zip

echo ""
echo "changing server name"
mv wso2is-* wso2is

sudo chown -R ubuntu:ubuntu wso2is

echo "changing permission for mysql connector"

chmod 644 mysql-connector-java-5.1.47.jar


carbon_home=$(realpath ~/wso2is)

#add mysql connector
cp mysql-connector-java-5.1.47.jar $carbon_home/repository/components/lib/mysql-connector-java-5.1.47.jar

cp setup/master-datasources.xml $carbon_home/repository/conf/datasources/master-datasources.xml

cp setup/user-mgt.xml $carbon_home/repository/conf/user-mgt.xml


#apply basic parameter changes
sed -i 's$<dataSource>jdbc/WSO2CarbonDB$<dataSource>jdbc/WSO2_REG_DB$g' $carbon_home/repository/conf/registry.xml || echo "erro 1"
#sed -i 's$<dataSource>jdbc/WSO2_REG_DB$<dataSource>jdbc/REG_DB$g' $carbon_home/repository/conf/registry.xml || echo "erro 1"
sed -i 's$<Name>jdbc/WSO2CarbonDB$<Name>jdbc/WSO2_IDENTITY_DB$g' $carbon_home/repository/conf/identity/identity.xml || echo "erro 2" 
#sed -i 's$<Name>jdbc/WSO2_IDENTITY_DB$<Name>jdbc/IDENTITY_DB$g' $carbon_home/repository/conf/identity/identity.xml || echo "erro 2"
sed -i 's/JVM_MEM_OPTS="-Xms256m -Xmx1024m"/JVM_MEM_OPTS="-Xms2g -Xmx2g"/g' $carbon_home/bin/wso2server.sh || echo "erro 3"
#sed -i 's$<Property name="dataSource">jdbc/WSO2_USER_DB$<Property name="dataSource">jdbc/UM_DB$g' $carbon_home/repository/conf/user-mgt.xml || echo "erro 4"

#apply tuning parameters

sed -i 's/CaseInsensitiveUsername">true/CaseInsensitiveUsername">false/' $carbon_home/repository/conf/user-mgt.xml
sed -i 's/<maxActive>50</<maxActive>300</' $carbon_home/repository/conf/datasources/master-datasources.xml
sed -i 's/maxThreads="250"/maxThreads="500"/' $carbon_home/repository/conf/tomcat/catalina-server.xml
sed -i 's/acceptCount="200"/acceptCount="500"/' $carbon_home/repository/conf/tomcat/catalina-server.xml
sed -i 's/<EnableSSOConsentManagement>true</<EnableSSOConsentManagement>false</' $carbon_home/repository/conf/identity/identity.xml
# sed -i '/<clustering class="org.wso2.carbon.core.clustering.hazelcast.HazelcastClusteringAgent"/{N;s/enable="true"/enable="false"/}' $carbon_home/repository/conf/axis2/axis2.xml

#change mysql url
sed -i "s|<url>jdbc:mysql://wso2isdbinstance2.cd3cwezibdu8.us-east-1.rds.amazonaws.com|<url>jdbc:mysql://$db_instance_ip|g" $carbon_home/repository/conf/datasources/master-datasources.xml

#creating databases in RDS

echo "creating tables in RDS"
mysql -h $db_instance_ip -u wso2carbon -pwso2carbon < createDB.sql


echo "starting wso2 is server"
./wso2is/bin/wso2server.sh start


echo "waiting 100s for is server to up and running "
sleep 100s


