#!/usr/bin/env bash
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
# Setup the bastion node to be used as the JMeter client.
# ----------------------------------------------------------------------------

carbon_home=$(realpath "/etc/puppet/code/environments/production/modules/is570/templates/carbon-home")

sudo sed -i 's/CaseInsensitiveUsername">true/CaseInsensitiveUsername">false/' $carbon_home/repository/conf/user-mgt.xml.erb
sudo sed -i 's/<maxActive>50</<maxActive>300</' $carbon_home/repository/conf/datasources/master-datasources.xml.erb
sudo sed -i 's/maxThreads="250"/maxThreads="500"/' $carbon_home/repository/conf/tomcat/catalina-server.xml.erb
sudo sed -i 's/acceptCount="200"/acceptCount="500"/' $carbon_home/repository/conf/tomcat/catalina-server.xml.erb
sudo sed -i 's/<EnableSSOConsentManagement>true</<EnableSSOConsentManagement>false</' $carbon_home/repository/conf/identity/identity.xml.erb
