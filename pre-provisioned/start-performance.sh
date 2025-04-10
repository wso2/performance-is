#!/bin/bash -e
# Copyright (c) 2021, wso2 Inc. (http://wso2.org) All Rights Reserved.
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
# Run Identity Server Performance tests for two node cluster deployment.
# ----------------------------------------------------------------------------

source ../common/common-functions.sh

script_start_time=$(date +%s)
timestamp=$(date +%Y-%m-%d--%H-%M-%S)

random_number=$RANDOM
# random_number=21265

stack_name="performance-pre-provisioned--$timestamp--$random_number"

key_file="/home/ubuntu/key.pem"
rds_host=""
certificate_name=""
jmeter_setup=""
is_setup=""
default_db_username="wso2carbon"
db_username="$default_db_username"
default_db_password="wso2carbon"
db_password="$default_db_password"
default_db_storage="100"
db_storage=$default_db_storage
default_db_instance_type=db.m4.2xlarge
db_instance_type=$default_db_instance_type
default_is_instance_type=c6i.xlarge
wso2_is_instance_type="$default_is_instance_type"
default_bastion_instance_type=c6i.xlarge
bastion_instance_type="$default_bastion_instance_type"
cloud_host_name=""
mode=""

results_dir="$PWD/results-$timestamp"
default_minimum_stack_creation_wait_time=5
minimum_stack_creation_wait_time="$default_minimum_stack_creation_wait_time"

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -k <key_file> -c <certificate_name> -j <jmeter_setup_path> -n <IS_zip_file_path>"
    echo "   [-u <db_username>] [-p <db_password>] [-d <db_storage>] [-e <db_instance_type>]"
    echo "   [-i <wso2_is_instance_type>] [-b <bastion_instance_type>]"
    echo "   [-w <minimum_stack_creation_wait_time>] [-h]"
    echo ""
    echo "-k: The Amazon EC2 key file to be used to access the instances."
    echo "-c: The name of the IAM certificate."
    echo "-j: The path to JMeter setup."
    echo "-n: RDS Hostname. Default: $rds_host."
    echo "-u: The database username. Default: $default_db_username."
    echo "-p: The database password. Default: $default_db_password."
    echo "-d: Cloud Hostname: $cloud_host_name."
    echo "-b: The instance type used for the bastion node. Default: $default_bastion_instance_type."
    echo "-w: The minimum time to wait in minutes before polling for cloudformation stack's CREATE_COMPLETE status."
    echo "    Default: $default_minimum_stack_creation_wait_time minutes."
    echo "-t: The required testing mode [FULL/QUICK]"
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "j:u:p:n:p:i:b:k:t:d:h" opts; do
    case $opts in
    j)
        jmeter_setup=${OPTARG}
        ;;
    u)
        db_username=${OPTARG}
        ;;
    p)
        db_password=${OPTARG}
        ;;
    b)
        bastion_instance_type=${OPTARG}
        ;;
    d)
        cloud_host_name=${OPTARG}
        ;;
    n)
        rds_host=${OPTARG}
        ;;
    k)
        key_file=${OPTARG}
        ;;
    t)
        mode=${OPTARG}
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

echo $rds_host
echo "Run mode: $mode"

run_performance_tests_options="$@"

run_performance_tests_options+=(" -l $cloud_host_name -n $rds_host -r $db_username -s $db_password -v $mode")

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

if [[ -z $bastion_instance_type ]]; then
    echo "Please provide the AWS instance type for the bastion node."
    exit 1
fi

if [[ -z $key_file ]]; then
    echo "Please provide the key file."
    exit 1
fi

# Checking for the availability of commands in jenkins.
check_command bc
check_command aws
check_command unzip
check_command jq
check_command python

mkdir "$results_dir"
echo ""
echo "Results will be downloaded to $results_dir"

echo ""
echo "Extracting IS Performance Distribution to $results_dir"
tar -xf target/is-performance-pre-provisioned*.tar.gz -C "$results_dir"

cp run-performance-tests.sh "$results_dir"/jmeter/
estimate_command="$results_dir/jmeter/run-performance-tests.sh -t ${run_performance_tests_options[@]}"
echo ""
echo "Estimating time for performance tests"
# Estimating this script will also validate the options. It's important to validate options before creating the stack.
$estimate_command

temp_dir=$(mktemp -d)

export AWS_DEFAULT_OUTPUT="json"

echo ""
echo "Preparing cloud formation template..."
echo "============================================"
echo "random_number: $random_number"
cp bastion-cft.yml new-bastion-cft.yml
sed -i "s/suffix/$random_number/" new-bastion-cft.yml

echo ""
echo "Validating stack..."
echo "============================================"
aws cloudformation validate-template --template-body file://new-bastion-cft.yml

# Save metadata
test_parameters_json='.'
test_parameters_json+=' | .["is_nodes_ec2_instance_type"]=$is_nodes_ec2_instance_type'
test_parameters_json+=' | .["bastion_node_ec2_instance_type"]=$bastion_node_ec2_instance_type'
jq -n \
    --arg is_nodes_ec2_instance_type "$wso2_is_instance_type" \
    --arg bastion_node_ec2_instance_type "$bastion_instance_type" \
    "$test_parameters_json" > "$results_dir"/cf-test-metadata.json

stack_create_start_time=$(date +%s)
create_stack_command="aws cloudformation create-stack --stack-name $stack_name \
    --template-body file://new-bastion-cft.yml --parameters \
        ParameterKey=KeyPairName,ParameterValue=iam-cloud-load-test \
        ParameterKey=BastionInstanceType,ParameterValue=$bastion_instance_type \
    --capabilities CAPABILITY_IAM"

echo ""
echo "Creating stack..."
echo "============================================"
echo "$create_stack_command"
stack_id="$($create_stack_command)"
stack_id=$(echo "$stack_id"|jq -r .StackId)

# Delete the stack in case of an error.
trap 'exit_handler "$results_dir" "$stack_id" "$script_start_time"' EXIT

echo ""
echo "Created stack ID: $stack_id"
rm new-bastion-cft.yml

echo ""
echo "Waiting ${minimum_stack_creation_wait_time}m before polling for cloudformation stack's CREATE_COMPLETE status..."
sleep "${minimum_stack_creation_wait_time}"m

echo ""
echo "Polling till the stack creation completes..."
aws cloudformation wait stack-create-complete --stack-name "$stack_id"
printf "Stack creation time: %s\n" "$(format_time "$(measure_time "$stack_create_start_time")")"

echo ""
echo "Getting Bastion Node Public IP..."
bastion_instance="$(aws cloudformation describe-stack-resources --stack-name "$stack_id" --logical-resource-id WSO2BastionInstance"$random_number" | jq -r '.StackResources[].PhysicalResourceId')"
bastion_node_ip="$(aws ec2 describe-instances --instance-ids "$bastion_instance" | jq -r '.Reservations[].Instances[].PublicIpAddress')"
echo "Bastion Node Public IP: $bastion_node_ip"


if [[ -z $bastion_node_ip ]]; then
    echo "Bastion node IP could not be found. Exiting..."
    exit 1
fi

echo ""
echo "Copying files to Bastion node..."
echo "============================================"
copy_setup_files_command="scp -r -i $key_file -o "StrictHostKeyChecking=no" $results_dir/setup ubuntu@$bastion_node_ip:/home/ubuntu/"
copy_repo_setup_command="scp -i $key_file -o "StrictHostKeyChecking=no" target/is-performance-pre-provisioned-*.tar.gz \
    ubuntu@$bastion_node_ip:/home/ubuntu"

echo "$copy_setup_files_command"
$copy_setup_files_command
echo "$copy_repo_setup_command"
$copy_repo_setup_command

copy_jmeter_setup_command="scp -i $key_file -o StrictHostKeyChecking=no $jmeter_setup ubuntu@$bastion_node_ip:/home/ubuntu/"
copy_is_pack_command="scp -i $key_file -o "StrictHostKeyChecking=no" $is_setup ubuntu@$bastion_node_ip:/home/ubuntu/wso2is.zip"
copy_key_file_command="scp -i $key_file -o "StrictHostKeyChecking=no" $key_file ubuntu@$bastion_node_ip:/home/ubuntu/private_key.pem"
copy_connector_command="scp -r -i $key_file -o "StrictHostKeyChecking=no" $results_dir/lib/* ubuntu@$bastion_node_ip:/home/ubuntu/"

echo "$copy_jmeter_setup_command"
$copy_jmeter_setup_command
echo "$copy_key_file_command"
$copy_key_file_command
echo "$copy_connector_command"
$copy_connector_command

echo ""
echo "Running Bastion Node setup script..."
echo "============================================"
setup_bastion_node_command="ssh -i $key_file -o "StrictHostKeyChecking=no" -t ubuntu@$bastion_node_ip \
    sudo ./setup/setup-bastion.sh -r $rds_host -l $cloud_host_name"
echo "$setup_bastion_node_command"
# Handle any error and let the script continue.
$setup_bastion_node_command || echo "Remote ssh command failed."


echo ""
echo "Running performance tests..."
echo "============================================"
scp -i "$key_file" -o StrictHostKeyChecking=no run-performance-tests.sh ubuntu@"$bastion_node_ip":/home/ubuntu/workspace/jmeter
run_performance_tests_command="./workspace/jmeter/run-performance-tests.sh -p 443 ${run_performance_tests_options[@]}"
run_remote_tests="ssh -i $key_file -o "StrictHostKeyChecking=no" -t ubuntu@$bastion_node_ip $run_performance_tests_command"
echo "$run_remote_tests"
$run_remote_tests || echo "Remote test ssh command failed."

echo ""
echo "Downloading results..."
echo "============================================"
download="scp -i $key_file -o "StrictHostKeyChecking=no" ubuntu@$bastion_node_ip:/home/ubuntu/results.zip $results_dir/"
echo "$download"
$download || echo "Remote download failed"

if [[ ! -f $results_dir/results.zip ]]; then
    echo ""
    echo "Failed to download the results.zip"
    exit 0
fi

echo ""
echo "Creating summary.csv..."
echo "============================================"
cd "$results_dir"
unzip -q results.zip
wget -q http://sourceforge.net/projects/gcviewer/files/gcviewer-1.35.jar/download -O gcviewer.jar
"$results_dir"/jmeter/create-summary-csv.sh -d results -n "WSO2 Identity Server" -p wso2is -c "Heap Size" \
    -c "Concurrent Users" -r "([0-9]+[a-zA-Z])_heap" -r "([0-9]+)_users" -i -l -k 2 -g gcviewer.jar

echo "Creating summary results markdown file..."
./summary/summary-modifier.py
./jmeter/create-summary-markdown.py --json-files cf-test-metadata.json results/test-metadata.json --column-names \
    "Concurrent Users" "Throughput (Requests/sec)" "Average Response Time (ms)"

rm -rf cf-test-metadata.json cloudformation/ common/ gcviewer.jar is/ jmeter/ jtl-splitter/ netty-service/ payloads/ results/ sar/ setup/

echo ""
echo "Done."
