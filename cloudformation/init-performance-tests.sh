#!/bin/bash -e
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
# Run all scripts.
# ----------------------------------------------------------------------------

# Cloud Formation parameters.
default_jdk="ORACLE_JDK8"
jdk="$default_jdk"
default_db_engine="mysql"
db_engine="$default_db_engine"
default_db_engine_version="5.6.35"
db_engine_version="$default_db_engine_version"
default_db_username="wso2carbon"
db_username="$default_db_username"
default_db_password="wso2carbon"
db_password="$default_db_password"
default_db_class=db.t2.micro
db_class="$default_db_class"
default_key_name="if-perf-test"
key_name="$default_key_name"
default_db_allocated_storage=20
db_allocated_storage="$default_db_allocated_storage"
default_instance_type=t2.micro
wso2_is_instance_type="$default_instance_type"
bastion_instance_type="$default_instance_type"
default_wso2_env_is_alb_scheme="internal"
wso2_env_is_alb_scheme="$default_wso2_env_is_alb_scheme"
alb_certificate_arn=""
aws_access_key=""
aws_access_secret=""

script_start_time=$(date +%s)
script_dir=$(dirname "$0")
results_dir="$PWD/results-$(date +%Y%m%d%H%M%S)"
is_performance_distribution=""
key_file=""
is_installer_url=""
default_minimum_stack_creation_wait_time=10
minimum_stack_creation_wait_time="$default_minimum_stack_creation_wait_time"

# todo change param names

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -f <is_performance_distribution> -k <key_file> -u <is_installer_url>"
    echo "   -arn <alb_certificate_arn> -ak <aws_access_key> -as <aws_access_secret>"
    echo "   [-n <key_name>]"
    echo "   [-dbe <db_engine>] [-dbv <db_engine_version>] [-dbc <db_class>]"
    echo "   [-dbu <db_username>] [-dbp <db_password>]"
    echo "   [-dbs <db_allocated_storage>] [-J <jdk>]"
    echo "   [-wi <wso2_is_instance_type>] [-bi <bastion_instance_type>]"
    echo "   [-s <wso2_env_is_alb_scheme>]"
    echo "   [-w <minimum_stack_creation_wait_time>]"
    echo "   [-h] -- [run_performance_tests_options]"
    echo ""
    echo "-k: The Amazon EC2 Key File."
    echo "-r: The ARN value of the load balancer certificate."
    echo "-a: The AWS access key."
    echo "-s: The AWS access secret."
    echo "-n: The Amazon EC2 Key Name. Default: $default_key_name."
    echo "-e: The database engine. Default: $default_db_engine."
    echo "-v: The database engine version. Default: $default_db_engine_version."
    echo "-c: The database instance class. Default: $default_db_class."
    echo "-u: The database username. Default: $default_db_username."
    echo "-p: The database password. Default: $default_db_password."
    echo "-S: The database allocated storage. Default: $default_db_allocated_storage GB."
    echo "-J: Preferred JDK version. Default: $default_jdk."
    echo "-i: The instance type used for IS nodes. Default: $default_instance_type."
    echo "-b: The instance type used for Bastion node. Default: $default_instance_type."
    echo "-m: Scheme for the AWS Load Balancer. Default: $default_wso2_env_is_alb_scheme."
    echo "-w: The minimum time to wait in minutes before polling for cloudformation stack's CREATE_COMPLETE status."
    echo "    Default: $default_minimum_stack_creation_wait_time."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "k:U:r:a:s:n:e:v:c:u:p:S:J:i:b:m:w:h" opts; do
    case $opts in
    k)
        key_file=${OPTARG}
        ;;
    r)
        alb_certificate_arn=${OPTARG}
        ;;
    a)
        aws_access_key=${OPTARG}
        ;;
    s)
        aws_access_secret=${OPTARG}
        ;;
    n)
        key_name=${OPTARG}
        ;;
    e)
        db_engine=${OPTARG}
        ;;
    v)
        db_engine_version=${OPTARG}
        ;;
    c)
        db_class=${OPTARG}
        ;;
    u)
        db_username=${OPTARG}
        ;;
    p)
        db_password=${OPTARG}
        ;;
    S)
        db_allocated_storage=${OPTARG}
        ;;
    J)
        jdk=${OPTARG}
        ;;
    i)
        wso2_is_instance_type=${OPTARG}
        ;;
    b)
        bastion_instance_type=${OPTARG}
        ;;
    m)
        wso2_env_is_alb_scheme=${OPTARG}
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

if [[ -z $key_name ]]; then
    echo "Please provide the EC2 Key Pair."
    exit 1
fi

if [[ -z $alb_certificate_arn ]]; then
    echo "Please provide the ARN value of the load balancer certificate."
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

if [[ -z $db_engine ]]; then
    echo "Please provide the database engine."
    exit 1
fi

if [[ -z $db_engine_version ]]; then
    echo "Please provide the database engine version."
    exit 1
fi

if [[ -z $db_class ]]; then
    echo "Please provide the database class."
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

if [[ -z $db_allocated_storage ]]; then
    echo "Please provide allocated space for the database."
    exit 1
fi

if [[ -z $jdk ]]; then
    echo "Please provide the preferred JDK."
    exit 1
fi

if [[ -z $wso2_is_instance_type ]]; then
    echo "Please provide the AWS instance type for WSO2 IS nodes."
    exit 1
fi

if [[ -z $bastion_instance_type ]]; then
    echo "Please provide the AWS instance type for bastion nodes."
    exit 1
fi

if [[ -z $wso2_env_is_alb_scheme ]]; then
    echo "Please provide the scheme for the load balancer."
    exit 1
fi

if ! [[ $minimum_stack_creation_wait_time =~ ^[0-9]+$ ]]; then
    echo "Please provide a valid minimum time to wait before polling for cloudformation stack's CREATE_COMPLETE status."
    exit 1
fi

key_filename=$(basename "$key_file")

if [[ "${key_filename%.*}" != "$key_name" ]]; then
    echo "Key file must match with the EC2 Key Pair. i.e. $key_filename should be equal to $key_name.pem."
    exit 1
fi

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

mkdir $results_dir
echo ""
echo "Results will be downloaded to $results_dir"

echo ""
echo "Extracting IS Performance Distribution to $results_dir"
tar -xf ../distribution/target/is-performance-distribution-*.tar.gz -C $results_dir

estimate_command="$results_dir/jmeter/run-performance-tests.sh -t ${run_performance_tests_options[@]}"
echo ""
echo "Estimating time for performance tests: $estimate_command"
# Estimating this script will also validate the options. It's important to validate options before creating the stack.
#$estimate_command

temp_dir=$(mktemp -d)

# Get absolute paths
key_file=$(realpath $key_file)

ln -s $key_file $temp_dir/$key_filename

cd $script_dir

echo ""
echo "Validating stack..."
#aws cloudformation validate-template --template-body file://target/cf-template.yml

stack_create_start_time=$(date +%s)
create_stack_command="aws cloudformation create-stack --stack-name is-test-stack \
    --template-body file://target/cf-template.yml --parameters \
    ParameterKey=JDK,ParameterValue=$jdk \
    ParameterKey=DBEngine,ParameterValue=$db_engine \
    ParameterKey=DBEngineVersion,ParameterValue=$db_engine_version \
    ParameterKey=DBUsername,ParameterValue=$db_username \
    ParameterKey=DBPassword,ParameterValue=$db_password \
    ParameterKey=DBClass,ParameterValue=$db_class \
    ParameterKey=EC2KeyPair,ParameterValue=$key_name \
    ParameterKey=ALBCertificateARN,ParameterValue=$alb_certificate_arn \
    ParameterKey=WSO2ISInstanceType,ParameterValue=$wso2_is_instance_type \
    ParameterKey=BastionInstanceType,ParameterValue=$bastion_instance_type \
    ParameterKey=AWSAccessKeyId,ParameterValue=$aws_access_key \
    ParameterKey=AWSAccessKeySecret,ParameterValue=$aws_access_secret \
    ParameterKey=WSO2EnvISALBScheme,ParameterValue=$wso2_env_is_alb_scheme \
    --capabilities CAPABILITY_IAM"

echo ""
echo "Creating stack..."
echo "$create_stack_command"
#stack_id="$($create_stack_command)"
#stack_id=$(echo $stack_id|jq -r .StackId)
stack_id="arn:aws:cloudformation:us-east-2:477266856205:stack/is-test-stack/75f986a0-d54f-11e8-878c-0a2103992610"

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

# Delete the stack in case of an error.
#trap exit_handler EXIT

echo ""
echo "Created stack: $stack_id"

# Sleep for sometime before waiting
# This is required since the 'aws cloudformation wait stack-create-complete' will exit with a
# return code of 255 after 120 failed checks. The command polls every 30 seconds, which means that the
# maximum wait time is one hour.
# Due to the dependencies in CloudFormation template, the stack creation may take more than one hour.
echo ""
echo "Waiting ${minimum_stack_creation_wait_time}m before polling for cloudformation stack's CREATE_COMPLETE status..."
sleep ${minimum_stack_creation_wait_time}m

echo ""
echo "Polling till the stack creation completes..."
aws cloudformation wait stack-create-complete --stack-name $stack_id
printf "Stack creation time: %s\n" "$(format_time $(measure_time $stack_create_start_time))"

echo ""
echo "Getting Bastion Node Public IP..."
bastion_node_ip="$(aws cloudformation describe-stacks --stack-name $stack_id --query 'Stacks[0].Outputs[?OutputKey==`BastionEIP`].OutputValue' --output text)"
echo "Bastion Node Public IP: $bastion_node_ip"

echo ""
echo "Getting WSO2 IS Node 1 Private IP..."
wso2_is_1_ip="$(aws cloudformation describe-stacks --stack-name $stack_id --query 'Stacks[0].Outputs[?OutputKey==`WSO2IS1PrivateIP`].OutputValue' --output text)"
echo "WSO2 IS Node 1 Private IP: $wso2_is_1_ip"

echo ""
echo "Getting WSO2 IS Node 2 Private IP..."
wso2_is_2_ip="$(aws cloudformation describe-stacks --stack-name $stack_id --query 'Stacks[0].Outputs[?OutputKey==`WSO2IS2PrivateIP`].OutputValue' --output text)"
echo "WSO2 IS Node 2 Private IP: $wso2_is_2_ip"

echo ""
echo "Getting Load Balancer Private IP..."
lb_host="$(aws cloudformation describe-stacks --stack-name $stack_id --query 'Stacks[0].Outputs[?OutputKey==`WSO2ISHostName`].OutputValue' --output text)"
echo "Load Balancer Private IP: $lb_host"

copy_bastion_setup_command_1="scp -i $key_file -o StrictHostKeyChecking=no $results_dir/setup/setup-bastion.sh ubuntu@$bastion_node_ip:/home/ubuntu/"
copy_bastion_setup_command_2="scp -i $key_file -o StrictHostKeyChecking=no $key_file ubuntu@$bastion_node_ip:/home/ubuntu/private_key.pem"
echo ""
echo "Copying Bastion Node setup script: $copy_bastion_setup_command_1"
$copy_bastion_setup_command_1
$copy_bastion_setup_command_2

setup_bastion_node_command="ssh -i $key_file -o "StrictHostKeyChecking=no" -t ubuntu@$bastion_node_ip sudo ./setup-bastion.sh -w $wso2_is_1_ip -i $wso2_is_2_ip -l $lb_host"
echo ""
echo "Running Bastion Node setup script: $setup_bastion_node_command"
# Handle any error and let the script continue.
$setup_bastion_node_command || echo "Remote ssh command failed."

run_performance_tests_command="./workspace/jmeter/run-performance-tests.sh -l $lb_host ${run_performance_tests_options[@]}"
run_remote_tests="ssh -i $key_file -o "StrictHostKeyChecking=no" -t ubuntu@$bastion_node_ip $run_performance_tests_command"
echo ""
echo "Running performance tests: $run_remote_tests"
$run_remote_tests || echo "Remote test ssh command failed."

scp -i $key_file -o "StrictHostKeyChecking=no" ubuntu@$bastion_node_ip:/home/ubuntu/results.zip $results_dir

if [[ ! -f $results_dir/results.zip ]]; then
    echo ""
    echo "Failed to download the results.zip"
    exit 500
fi

echo ""
echo "Creating summary.csv..."
cd $results_dir
unzip -q results.zip
wget -q http://sourceforge.net/projects/gcviewer/files/gcviewer-1.35.jar/download -O gcviewer.jar
.$results_dir/jmeter/create-summary-csv.sh -d results -n IS -p ballerina -j 2 -g gcviewer.jar

echo ""
echo "Converting summary results to markdown format..."
.$results_dir/jmeter/csv-to-markdown-converter.py summary.csv summary.md
