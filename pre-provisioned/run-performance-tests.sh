#!/bin/bash -e
# Copyright (c) 2021, WSO2 Inc. (http://wso2.org) All Rights Reserved.
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
# Run Ballerina Performance Tests
# ----------------------------------------------------------------------------

script_dir=$(dirname "$0")

wso2is_1_host_alias=wso2is1
wso2is_2_host_alias=wso2is2
lb_ssh_host_alias=loadbalancer
rds_ssh_host_alias=rds
db_username="wso2carbon"
db_password="wso2carbon"

# Execute common script
. $script_dir/perf-test-pre-provisioned.sh

function before_execute_test_scenario() {

    jmeter_params+=("port=443")

    echo "Cleaning databases..."
    if [ "$databaseType" == "mysql" ] ; then
      echo "Database Type MySQL."
      mysql -u $db_username -h "$rds_host" $databaseName -p$db_password < /home/ubuntu/workspace/is/clean-database.sql
    else
      echo "Database Type MSSQL."
      sqlcmd -S "$rds_host" -U $db_username -P $db_password -d $databaseName -i /home/ubuntu/workspace/is/clean-database-mssql.sql
    fi
}


test_scenarios
