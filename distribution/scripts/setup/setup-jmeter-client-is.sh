#!/bin/bash -e
# Copyright (c) 2018, WSO2 Inc. (http://wso2.org) All Rights Reserved.
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
# Setup JMeter Client
# ----------------------------------------------------------------------------

# Make sure the script is running as root.
if [ "$UID" -ne "0" ]; then
    echo "You must be root to run $0. Try following"
    echo "sudo $0"
    exit 9
fi

export script_name="$0"
script_dir=$(dirname "$0")

alpnboot_dir="/opt/alpnboot"
mkdir -p $alpnboot_dir

$script_dir/setup-jmeter-client.sh "$@" -j bzm-http2 -j websocket-samplers \
    -w http://search.maven.org/remotecontent?filepath=org/mortbay/jetty/alpn/alpn-boot/8.1.12.v20180117/alpn-boot-8.1.12.v20180117.jar \
    -o $alpnboot_dir/alpnboot.jar
