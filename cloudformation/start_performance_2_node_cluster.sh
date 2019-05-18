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
# Run all scripts.
# ----------------------------------------------------------------------------

# Cloud Formation parameters.

key_file=""
aws_access_key=""
aws_access_secret=""
certificate_name=""
jmeter_setup=""
is_setup=""
default_db_username="wso2carbon"
db_username="$default_db_username"
default_db_password="wso2carbon"
db_password="$default_db_password"
db_instance_type=db.m4.xlarge
default_is_instance_type=c5.xlarge
wso2_is_instance_type="$default_is_instance_type"
default_bastion_instance_type=c5.xlarge
bastion_instance_type="$default_bastion_instance_type"

script_start_time=$(date +%s)
timestamp=$(date +%Y-%m-%d-%H-%M-%S)
stack_name="is-performance-two-node-$timestamp"
script_dir=$(dirname "$0")
results_dir="$PWD/results-$timestamp"
is_performance_distribution=""
is_installer_url=""
default_minimum_stack_creation_wait_time=10
minimum_stack_creation_wait_time="$default_minimum_stack_creation_wait_time"

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -k <key_file> -a <aws_access_key> -s <aws_access_secret>"
    echo "   -c <certificate_name> -j <jmeter_setup_path>"
    echo "   [-n <IS_zip_file_path>]"
    echo "   [-u <db_username>] [-p <db_password>]"
    echo "   [-i <wso2_is_instance_type>] [-b <bastion_instance_type>]"
    echo "   [-w <minimum_stack_creation_wait_time>] [-h]"
    echo ""
    echo "-k: The Amazon EC2 key file to be used to access the instances."
    echo "-a: The AWS access key."
    echo "-s: The AWS access secret."
    echo "-j: The path to JMeter setup."
    echo "-c: The name of the IAM certificate."
    echo "-n: The is server zip"
    echo "-u: The database username. Default: $default_db_username."
    echo "-p: The database password. Default: $default_db_password."
    echo "-i: The instance type used for IS nodes. Default: $default_is_instance_type."
    echo "-b: The instance type used for the bastion node. Default: $default_bastion_instance_type."
    echo "-w: The minimum time to wait in minutes before polling for cloudformation stack's CREATE_COMPLETE status."
    echo "    Default: $default_minimum_stack_creation_wait_time minutes."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "k:a:s:c:j:n:u:p:i:b:w:h" opts; do
    case $opts in
    k)
        key_file=${OPTARG}
        ;;
    a)
        aws_access_key=${OPTARG}
        ;;
    s)
        aws_access_secret=${OPTARG}
        ;;
    c)
        certificate_name=${OPTARG}
        ;;
    j)
        jmeter_setup=${OPTARG}
        ;;
    n)
        is_setup=${OPTARG}
        ;;
    u)
        db_username=${OPTARG}
        ;;
    p)
        db_password=${OPTARG}
        ;;
    i)
        wso2_is_instance_type=${OPTARG}
        ;;
    b)
        bastion_instance_type=${OPTARG}
        ;;
    w)
        minimum_stack_creation_wait_time=${OPTARG}
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
shift "$((OPTIND - 1))"

run_performance_tests_options="$@"

if [[ ! -f $key_file ]]; then
    echo "Please provide the key file."
    exit 1
fi

if [[ ${key_file: -4} != ".pem" ]]; then
    echo "AWS EC2 Key file must have .pem extension"
    exit 1
fi

if [[ -z $aws_access_key ]]; then
    echo "Please provide the AWS access Key."
    exit 1
fi

if [[ -z $aws_access_secret ]]; then
    echo "Please provide the AWS access secret."
    exit 1
fi

if [[ -z $db_username ]]; then
    echo "Please provide the database username."
    exit 1
fi

if [[ -z $db_password ]]; then
    echo "Please provide the database password."
    exit 1
fi

if [[ -z $jmeter_setup ]]; then
    echo "Please provide the path to JMeter setup."
    exit 1
fi

if [[ -z $certificate_name ]]; then
    echo "Please provide the name of the IAM certificate."
    exit 1
fi

if [[ -z $wso2_is_instance_type ]]; then
    echo "Please provide the AWS instance type for WSO2 IS nodes."
    exit 1
fi

if [[ -z $bastion_instance_type ]]; then
    echo "Please provide the AWS instance type for the bastion node."
    exit 1
fi

if [[ -z $is_setup ]]; then
    echo "Please provide is zip file path."
    exit 1
fi

if ! [[ $minimum_stack_creation_wait_time =~ ^[0-9]+$ ]]; then
    echo "Please provide a valid minimum time to wait before polling for cloudformation stack's CREATE_COMPLETE status."
    exit 1
fi

key_filename=$(basename $key_file)
key_name=${key_filename%.*}

function check_command() {
    if ! command -v $1 >/dev/null 2>&1; then
        echo "Please install $1"
        exit 1
    fi
}

# Checking for the availability of commands in jenkins.
check_command bc
check_command aws
check_command unzip
check_command jq
check_command python

function format_time() {
    # Duration in seconds
    local duration="$1"
    local minutes=$(echo "$duration/60" | bc)
    local seconds=$(echo "$duration-$minutes*60" | bc)
    if [[ $minutes -ge 60 ]]; then
        local hours=$(echo "$minutes/60" | bc)
        minutes=$(echo "$minutes-$hours*60" | bc)
        printf "%d hour(s), %02d minute(s) and %02d second(s)\n" $hours $minutes $seconds
    elif [[ $minutes -gt 0 ]]; then
        printf "%d minute(s) and %02d second(s)\n" $minutes $seconds
    else
        printf "%d second(s)\n" $seconds
    fi
}

function measure_time() {
    local end_time=$(date +%s)
    local start_time=$1
    local duration=$(echo "$end_time - $start_time" | bc)
    echo "$duration"
}

function exit_handler() {
    # Get stack events
    local stack_events_json=$results_dir/stack-events.json
    echo ""
    echo "Saving stack events to $stack_events_json"
    aws cloudformation describe-stack-events --stack-name $stack_id --no-paginate --output json >$stack_events_json
    # Check whether there are any failed events
    cat $stack_events_json | jq '.StackEvents | .[] | select ( .ResourceStatus == "CREATE_FAILED" )'

    local stack_delete_start_time=$(date +%s)
    echo ""
    echo "Deleting the stack: $stack_id"
    aws cloudformation delete-stack --stack-name $stack_id

    echo ""
    echo "Polling till the stack deletion completes..."
    aws cloudformation wait stack-delete-complete --stack-name $stack_id
    printf "Stack deletion time: %s\n" "$(format_time $(measure_time $stack_delete_start_time))"

    printf "Script execution time: %s\n" "$(format_time $(measure_time $script_start_time))"
}

mkdir $results_dir
echo ""
echo "Results will be downloaded to $results_dir"

echo ""
echo "Extracting IS Performance Distribution to $results_dir"
tar -xf ../distribution/target/is-performance-distribution-*.tar.gz -C $results_dir

home="$results_dir/setup"

echo ""
echo "Script home folder is: $home"

estimate_command="$results_dir/jmeter/run-performance-tests.sh -t ${run_performance_tests_options[@]}"
echo ""
echo "Estimating time for performance tests: $estimate_command"
# Estimating this script will also validate the options. It's important to validate options before creating the stack.
$estimate_command

temp_dir=$(mktemp -d)

# Get absolute paths
key_file=$(realpath $key_file)

echo "your key is"
echo $key_file

ln -s $key_file $temp_dir/$key_filename

cd $script_dir

echo ""
echo "Validating stack..."
aws cloudformation validate-template --template-body file://2-node-cluster.yml

# Save metadata
test_parameters_json='.'
test_parameters_json+=' | .["is_nodes_ec2_instance_type"]=$is_nodes_ec2_instance_type'
test_parameters_json+=' | .["bastion_node_ec2_instance_type"]=$bastion_node_ec2_instance_type'
jq -n \
    --arg is_nodes_ec2_instance_type "$wso2_is_instance_type" \
    --arg bastion_node_ec2_instance_type "$bastion_instance_type" \
    "$test_parameters_json" > $results_dir/cf-test-metadata.json

stack_create_start_time=$(date +%s)
create_stack_command="aws cloudformation create-stack --stack-name $stack_name \
    --template-body file://2-node-cluster.yml --parameters \
        ParameterKey=CertificateName,ParameterValue=$certificate_name \
        ParameterKey=KeyPairName,ParameterValue=$key_name \
        ParameterKey=DBUsername,ParameterValue=$db_username \
        ParameterKey=DBPassword,ParameterValue=$db_password \
        ParameterKey=WSO2InstanceType,ParameterValue=$wso2_is_instance_type \
        ParameterKey=DBInstanceType,ParameterValue=$db_instance_type \
        ParameterKey=BastionInstanceType,ParameterValue=$bastion_instance_type \
    --capabilities CAPABILITY_IAM"

echo ""
echo "Creating stack..."
echo "$create_stack_command"
stack_id="$($create_stack_command)"
stack_id=$(echo $stack_id|jq -r .StackId)

# Delete the stack in case of an error.
trap exit_handler EXIT

echo ""
echo "Created stack: $stack_id"

echo ""
echo "Waiting ${minimum_stack_creation_wait_time}m before polling for cloudformation stack's CREATE_COMPLETE status..."
sleep ${minimum_stack_creation_wait_time}m

echo ""
echo "Polling till the stack creation completes..."
aws cloudformation wait stack-create-complete --stack-name $stack_id
printf "Stack creation time: %s\n" "$(format_time $(measure_time $stack_create_start_time))"

echo ""
echo "Getting Bastion Node Public IP..."
bastion_instance="$(aws cloudformation describe-stack-resources --stack-name $stack_id --logical-resource-id WSO2BastionInstance | jq -r '.StackResources[].PhysicalResourceId')"
bastion_node_ip="$(aws ec2 describe-instances --instance-ids $bastion_instance | jq -r '.Reservations[].Instances[].PublicIpAddress')"
echo "Bastion Node Public IP: $bastion_node_ip"

echo ""
echo "Getting NGinx Instance Private IP..."
nginx_instance="$(aws cloudformation describe-stack-resources --stack-name $stack_id --logical-resource-id WSO2NGinxInstance | jq -r '.StackResources[].PhysicalResourceId')"
nginx_instance_ip="$(aws ec2 describe-instances --instance-ids $nginx_instance | jq -r '.Reservations[].Instances[].PrivateIpAddress')"
echo "NGinx Instance Private IP: $nginx_instance_ip"

echo ""
echo "Getting WSO2 IS Node 1 Private IP..."
wso2is_1_auto_scaling_grp="$(aws cloudformation describe-stack-resources --stack-name $stack_id --logical-resource-id WSO2ISNode1AutoScalingGroup | jq -r '.StackResources[].PhysicalResourceId')"
wso2is_1_instance="$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $wso2is_1_auto_scaling_grp | jq -r '.AutoScalingGroups[].Instances[].InstanceId')"
wso2_is_1_ip="$(aws ec2 describe-instances --instance-ids $wso2is_1_instance | jq -r '.Reservations[].Instances[].PrivateIpAddress')"
echo "WSO2 IS Node 1 Private IP: $wso2_is_1_ip"

echo ""
echo "Getting WSO2 IS Node 2 Private IP..."
wso2is_2_auto_scaling_grp="$(aws cloudformation describe-stack-resources --stack-name $stack_id --logical-resource-id WSO2ISNode2AutoScalingGroup | jq -r '.StackResources[].PhysicalResourceId')"
wso2is_2_instance="$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $wso2is_2_auto_scaling_grp | jq -r '.AutoScalingGroups[].Instances[].InstanceId')"
wso2_is_2_ip="$(aws ec2 describe-instances --instance-ids $wso2is_2_instance | jq -r '.Reservations[].Instances[].PrivateIpAddress')"
echo "WSO2 IS Node 2 Private IP: $wso2_is_2_ip"

echo ""
echo "Getting RDS Hostname..."
rds_instance="$(aws cloudformation describe-stack-resources --stack-name $stack_id --logical-resource-id WSO2ISDBInstance | jq -r '.StackResources[].PhysicalResourceId')"
rds_host="$(aws rds describe-db-instances --db-instance-identifier $rds_instance | jq -r '.DBInstances[].Endpoint.Address')"
echo "RDS Hostname: $rds_host"

if [[ -z $bastion_node_ip ]]; then
    echo "Bastion node IP could not be found. Exiting..."
    exit 1
fi
if [[ -z $nginx_instance_ip ]]; then
    echo "Load balancer IP could not be found. Exiting..."
    exit 1
fi
if [[ -z $wso2_is_1_ip ]]; then
    echo "WSO2 node 1 IP could not be found. Exiting..."
    exit 1
fi
if [[ -z $wso2_is_2_ip ]]; then
    echo "WSO2 node 2 IP could not be found. Exiting..."
    exit 1
fi
if [[ -z $rds_host ]]; then
    echo "RDS host could not be found. Exiting..."
    exit 1
fi

copy_is_pack_command="scp -i $key_file -o "StrictHostKeyChecking=no" $is_setup ubuntu@$bastion_node_ip:/home/ubuntu/wso2is.zip"
copy_key_file_command="scp -i $key_file -o "StrictHostKeyChecking=no" $key_file ubuntu@$bastion_node_ip:/home/ubuntu/private_key.pem"
copy_connector_command="scp -i $key_file -o "StrictHostKeyChecking=no" mysql-connector-java-*.jar ubuntu@$bastion_node_ip:/home/ubuntu/"

echo ""
echo "Copying IS server setup files..."
echo $copy_is_pack_command
$copy_is_pack_command
echo $copy_key_file_command
$copy_key_file_command
echo $copy_connector_command
$copy_connector_command

copy_bastion_setup_command="scp -i $key_file -o StrictHostKeyChecking=no $results_dir/setup/setup-bastion.sh ubuntu@$bastion_node_ip:/home/ubuntu/"
copy_jmeter_setup_command="scp -i $key_file -o StrictHostKeyChecking=no $jmeter_setup ubuntu@$bastion_node_ip:/home/ubuntu/"
copy_repo_setup_command="scp -i $key_file -o "StrictHostKeyChecking=no" ../distribution/target/is-performance-distribution-*.tar.gz \
    ubuntu@$bastion_node_ip:/home/ubuntu"

echo ""
echo "Copying files to Bastion node..."
echo $copy_bastion_setup_command
$copy_bastion_setup_command
echo $copy_jmeter_setup_command
$copy_jmeter_setup_command
echo $copy_repo_setup_command
$copy_repo_setup_command

setup_bastion_node_command="ssh -i $key_file -o "StrictHostKeyChecking=no" -t ubuntu@$bastion_node_ip sudo \
    ./setup-bastion.sh -w $wso2_is_1_ip -i $wso2_is_2_ip -r $rds_host -l $nginx_instance_ip"
echo ""
echo "Running Bastion Node setup script: $setup_bastion_node_command"
# Handle any error and let the script continue.
$setup_bastion_node_command || echo "Remote ssh command failed."

echo ""
echo "Creating databases in RDS..."
echo "============================================"
create_db_command="ssh -i $key_file -o "StrictHostKeyChecking=no" -t ubuntu@$bastion_node_ip mysql -h $rds_host \
    -u wso2carbon -pwso2carbon < /home/ubuntu/workspace/setup/resources/createDB.sql"
echo $create_db_command
ssh -i $key_file -o "StrictHostKeyChecking=no" -t ubuntu@$bastion_node_ip "cd /home/ubuntu/ ; unzip -q wso2is.zip ; \
    mv wso2is-* wso2is"
$create_db_command

echo ""
echo "Running IS node 1 setup script..."
echo "============================================"
setup_is_command="ssh -i $key_file -o "StrictHostKeyChecking=no" -t ubuntu@$bastion_node_ip \
    ./workspace/setup/setup-is.sh -i $wso2_is_1_ip -w $wso2_is_2_ip -r $rds_host"
echo $setup_is_command
# Handle any error and let the script continue.
$setup_is_command || echo "Remote ssh command to setup IS node 1 through bastion failed."

echo ""
echo "Running IS node 2 setup script..."
echo "============================================"
setup_is_command="ssh -i $key_file -o "StrictHostKeyChecking=no" -t ubuntu@$bastion_node_ip \
    ./workspace/setup/setup-is.sh -i $wso2_is_2_ip -w $wso2_is_1_ip -r $rds_host"
echo $setup_is_command
# Handle any error and let the script continue.
$setup_is_command || echo "Remote ssh command to setup IS node 2 through bastion failed."

echo ""
echo "Running performance tests..."
echo "============================================"
run_performance_tests_command="./workspace/jmeter/run-performance-tests.sh ${run_performance_tests_options[@]}"
run_remote_tests="ssh -i $key_file -o "StrictHostKeyChecking=no" -t ubuntu@$bastion_node_ip $run_performance_tests_command"
echo $run_remote_tests
$run_remote_tests || echo "Remote test ssh command failed."

ECHO ""
echo "Downloading results..."
echo "============================================"
download="scp -i $key_file -o "StrictHostKeyChecking=no" ubuntu@$bastion_node_ip:/home/ubuntu/results.zip $results_dir/"
echo $download
$download || echo "Remote download failed"

if [[ ! -f $results_dir/results.zip ]]; then
    echo ""
    echo "Failed to download the results.zip"
    exit 500
fi

echo ""
echo "Creating summary.csv..."
echo "============================================"
cd $results_dir
unzip -q results.zip
wget -q http://sourceforge.net/projects/gcviewer/files/gcviewer-1.35.jar/download -O gcviewer.jar
$results_dir/jmeter/create-summary-csv.sh -d results -n "WSO2 Identity Server" -p wso2is -c "Heap Size" \
    -c "Concurrent Users" -r "([0-9]+[a-zA-Z])_heap" -r "([0-9]+)_users" -i -l -k 2 -g gcviewer.jar

echo "Creating summary results markdown file..."
./jmeter/create-summary-markdown.py --json-files cf-test-metadata.json results/test-metadata.json --column-names \
    "Scenario Name" "Concurrent Users" "Label" "Error %" "Throughput (Requests/sec)" "Average Response Time (ms)" \
    "Standard Deviation of Response Time (ms)" "99th Percentile of Response Time (ms)" \
    "WSO2 Identity Server 1 GC Throughput (%)" "WSO2 Identity Server GC 2 Throughput (%)"

echo ""
echo "Done."
