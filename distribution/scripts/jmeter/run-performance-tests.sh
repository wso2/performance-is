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
# Run Ballerina Performance Tests
# ----------------------------------------------------------------------------

script_dir=$(dirname "$0")

wso2is_1_host_alias=wso2is1
wso2is_2_host_alias=wso2is2
lb_ssh_host_alias=loadbalancer
rds_ssh_host_alias=rds
db_username="wso2carbon"
db_password="wso2carbon"

# Execute common script
. $script_dir/perf-test-is.sh

declare -A test_scenario0=(
    [name]="authenticate_super_tenant_users"
    [jmx]="authenticate/Authenticate_Super_Tenant_User.jmx"
    [skip]=false
)
declare -A test_scenario1=(
    [name]="authenticate_tenant_users"
    [jmx]="authenticate/Authenticate_Tenant_User.jmx"
    [skip]=false
)
declare -A test_scenario2=(
    [name]="oauth_auth_code_redirect_with_consent"
    [jmx]="oauth/OAuth_AuthCode_Redirect_WithConsent.jmx"
    [skip]=false
)
declare -A test_scenario3=(
    [name]="oauth_implicit_redirect_with_consent"
    [jmx]="oauth/OAuth_Implicit_Redirect_WithConsent.jmx"
    [skip]=false
)
declare -A test_scenario4=(
    [name]="oauth_password_grant"
    [jmx]="oauth/OAuth_Password_Grant.jmx"
    [skip]=false
)
declare -A test_scenario5=(
    [name]="oauth_client_credential_grant"
    [jmx]="oauth/OAuth_Client_Credentials_Grant.jmx"
    [skip]=false
)
declare -A test_scenario6=(
    [name]="oidc_auth_code_redirect_with_consent"
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent.jmx"
    [skip]=false
)
declare -A test_scenario7=(
    [name]="oidc_implicit_redirect_with_consent"
    [jmx]="oidc/OIDC_Implicit_Redirect_WithConsent.jmx"
    [skip]=false
)
declare -A test_scenario8=(
    [name]="oidc_password_grant"
    [jmx]="oidc/OIDC_Password_Grant.jmx"
    [skip]=false
)
declare -A test_scenario9=(
    [name]="oidc_request_path_authenticator"
    [jmx]="oidc/OIDC_AuthCode_Request_Path_Authenticator_WithConsent.jmx"
    [skip]=false
)
declare -A test_scenario10=(
    [name]="saml2_sso_redirect_binding"
    [jmx]="saml/SAML2_SSO_Redirect_Binding.jmx"
    [skip]=false
)
declare -A test_scenario11=(
    [name]="saml2_sso_request_path_authentication"
    [jmx]="saml/SAML2_SSO_Request_Path_Authentication.jmx"
    [skip]=false
)

function before_execute_test_scenario() {

    ssh $wso2is_1_host_alias "sudo -u wso2user ./restart-is.sh"
    ssh $wso2is_2_host_alias "sudo -u wso2user ./restart-is.sh"
    jmeter_params+=("port=443")

    echo "Cleaning databases..."
    rds_host=$(get_ssh_hostname $rds_ssh_host_alias)
    mysql -u $db_username -h $rds_host -p$db_password < workspace/is/clean-database.sql
}

function after_execute_test_scenario() {

#    todo check on ballerina.*/bre
    write_server_metrics $wso2is_1_host_alias $wso2is_1_host_alias ballerina.*/bre
    download_file "$wso2is_1_host_alias" /mnt/wso2is-*/repository/logs/wso2carbon.log "$wso2is_1_host_alias.log"
    download_file "$wso2is_1_host_alias" /mnt/wso2is-*/repository/logs/gc.log "$wso2is_1_host_alias-gc.log"
    download_file "$wso2is_1_host_alias" /mnt/wso2is-*/repository/logs/heap-dump.hprof "$wso2is_1_host_alias-heap-dump.hprof"

    write_server_metrics $wso2is_2_host_alias $wso2is_2_host_alias ballerina.*/bre
    download_file "$wso2is_2_host_alias" /mnt/wso2is-*/repository/logs/wso2carbon.log "$wso2is_2_host_alias.log"
    download_file "$wso2is_2_host_alias" /mnt/wso2is-*/repository/logs/gc.log "$wso2is_2_host_alias-gc.log"
    download_file "$wso2is_2_host_alias" /mnt/wso2is-*/repository/logs/heap-dump.hprof "$wso2is_2_host_alias-heap-dump.hprof"
}

test_scenarios
