#!/bin/bash
# Copyright 2019 WSO2 Inc. (http://wso2.org)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------------
# Restart Identity Server
# ----------------------------------------------------------------------------

default_carbon_home=$(realpath ~/wso2is)
carbon_home=$default_carbon_home
default_waiting_time=100
waiting_time=$default_waiting_time
default_heap_size="4g"
heap_size="$default_heap_size"

function usage() {
    echo ""
    echo "Usage: "
    echo "$0  [-c <carbon_home>] [-w <waiting_time>]"
    echo ""
    echo "-c: The Identity server path."
    echo "-w: The waiting time in seconds until the server restart.."
    echo "-m: The heap memory size of Ballerina VM. Default: $default_heap_size."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "c:w:m:h" opts; do
    case $opts in
    c)
        carbon_home=${OPTARG}
        ;;
    w)
        waiting_time=${OPTARG}
        ;;
    m)
        heap_size=${OPTARG}
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

if [ ! -d $carbon_home ]; then
    echo "Please provide the Identity Server path."
    exit 1
fi

if [[ -z $waiting_time ]]; then
    echo "Please provide the waiting time."
    exit 1
fi

if [[ -z $heap_size ]]; then
    echo "Please provide the heap size for the Identity Server."
    exit 1
fi

echo ""
echo "Cleaning up any previous log files..."
rm -rf $carbon_home/repository/logs/*

echo "Killing All Carbon Servers..."
killall java

echo "Enabling GC Logs..."
export JAVA_OPTS="-XX:+PrintGC -XX:+PrintGCDetails -Xloggc:${carbon_home}/repository/logs/gc.log"
JAVA_OPTS+=" -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath="${carbon_home}/repository/logs/heap-dump.hprof""
export JVM_MEM_OPTS="-Xms${heap_size} -Xmx${heap_size}"
echo "JAVA_OPTS: $JAVA_OPTS"
echo "JVM_MEM_OPTS: $JVM_MEM_OPTS"

echo "Restarting identity server..."
sh $carbon_home/bin/wso2server.sh restart

echo "Waiting $waiting_time seconds..."
sleep $waiting_time

echo "Finished starting identity server..."
