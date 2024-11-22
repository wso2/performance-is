#!/bin/bash -e
# Copyright 2024 WSO2, LLC. http://www.wso2.org
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------------
# Contains common code from start-performance.sh scripts.
# ----------------------------------------------------------------------------

script_start_time=$(date +%s)
timestamp=$(date +%Y-%m-%d--%H-%M-%S)

random_number=$RANDOM

key_file=""
certificate_name=""
jmeter_setup=""
is_setup=""
default_db_username="wso2carbon"
db_username="$default_db_username"
default_db_password="wso2carbon"
db_password="$default_db_password"
default_db_storage="100"
db_storage=$default_db_storage
default_session_db_storage="100"
session_db_storage=$default_session_db_storage
default_db_instance_type=db.m6i.2xlarge
db_instance_type=$default_db_instance_type
default_is_instance_type=c5.xlarge
wso2_is_instance_type="$default_is_instance_type"
default_bastion_instance_type=c6i.xlarge
bastion_instance_type="$default_bastion_instance_type"
default_keystore_type="JKS"
keystore_type="$default_keystore_type"
default_db_type="mysql"
db_type="$default_db_type"

results_dir="$PWD/results-$timestamp"
default_minimum_stack_creation_wait_time=5
minimum_stack_creation_wait_time="$default_minimum_stack_creation_wait_time"

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -k <key_file> -c <certificate_name> -j <jmeter_setup_path> -n <IS_zip_file_path>"
    echo "   [-u <db_username>] [-p <db_password>] [-d <db_storage>] [-s <session_db_storage>] [-e <db_instance_type>]"
    echo "   [-i <wso2_is_instance_type>] [-b <bastion_instance_type>]"
    echo "   [-w <minimum_stack_creation_wait_time>] [-h]"
    echo ""
    echo "-k: The Amazon EC2 key file to be used to access the instances."
    echo "-c: The name of the IAM certificate."
    echo "-y: The token issuer type."
    echo "-q: User tag who triggered the Jenkins build"
    echo "-r: Concurrency type (50-500, 500-3000, 50-3000)"
    echo "-m: Enable burst traffic"
    echo "-j: The path to JMeter setup."
    echo "-n: The is server zip"
    echo "-u: The database username. Default: $default_db_username."
    echo "-p: The database password. Default: $default_db_password."
    echo "-d: The database storage in GB. Default: $default_db_storage."
    echo "-s: The session database storage in GB. Default: $default_session_db_storage."
    echo "-e: The database instance type. Default: $default_db_instance_type."
    echo "-i: The instance type used for IS nodes. Default: $default_is_instance_type."
    echo "-b: The instance type used for the bastion node. Default: $default_bastion_instance_type."
    echo "-w: The minimum time to wait in minutes before polling for cloudformation stack's CREATE_COMPLETE status."
    echo "    Default: $default_minimum_stack_creation_wait_time minutes."
    echo "-v: The required testing mode [FULL/QUICK]"
    echo "-h: Display this help and exit."
    echo "-g: Number of IS nodes."
    echo "-t: Keystore type. Default: $default_keystore_type."
    echo "-m: Database type. Default $default_db_type."
    echo ""
}

function execute_db_command() {

    local db_host="$1"
    local sql_file="$2"
    # Construct the database-specific command
    local db_command=""
    if [[ $db_type == "mysql" ]]; then
        db_command="mysql -h $db_host -u wso2carbon -pwso2carbon < $sql_file"
    elif [[ $db_type == "mssql" ]]; then
        db_command="sqlcmd -S $db_host -U wso2carbon -P wso2carbon -i $sql_file"
    else
        echo "Unsupported database type: $db_type"
        return 1
    fi
    ssh_bastion_cmd "$db_command"
}

while getopts "q:k:c:j:n:u:p:d:e:i:b:w:s:t:g:m:h" opts; do
    case $opts in
    q)
        user_tag=${OPTARG}
        ;;
    k)
        key_file=${OPTARG}
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
    d)
        db_storage=${OPTARG}
        ;;
    s)
        session_db_storage=${OPTARG}
        ;;
    e)
        db_instance_type=${OPTARG}
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
    t)
        keystore_type=${OPTARG}
        ;;
    g)
        no_of_nodes=${OPTARG}
        ;;
    m)
        db_type=${OPTARG}
        ;;
    h)
        usage
        exit 0
        ;;
    \?)
        echo "Invalid option: -$OPTARG"
        echo "May be needed for the perf-test script."
        ;;
    esac
done
shift "$((OPTIND - 1))"

# Define an associative array to store excluded options
declare -A excluded_options=(
  ["-i ${wso2_is_instance_type}"]=1
  ["-q ${user_tag}"]=1
)

# Create a new array to store the modified options
modified_options=()

# Iterate over the options and add them to the modified options array,
# excluding the options present in the excluded_options array
while [[ $# -gt 0 ]]; do
  option="$1"
  if [[ -z "${excluded_options[$option]}" ]]; then
    modified_options+=("$option")
  fi
  shift
done

# Pass the modified options to the command
run_performance_tests_options=("-b ${db_type} -g ${no_of_nodes} -r ${modified_options[@]}")

if [[ -z $user_tag ]]; then
    echo "Please provide the user tag."
    exit 1
fi

if [[ ! -f $key_file ]]; then
    echo "Please provide the key file."
    exit 1
fi

if [[ ${key_file: -4} != ".pem" ]]; then
    echo "AWS EC2 Key file must have .pem extension"
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

if [[ -z $is_setup ]]; then
    echo "Please provide is zip file path."
    exit 1
fi

if ! [[ $minimum_stack_creation_wait_time =~ ^[0-9]+$ ]]; then
    echo "Please provide a valid minimum time to wait before polling for cloudformation stack's CREATE_COMPLETE status."
    exit 1
fi

if [[ $no_of_nodes -eq 1 ]]; then
    no_of_nodes_string="single"
elif [[ $no_of_nodes -eq 2 ]]; then
    no_of_nodes_string="two"
elif [[ $no_of_nodes -eq 3 ]]; then
    no_of_nodes_string="three"
elif [[ $no_of_nodes -eq 4 ]]; then
    no_of_nodes_string="four"
else
    echo "Invalid value for no_of_nodes. Please provide a valid number."
    exit 1
fi

key_filename=$(basename "$key_file")
key_name=${key_filename%.*}

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
if [[ $no_of_nodes -eq 1 ]]; then
    tar -xf target/is-performance-singlenode-*.tar.gz -C "$results_dir"
else
    tar -xf target/is-performance-${no_of_nodes_string}node-cluster*.tar.gz -C "$results_dir"
fi

cp run-performance-tests.sh "$results_dir"/jmeter/
estimate_command="$results_dir/jmeter/run-performance-tests.sh -t ${run_performance_tests_options[*]}"
echo ""
echo "Estimating time for performance tests: $estimate_command"
# Estimating this script will also validate the options. It's important to validate options before creating the stack.
$estimate_command

temp_dir=$(mktemp -d)

# Get absolute paths
key_file=$(realpath "$key_file")

echo "your key is"
echo "$key_file"

ln -s "$key_file" "$temp_dir"/"$key_filename"

export AWS_DEFAULT_OUTPUT="json"

echo ""
echo "Preparing cloud formation template..."
echo "============================================"
echo "random_number: $random_number"
if [[ $no_of_nodes -eq 1 ]]; then
    template_file_name="new-single-node.yml"
    cp single-node.yaml "$template_file_name"
else
    template_file_name="new-$no_of_nodes-node-cluster.yml"
    cp "$no_of_nodes-node-cluster.yml" "$template_file_name"
fi
sed -i "s/suffix/$random_number/" "$template_file_name"

echo ""
echo "Validating stack..."
echo "============================================"
aws cloudformation validate-template --template-body "file://$template_file_name"

# Save metadata
test_parameters_json='.'
test_parameters_json+=' | .["is_nodes_ec2_instance_type"]=$is_nodes_ec2_instance_type'
test_parameters_json+=' | .["bastion_node_ec2_instance_type"]=$bastion_node_ec2_instance_type'
jq -n \
    --arg is_nodes_ec2_instance_type "$wso2_is_instance_type" \
    --arg bastion_node_ec2_instance_type "$bastion_instance_type" \
    "$test_parameters_json" > "$results_dir"/cf-test-metadata.json

stack_create_start_time=$(date +%s)
stack_name="is-performance-$no_of_nodes_string-node--$timestamp--$random_number"
create_stack_command="aws cloudformation create-stack --stack-name $stack_name \
    --template-body file://$template_file_name --parameters \
        ParameterKey=CertificateName,ParameterValue=$certificate_name \
        ParameterKey=KeyPairName,ParameterValue=$key_name \
        ParameterKey=DBUsername,ParameterValue=$db_username \
        ParameterKey=DBPassword,ParameterValue=$db_password \
        ParameterKey=DBAllocationStorage,ParameterValue=$db_storage \
        ParameterKey=DBInstanceType,ParameterValue=$db_instance_type \
        ParameterKey=DBType,ParameterValue=$db_type \
        ParameterKey=SessionDBUsername,ParameterValue=$db_username \
        ParameterKey=SessionDBPassword,ParameterValue=$db_password \
        ParameterKey=SessionDBAllocationStorage,ParameterValue=$session_db_storage \
        ParameterKey=SessionDBInstanceType,ParameterValue=$db_instance_type \
        ParameterKey=WSO2InstanceType,ParameterValue=$wso2_is_instance_type \
        ParameterKey=BastionInstanceType,ParameterValue=$bastion_instance_type \
        ParameterKey=UserTag,ParameterValue=$user_tag \
    --capabilities CAPABILITY_IAM"

echo ""
echo "Creating stack..."
echo "============================================"
echo "$create_stack_command"
stack_id="$($create_stack_command)"
stack_id=$(echo "$stack_id" | jq -r .StackId)

# Delete the stack in case of an error.
trap 'exit_handler "$results_dir" "$stack_id" "$script_start_time"' EXIT

echo ""
echo "Created stack ID: $stack_id"
rm "$template_file_name"

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

nginx_instance_ip="x.x.x.x"
if [[ $no_of_nodes -gt 1 ]]; then
    echo ""
    echo "Getting NGinx Instance Private IP..."
    nginx_instance="$(aws cloudformation describe-stack-resources --stack-name "$stack_id" --logical-resource-id WSO2NGinxInstance"$random_number" | jq -r '.StackResources[].PhysicalResourceId')"
    nginx_instance_ip="$(aws ec2 describe-instances --instance-ids "$nginx_instance" | jq -r '.Reservations[].Instances[].PrivateIpAddress')"
    echo "NGinx Instance Private IP: $nginx_instance_ip"
fi

echo ""
echo "Getting WSO2 IS Node 1 Private IP..."
wso2_is_1_ip=$(get_private_ip "$stack_id" "WSO2ISNode1AutoScalingGroup$random_number")
echo "WSO2 IS Node 1 Private IP: $wso2_is_1_ip"

wso2_is_2_ip="x.x.x.x"
if [[ $no_of_nodes -gt 1 ]]; then
    echo ""
    echo "Getting WSO2 IS Node 2 Private IP..."
    wso2_is_2_ip=$(get_private_ip "$stack_id" "WSO2ISNode2AutoScalingGroup$random_number")
    echo "WSO2 IS Node 2 Private IP: $wso2_is_2_ip"
fi

wso2_is_3_ip="x.x.x.x"
if [[ $no_of_nodes -gt 2 ]]; then
    echo ""
    echo "Getting WSO2 IS Node 3 Private IP..."
    wso2_is_3_ip=$(get_private_ip "$stack_id" "WSO2ISNode3AutoScalingGroup$random_number")
    echo "WSO2 IS Node 3 Private IP: $wso2_is_3_ip"
fi

wso2_is_4_ip="x.x.x.x"
if [[ $no_of_nodes -gt 3 ]]; then
    echo ""
    echo "Getting WSO2 IS Node 4 Private IP..."
    wso2_is_4_ip=$(get_private_ip "$stack_id" "WSO2ISNode4AutoScalingGroup$random_number")
    echo "WSO2 IS Node 4 Private IP: $wso2_is_4_ip"
fi

echo ""
echo "Getting RDS Hostname..."
rds_instance="$(aws cloudformation describe-stack-resources --stack-name "$stack_id" --logical-resource-id WSO2ISDBInstance"$random_number" | jq -r '.StackResources[].PhysicalResourceId')"
rds_host="$(aws rds describe-db-instances --db-instance-identifier "$rds_instance" | jq -r '.DBInstances[].Endpoint.Address')"
echo "RDS Hostname: $rds_host"

echo ""
echo "Getting Session DB RDS Hostname..."
session_rds_instance="$(aws cloudformation describe-stack-resources --stack-name "$stack_id" --logical-resource-id WSO2ISSessionDBInstance"$random_number" | jq -r '.StackResources[].PhysicalResourceId')"
session_rds_host="$(aws rds describe-db-instances --db-instance-identifier "$session_rds_instance" | jq -r '.DBInstances[].Endpoint.Address')"
echo "Session DB RDS Hostname: $session_rds_host"

if [[ -z $bastion_node_ip ]]; then
    echo "Bastion node IP could not be found. Exiting..."
    exit 1
fi
if [[ $no_of_nodes -gt 1 && -z $nginx_instance_ip ]]; then
    echo "Load balancer IP could not be found. Exiting..."
    exit 1
fi
if [[ $no_of_nodes -gt 1 && -z $wso2_is_1_ip ]]; then
    echo "WSO2 node 1 IP could not be found. Exiting..."
    exit 1
fi
if [[ $no_of_nodes -gt 1 && -z $wso2_is_2_ip ]]; then
    echo "WSO2 node 2 IP could not be found. Exiting..."
    exit 1
fi
if [[ $no_of_nodes -gt 2 && -z $wso2_is_3_ip ]]; then
    echo "WSO2 node 3 IP could not be found. Exiting..."
    exit 1
fi
if [[ $no_of_nodes -gt 3 && -z $wso2_is_4_ip ]]; then
    echo "WSO2 node 4 IP could not be found. Exiting..."
    exit 1
fi
if [[ -z $rds_host ]]; then
    echo "RDS host could not be found. Exiting..."
    exit 1
fi
if [[ -z $session_rds_host ]]; then
    echo "Session RDS host could not be found. Exiting..."
    exit 1
fi

echo ""
echo "Copying files to Bastion node..."
echo "============================================"
scp_r_bastion_cmd "$results_dir/setup" "/home/ubuntu/"
scp_bastion_cmd "target/is-performance-*.tar.gz" "/home/ubuntu"

scp_bastion_cmd "$jmeter_setup" "/home/ubuntu/"
scp_bastion_cmd "$is_setup" "/home/ubuntu/wso2is.zip"
scp_bastion_cmd "$key_file" "/home/ubuntu/private_key.pem"
scp_r_bastion_cmd "$results_dir/lib/*" "/home/ubuntu/"

echo ""
echo "Running Bastion Node setup script..."
echo "============================================"
if [[ $no_of_nodes -eq 1 ]]; then
    ssh_bastion_cmd "sudo ./setup/setup-bastion.sh -n $no_of_nodes -w $wso2_is_1_ip  -l $wso2_is_1_ip -r $rds_host -s $session_rds_host"
else
    ssh_bastion_cmd "sudo ./setup/setup-bastion.sh -n $no_of_nodes -w $wso2_is_1_ip -i $wso2_is_2_ip -j $wso2_is_3_ip -k $wso2_is_4_ip -r $rds_host -s $session_rds_host -l $nginx_instance_ip"
fi

if [[ $no_of_nodes -gt 3 ]]; then
    echo ""
    echo "Sleep for FD Limit"
    sleep 5m
fi

echo ""
echo "Creating databases in RDS..."
echo "============================================"
ssh_bastion_cmd "cd /home/ubuntu/ ; unzip -q wso2is.zip ; mv wso2is-* wso2is"
execute_db_command "$rds_host" "/home/ubuntu/workspace/setup/resources/$db_type/createDB.sql"

echo ""
echo "Creating session database in RDS..."
execute_db_command "$session_rds_host" "/home/ubuntu/workspace/setup/resources/$db_type/createSessionDB.sql"

if [[ $no_of_nodes -gt 1 ]]; then

    echo ""
    echo "Running IS node 1 setup script..."
    echo "============================================"
    ssh_bastion_cmd "./setup/setup-is.sh -n $no_of_nodes -m $db_type -a wso2is1 -t $keystore_type -i $wso2_is_1_ip -w $wso2_is_2_ip -j $wso2_is_3_ip -k $wso2_is_4_ip -r $rds_host -s $session_rds_host"

    echo ""
    echo "Running IS node 2 setup script..."
    echo "============================================"
    ssh_bastion_cmd "./setup/setup-is.sh -n $no_of_nodes -m $db_type -a wso2is2 -t $keystore_type -i $wso2_is_2_ip -w $wso2_is_1_ip -j $wso2_is_3_ip -k $wso2_is_4_ip -r $rds_host -s $session_rds_host"
else
    echo ""
    echo "Running IS node setup script..."
    echo "============================================"
    ssh_bastion_cmd "./setup/setup-is.sh -n $no_of_nodes -m $db_type -a wso2is -t $keystore_type -i $wso2_is_1_ip -r $rds_host  -s $session_rds_host"
fi

if [[ $no_of_nodes -gt 2 ]]; then
    echo ""
    echo "Running IS node 3 setup script..."
    echo "============================================"
    ssh_bastion_cmd "./setup/setup-is.sh -n $no_of_nodes -m $db_type -a wso2is3 -t $keystore_type -i $wso2_is_3_ip -w $wso2_is_2_ip -j $wso2_is_1_ip -k $wso2_is_4_ip -r $rds_host -s $session_rds_host"
fi

if [[ $no_of_nodes -gt 3 ]]; then
    echo ""
    echo "Running IS node 4 setup script..."
    echo "============================================"
    ssh_bastion_cmd "./setup/setup-is.sh -n $no_of_nodes -m $db_type -a wso2is4 -t $keystore_type -i $wso2_is_4_ip -w $wso2_is_3_ip -j $wso2_is_2_ip -k $wso2_is_1_ip -r $rds_host -s $session_rds_host"
fi

echo ""
echo "Running performance tests..."
echo "============================================"
scp_bastion_cmd "run-performance-tests.sh" "/home/ubuntu/workspace/jmeter"
if [[ $no_of_nodes -eq 1 ]]; then
    ssh_bastion_cmd "./workspace/jmeter/run-performance-tests.sh ${run_performance_tests_options[*]}"
else
    ssh_bastion_cmd "./workspace/jmeter/run-performance-tests.sh -p 443 ${run_performance_tests_options[*]}"
fi

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
if [[ $no_of_nodes -eq 1 ]]; then
    "$results_dir"/jmeter/create-summary-csv.sh -d results -n "WSO2 Identity Server" -p wso2is -c "Heap Size" \
        -c "Concurrent Users" -r "([0-9]+[a-zA-Z])_heap" -r "([0-9]+)_users" -i -l -k 1 -g gcviewer.jar
else
    "$results_dir"/jmeter/create-summary-csv.sh -d results -n "WSO2 Identity Server" -p wso2is -c "Heap Size" \
        -c "Concurrent Users" -r "([0-9]+[a-zA-Z])_heap" -r "([0-9]+)_users" -i -l -k 2 -g gcviewer.jar
fi

echo "Creating summary results markdown file..."

./summary/summary-modifier.py
./jmeter/create-summary-markdown.py --json-files cf-test-metadata.json results/test-metadata.json --column-names \
    "Concurrent Users" "95th Percentile of Response Time (ms)"

rm -rf cf-test-metadata.json cloudformation/ common/ gcviewer.jar is/ jmeter/ jtl-splitter/ netty-service/ payloads/ results/ sar/ setup/

echo ""
echo "Done."
