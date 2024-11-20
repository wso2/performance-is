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
# Contains common shell script functions.
# ----------------------------------------------------------------------------

function check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Please install $1"
        exit 1
    fi
}

function format_time() {
    # Duration in seconds
    local duration="$1"
    local minutes=$(echo "$duration/60" | bc)
    local seconds=$(echo "$duration-$minutes*60" | bc)
    if [[ $minutes -ge 60 ]]; then
        local hours=$(echo "$minutes/60" | bc)
        minutes=$(echo "$minutes-$hours*60" | bc)
        printf "%d hour(s), %02d minute(s) and %02d second(s)\n" "$hours" "$minutes" "$seconds"
    elif [[ $minutes -gt 0 ]]; then
        printf "%d minute(s) and %02d second(s)\n" "$minutes" "$seconds"
    else
        printf "%d second(s)\n" "$seconds"
    fi
}

function measure_time() {
    local end_time=$(date +%s)
    local start_time=$1
    local duration=$(echo "$end_time - $start_time" | bc)
    echo "$duration"
}

function exit_handler() {

    # Resolving parameters
    results_dir="$1"
    stack_id="$2"
    script_start_time="$3"

    # Get stack events
    local stack_events_json=$results_dir/stack-events.json
    echo ""
    echo "Saving stack events to $stack_events_json"
    aws cloudformation describe-stack-events --stack-name "$stack_id" --no-paginate --output json >"$stack_events_json"
    # Check whether there are any failed events
    cat "$stack_events_json" | jq '.StackEvents | .[] | select ( .ResourceStatus == "CREATE_FAILED" )'

    local stack_delete_start_time=$(date +%s)
    echo ""
    echo "Deleting the stack: $stack_id"
    aws cloudformation delete-stack --stack-name "$stack_id"

    echo ""
    echo "Polling till the stack deletion completes..."
    aws cloudformation wait stack-delete-complete --stack-name "$stack_id"
    printf "Stack deletion time: %s\n" "$(format_time $(measure_time "$stack_delete_start_time"))"

    printf "Script execution time: %s\n" "$(format_time $(measure_time "$script_start_time"))"
}

function ssh_bastion_cmd() {

    local ssh_command="ssh -i $key_file -o "StrictHostKeyChecking=no" -t ubuntu@$bastion_node_ip $1"
    echo "$ssh_command"
    $ssh_command || echo "Remote ssh command failed."
}

function scp_bastion_cmd() {

    local scp_command="scp -i $key_file -o "StrictHostKeyChecking=no" $1 ubuntu@$bastion_node_ip:$2"
    echo "$scp_command"
    $scp_command || echo "Remote scp command failed."
}

function scp_r_bastion_cmd() {

    local scp_command="scp -r -i $key_file -o "StrictHostKeyChecking=no" $1 ubuntu@$bastion_node_ip:$2"
    echo "$scp_command"
    $scp_command || echo "Remote scp command failed."
}

function download_bastion_cmd() {

    local scp_command="scp -i $key_file -o "StrictHostKeyChecking=no" ubuntu@$bastion_node_ip:$1 $2"
    echo "$scp_command"
    "$scp_command" || echo "Download failed."
}

function get_private_ip() {

    local stack_id=$1
    local auto_scaling_grp_id=$2
    local wso2is_auto_scaling_grp
    local wso2is_instance
    local wso2_is_ip

    wso2is_auto_scaling_grp="$(aws cloudformation describe-stack-resources --stack-name "$stack_id" --logical-resource-id "$auto_scaling_grp_id" | jq -r '.StackResources[].PhysicalResourceId')"
    wso2is_instance="$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$wso2is_auto_scaling_grp" | jq -r '.AutoScalingGroups[].Instances[].InstanceId')"
    wso2_is_ip="$(aws ec2 describe-instances --instance-ids "$wso2is_instance" | jq -r '.Reservations[].Instances[].PrivateIpAddress')"
    echo "$wso2_is_ip"
}

function execute_db_command() {

    local db_host="$1"
    local sql_file="$2"
    # Construct the database-specific command
    local db_command=""
    case "$db_type" in
        mysql)
            db_command="mysql -h \"$db_host\" -u wso2carbon -pwso2carbon < \"$sql_file\""
            ;;
        mssql)
            db_command="/opt/mssql-tools/bin/sqlcmd -S \"$db_host\" -U wso2carbon -P wso2carbon -i \"$sql_file\""
            ;;
        *)
            echo "Unsupported database type: $db_type"
            return 1
            ;;
    esac
    ssh_bastion_cmd "$db_command"
}
