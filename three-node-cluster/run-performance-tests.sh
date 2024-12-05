#!/bin/bash -e
#  Copyright 2023 WSO2, LLC. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
# ----------------------------------------------------------------------------
# Run Ballerina Performance Tests
# ----------------------------------------------------------------------------

script_dir=$(dirname "$0")

wso2is_1_host_alias=wso2is1
wso2is_2_host_alias=wso2is2
wso2is_3_host_alias=wso2is3
lb_ssh_host_alias=loadbalancer
rds_ssh_host_alias=rds
session_rds_ssh_host_alias=sessionrds

# Execute common script
. $script_dir/perf-test-is.sh "$@"

# Source test scenarios
source $script_dir/test_scenarios.sh

function before_execute_test_scenario() {

    ssh $wso2is_1_host_alias "./restart-is.sh -m $heap"
    ssh $wso2is_2_host_alias "./restart-is.sh -m $heap"
    ssh $wso2is_3_host_alias "./restart-is.sh -m $heap"

    echo "Cleaning databases..."
    rds_host=$(get_ssh_hostname $rds_ssh_host_alias)
    session_rds_host=$(get_ssh_hostname $session_rds_ssh_host_alias)
    clean_database "$@" "$rds_host" "$session_rds_host"
}

function after_execute_test_scenario() {

    is_home="/home/ubuntu/wso2is"
    write_server_metrics $wso2is_1_host_alias $wso2is_1_host_alias
    download_file "$wso2is_1_host_alias" $is_home/repository/logs/wso2carbon.log "$wso2is_1_host_alias.log"
    download_file "$wso2is_1_host_alias" $is_home/repository/logs/gc.log $wso2is_1_host_alias"_gc.log"
    download_file "$wso2is_1_host_alias" $is_home/repository/logs/heap-dump.hprof "$wso2is_1_host_alias-heap-dump.hprof"

    write_server_metrics $wso2is_2_host_alias $wso2is_2_host_alias
    download_file "$wso2is_2_host_alias" $is_home/repository/logs/wso2carbon.log "$wso2is_2_host_alias.log"
    download_file "$wso2is_2_host_alias" $is_home/repository/logs/gc.log $wso2is_2_host_alias"_gc.log"
    download_file "$wso2is_2_host_alias" $is_home/repository/logs/heap-dump.hprof "$wso2is_2_host_alias-heap-dump.hprof"

    write_server_metrics $wso2is_3_host_alias $wso2is_3_host_alias
    download_file "$wso2is_3_host_alias" $is_home/repository/logs/wso2carbon.log "$wso2is_3_host_alias.log"
    download_file "$wso2is_3_host_alias" $is_home/repository/logs/gc.log $wso2is_3_host_alias"_gc.log"
    download_file "$wso2is_3_host_alias" $is_home/repository/logs/heap-dump.hprof "$wso2is_3_host_alias-heap-dump.hprof"
}

test_scenarios
