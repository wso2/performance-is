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
