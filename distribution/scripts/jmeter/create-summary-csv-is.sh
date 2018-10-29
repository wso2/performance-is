#!/bin/bash
# Copyright 2018 WSO2 Inc. (http://wso2.org)
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
# Create a summary report from JMeter results
# ----------------------------------------------------------------------------

script_dir=$(dirname "$0")
# Application Name to be used in column headers
application_name=""
# Results directory
default_results_dir="${script_dir}/results"
results_dir="$default_results_dir"
# GCViewer Jar file to analyze GC logs
gcviewer_jar_path=""
# JMeter Servers
# If jmeter_servers = 1, only client was used. If jmeter_servers > 1, remote JMeter servers were used.
default_jmeter_servers=1
jmeter_servers=$default_jmeter_servers
# Use warmup results
use_warmup=false
# Include GC statistics and load averages for other servers
include_all=false
is_1_file_prefix=wso2is1
is_2_file_prefix=wso2is2

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 -n <application_name> [-g <gcviewer_jar_path>] [-d <results_dir>]"
    echo "   [-j <jmeter_servers>] [-w] [-i] [-h]"
    echo ""
    echo "-n: Name of the application to be used in column headers."
    echo " p: Prefix of the files to get metrics (Load Average, GC, etc)."
    echo "-g: Path of GCViewer Jar file, which will be used to analyze GC logs."
    echo "-d: Results directory. Default $default_results_dir."
    echo "-j: Number of JMeter servers. If n=1, only client was used. If n > 1, remote JMeter servers were used. Default $default_jmeter_servers."
    echo "-w: Use warmup results instead of measurement results."
    echo "-i: Include GC statistics and load averages for other servers."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "n:p:g:d:j:wih" opts; do
    case $opts in
    n)
        application_name=${OPTARG}
        ;;
    g)
        gcviewer_jar_path=${OPTARG}
        ;;
    d)
        results_dir=${OPTARG}
        ;;
    j)
        jmeter_servers=${OPTARG}
        ;;
    w)
        use_warmup=true
        ;;
    i)
        include_all=true
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

# Validate options
if [[ -z $application_name ]]; then
    echo "Please specify the application name."
    exit 1
fi

if [[ ! -d $results_dir ]]; then
    echo "Please specify the results directory."
    exit 1
fi

if [[ ! -f $gcviewer_jar_path ]]; then
    echo "Please specify the path to GCViewer JAR file."
    exit 1
fi

if [[ -z $jmeter_servers ]]; then
    echo "Please specify the number of JMeter servers."
    exit 1
fi

function get_gc_headers() {
    echo -ne ",$1 GC Throughput (%),$1 Footprint (M),$1 Average of Footprint After Full GC (M)"
    echo -ne ",$1 Standard Deviation of Footprint After Full GC (M)"
}

function get_loadavg_headers() {
    echo -ne ",$1 Load Average - Last 1 minute,$1 Load Average - Last 5 minutes,$1 Load Average - Last 15 minutes"
}

# Output file name
filename="summary.csv"

if [[ -f $filename ]]; then
    echo "$filename already exists"
    exit 1
fi

# Create file and save headers
echo -n "Scenario Name","Heap Size","Concurrent Users", >$filename
echo -n "# Samples","Error Count","Error %","Average (ms)","Standard Deviation (ms)","Min (ms)","Max (ms)", >>$filename
echo -n "75th Percentile (ms)","90th Percentile (ms)","95th Percentile (ms)","98th Percentile (ms)", >>$filename
echo -n "99th Percentile (ms)","99.9th Percentile (ms)","Throughput (Requests/sec)", >>$filename
echo -n "Received (KB/sec)","Sent (KB/sec)" >>$filename
#echo -n $(get_gc_headers "${application_name}") >>$filename
echo -n $(get_gc_headers "IS Server 1") >>$filename
echo -n $(get_gc_headers "IS Server 2") >>$filename
if [ "$include_all" = true ]; then
    echo -n $(get_gc_headers "JMeter Server") >>$filename
fi
#echo -n $(get_loadavg_headers "${application_name}") >>$filename
echo -n $(get_loadavg_headers "IS Server 1") >>$filename
echo -n $(get_loadavg_headers "IS Server 2") >>$filename
if [ "$include_all" = true ]; then
    echo -n $(get_loadavg_headers "JMeter Server") >>$filename
fi
echo -ne "\r\n" >>$filename

function write_column() {
    local data_file="$1"
    local name="$2"
    echo -n "," >>$filename
    echo -n "$(jq -r ".$name" "$data_file")" >>$filename
}

function get_value_from_gc_summary() {
    echo $(grep -m 1 $2\; $1 | sed -r 's/.*\;(.*)\;.*/\1/' | sed 's/,//g')
}

function write_gc_summary_details() {
    echo "writing gc summary details for $1"
    local gc_log_file="${current_dir}/$1-gc.log"
    if [[ -f $gc_log_file ]]; then
        local gc_summary_file="/tmp/gc.txt"
        echo "Reading $gc_log_file"
        java -Xms128m -Xmx128m -jar $gcviewer_jar_path $gc_log_file $gc_summary_file -t SUMMARY &>/dev/null
        echo -n ",$(get_value_from_gc_summary $gc_summary_file throughput)" >>$filename
        echo -n ",$(get_value_from_gc_summary $gc_summary_file footprint)" >>$filename
        echo -n ",$(get_value_from_gc_summary $gc_summary_file avgfootprintAfterFullGC)" >>$filename
        echo -n ",$(get_value_from_gc_summary $gc_summary_file avgfootprintAfterFullGCσ)" >>$filename
    else
        echo -n ",N/A,N/A,N/A,N/A" >>$filename
    fi
}

function write_loadavg_details() {
    local loadavg_file="${current_dir}/$1_loadavg.txt"
    if [[ -f $loadavg_file ]]; then
        echo "Reading $loadavg_file"
        local loadavg_values=$(tail -2 $loadavg_file | head -1)
        declare -a loadavg_array=($loadavg_values)
        echo -n ",${loadavg_array[3]}" >>$filename
        echo -n ",${loadavg_array[4]}" >>$filename
        echo -n ",${loadavg_array[5]}" >>$filename
    else
        echo -n ",N/A,N/A,N/A" >>$filename
    fi
}

# Results are in following directory structure:
# results/${scenario_name}/${heap}_heap/${concurrent_users}__users

for scenario_dir in $(find ${results_dir} -maxdepth 1 -type d | sort -V); do
    for heap_size_dir in $(find ${scenario_dir} -maxdepth 1 -type d -name '*_heap' | sort -V); do
        for concurrency_dir in $(find ${heap_size_dir} -maxdepth 1 -type d -name '*_users' | sort -V); do
            current_dir="${concurrency_dir}"
            echo "Current directory: $current_dir."
            data_file="${current_dir}/results-measurement-summary.json"
            if [[ $use_warmup == true ]]; then
                data_file="${current_dir}/results-warmup-summary.json"
            fi
            if [[ ! -f $data_file ]]; then
                echo "WARN: Data file not found: $data_file"
                continue
            fi

            echo "Getting data from $data_file"
            echo $scenario_dir
            scenario_name="$(echo $scenario_dir | sed -nE 's/.*.\/(.*)/\1/p')"
            echo $scenario_name
            heap_size=$(echo $heap_size_dir | sed -nE 's/.*.\/([0-9]+[a-zA-Z])_heap.*/\1/p')
            concurrent_users=$(echo $concurrency_dir | sed -nE 's/.*\/([0-9]+)_users.*/\1/p')

            echo -n "$scenario_name,$heap_size,$concurrent_users" >>$filename
            write_column "${data_file}" "samples"
            write_column "${data_file}" "errors"
            write_column "${data_file}" "errorPercentage"
            write_column "${data_file}" "mean"
            write_column "${data_file}" "stddev"
            write_column "${data_file}" "min"
            write_column "${data_file}" "max"
            write_column "${data_file}" "p75"
            write_column "${data_file}" "p90"
            write_column "${data_file}" "p95"
            write_column "${data_file}" "p98"
            write_column "${data_file}" "p99"
            write_column "${data_file}" "p999"
            write_column "${data_file}" "throughput"
            write_column "${data_file}" "receivedKBytesRate"
            write_column "${data_file}" "sentKBytesRate"

            write_gc_summary_details $is_1_file_prefix
            write_gc_summary_details $is_2_file_prefix
            if [ "$include_all" = true ]; then
                write_gc_summary_details jmeter
            fi

            write_loadavg_details $is_1_file_prefix
            write_loadavg_details $is_2_file_prefix
            if [ "$include_all" = true ]; then
                write_loadavg_details jmeter
            fi

            echo -ne "\r\n" >>$filename
        done
    done
done
echo "Wrote summary statistics to $filename."
