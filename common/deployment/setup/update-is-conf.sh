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

function add_mysql_connector() {

    echo ""
    echo "Changing permission for MySQL connector"
    echo "-------------------------------------------"
    chmod 644 mysql-connector-j-*.jar

    echo ""
    echo "Adding MySQL connector to the pack..."
    echo "-------------------------------------------"
    cp mysql-connector-j-*.jar "$carbon_home"/repository/components/lib/
}

function add_mssql_connector() {
    echo ""
    echo "Changing permission for MSSQL connector"
    echo "-------------------------------------------"
    chmod 644 mssql-jdbc-*.jar

    echo ""
    echo "Adding MSSQL connector to the pack..."
    echo "-------------------------------------------"
    cp mssql-jdbc-*.jar "$carbon_home"/repository/components/lib/
}

function add_postgres_connector() {
    echo ""
    echo "Changing permission for Postgres connector"
    echo "-------------------------------------------"
    chmod 644 postgresql-*.jar

    echo ""
    echo "Adding Postgres connector to the pack..."
    echo "-------------------------------------------"
    cp postgresql-*.jar "$carbon_home"/repository/components/lib/
}

function update_mysql_config() {

    local configs=(
      "s|{identity_db_url}|jdbc:mysql://$db_instance_ip:3306/IDENTITY_DB?useSSL=false\&amp;rewriteBatchedStatements=true|g"
      "s|{session_db_url}|jdbc:mysql://$session_db_instance_ip:3306/SESSION_DB?useSSL=false\&amp;rewriteBatchedStatements=true|g"
      "s|{user_db_url}|jdbc:mysql://$db_instance_ip:3306/UM_DB?useSSL=false\&amp;rewriteBatchedStatements=true|g"
      "s|{reg_db_url}|jdbc:mysql://$db_instance_ip:3306/REG_DB?useSSL=false\&amp;rewriteBatchedStatements=true|g"
      "s|{db_driver}|com.mysql.jdbc.Driver|g"
      "s|{identity_default_auto_commit}|true|g"
    )
    
    for config in "${configs[@]}"; do
      sed -i "$config" "$carbon_home/repository/conf/deployment.toml" || echo "Editing deployment.toml file failed!"
    done
}


function update_mssql_config() {

    local configs=(
      "s|{identity_db_url}|jdbc:sqlserver://$db_instance_ip:1433;databaseName=IDENTITY_DB;SendStringParametersAsUnicode=false;encrypt=true;trustServerCertificate=true;|g"
      "s|{session_db_url}|jdbc:sqlserver://$session_db_instance_ip:1433;databaseName=SESSION_DB;SendStringParametersAsUnicode=false;encrypt=true;trustServerCertificate=true;|g"
      "s|{user_db_url}|jdbc:sqlserver://$db_instance_ip:1433;databaseName=UM_DB;SendStringParametersAsUnicode=false;encrypt=true;trustServerCertificate=true;|g"
      "s|{reg_db_url}|jdbc:sqlserver://$db_instance_ip:1433;databaseName=REG_DB;SendStringParametersAsUnicode=false;encrypt=true;trustServerCertificate=true;|g"
      "s|{db_driver}|com.microsoft.sqlserver.jdbc.SQLServerDriver|g"
    )
    
    for config in "${configs[@]}"; do
      sed -i "$config" "$carbon_home/repository/conf/deployment.toml" || echo "Editing deployment.toml file failed!"
    done
}

function update_postgres_config() {

    local configs=(
      "s|{identity_db_url}|jdbc:postgresql://$db_instance_ip:5432/IDENTITY_DB|g"
      "s|{session_db_url}|jdbc:postgresql://$session_db_instance_ip:5432/SESSION_DB|g"
      "s|{user_db_url}|jdbc:postgresql://$db_instance_ip:5432/UM_DB|g"
      "s|{reg_db_url}|jdbc:postgresql://$db_instance_ip:5432/REG_DB|g"
      "s|{db_driver}|org.postgresql.Driver|g"
    )

    for config in "${configs[@]}"; do
      sed -i "$config" "$carbon_home/repository/conf/deployment.toml" || echo "Editing deployment.toml file failed!"
    done
}

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -i <IS_NODE_IP> -r <RDS_IP> -w <OTHER_IS_NODE_IP> "
    echo ""
    echo "-i: The IP of wso2is node 1."
    echo "-j: The IP of wso2is node 3."
    echo "-k: The IP of wso2is node 4."
    echo "-r: The IP address of RDS."
    echo "-s: The IP address of session DB RDS."
    echo "-w: The IP of wso2is node 2."
    echo "-h: Display this help and exit."
    echo "-t: Keystore type."
    echo "-m: Database type."
    echo "-c: Case insensitivity of the username and attributes."
    echo ""
}

while getopts "n:w:i:j:k:r:s:t:m:c:h" opts; do
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
    r)
        db_instance_ip=${OPTARG}
        ;;
    s)
        session_db_instance_ip=${OPTARG}
        ;;
    t)
        keystore_type=${OPTARG}
        ;;
    m)
        db_type=${OPTARG}
        ;;
    c)
        is_case_insensitive_username_and_attributes=${OPTARG}
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

if [[ -z $session_db_instance_ip ]]; then
    echo "Please provide the session db instance ip address."
    exit 1
fi

if [[ -z $keystore_type ]]; then
    echo "Please provide the keystore type."
    exit 1
elif [[ $keystore_type == "PKCS12" ]]; then
    keystore_type="PKCS12"
    keystore_extension=".p12"
else
    keystore_type="JKS"
    keystore_extension=".jks"
fi

echo ""
echo "unzipping is server"
echo "-------------------------------------------"
unzip -q wso2is.zip

echo ""
echo "changing server name"
echo "-------------------------------------------"
mv wso2is-* wso2is

sudo chown -R ubuntu:ubuntu wso2is

carbon_home=$(realpath ~/wso2is)

if [[ $db_type == "mysql" ]]; then
    add_mysql_connector
elif [[ $db_type == "mssql" ]]; then
    add_mssql_connector
elif [[ $db_type == "postgres" ]]; then
    add_postgres_connector
else
    echo "Unsupported database type: $db_type"
    exit 1
fi

echo ""
echo "Adding deployment toml file to the pack..."
echo "-------------------------------------------"
cp resources/deployment.toml "$carbon_home"/repository/conf/deployment.toml

echo ""
echo "Applying basic parameter changes..."
echo "-------------------------------------------"
sed -i 's/JVM_MEM_OPTS="-Xms256m -Xmx1024m"/JVM_MEM_OPTS="-Xms4g -Xmx4g"/g' \
  "$carbon_home"/bin/wso2server.sh || echo "Editing wso2server.sh file failed!"
sed -i 's|{keystore_extension}|'"$keystore_extension"'|g' \
  "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"
sed -i "s|{keystore_type}|$keystore_type|g" \
  "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"
sed -i "s|{is_case_insensitive_username_and_attributes}|$is_case_insensitive_username_and_attributes|g" \
  "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"
if [[ $db_type == "mysql" ]]; then
    update_mysql_config
elif [[ $db_type == "mssql" ]]; then
    update_mssql_config
elif [[ $db_type == "postgres" ]]; then
    update_postgres_config
else
    echo "Unsupported database type: $db_type"
    exit 1
fi

if [[ -z $no_of_nodes ]]; then
    echo "Please provide the number of IS nodes in the deployment."
    exit 1
fi

if [[ $no_of_nodes -gt 1 ]]; then
    sed -i "s|member_ip_1|$wso2_is_1_ip|g" "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"
    sed -i "s|member_ip_2|$wso2_is_2_ip|g" "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"
fi
if [[ $no_of_nodes -gt 2 ]]; then
    sed -i "s|member_ip_3|$wso2_is_3_ip|g" "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"
fi
if [[ $no_of_nodes -gt 3 ]]; then
    sed -i "s|member_ip_4|$wso2_is_4_ip|g" "$carbon_home"/repository/conf/deployment.toml || echo "Editing deployment.toml file failed!"
fi

echo ""
echo "Starting WSO2 IS server..."
echo "-------------------------------------------"
./wso2is/bin/wso2server.sh start
sleep 100s

echo ""
echo "Restarting WSO2 IS server..."
echo "-------------------------------------------"
./wso2is/bin/wso2server.sh stop
sleep 10s

if [[ $db_type == "mysql" ]]; then
    echo "Reverting default auto commit to false for the identity db..."
    echo "-------------------------------------------"
    sed -i "s|{identity_default_auto_commit}|false|g" "$carbon_home/repository/conf/deployment.toml" || echo "Editing deployment.toml file failed!"
fi

./wso2is/bin/wso2server.sh start
sleep 60s
