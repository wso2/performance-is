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

wso2is_host_alias=wso2is
lb_ssh_host_alias=loadbalancer
rds_ssh_host_alias=rds
db_username="wso2carbon"
db_password="wso2carbon"

# Execute common script
. $script_dir/perf-test-is.sh

declare -A test_scenario0=(
    [name]="00-authenticate_super_tenant_users"
    [display_name]="Authenticate Super Tenant User"
    [description]="Select random super tenant users and authenticate through the RemoteUserStoreManagerService."
    [jmx]="authenticate/Authenticate_Super_Tenant_User.jmx"
    [skip]=false
)
declare -A test_scenario1=(
    [name]="01-oauth_auth_code_redirect_with_consent"
    [display_name]="Auth Code Grant Redirect With Consent"
    [description]="Obtain an access token using the OAuth 2.0 authorization code grant type."
    [jmx]="oauth/OAuth_AuthCode_Redirect_WithConsent.jmx"
    [skip]=false
)
declare -A test_scenario2=(
    [name]="02-oauth_implicit_redirect_with_consent"
    [display_name]="Implicit Grant Redirect With Consent"
    [description]="Obtain an access token using the OAuth 2.0 implicit grant type."
    [jmx]="oauth/OAuth_Implicit_Redirect_WithConsent.jmx"
    [skip]=false
)
declare -A test_scenario3=(
    [name]="03-oauth_password_grant"
    [display_name]="Password Grant Type"
    [description]="Obtain an access token using the OAuth 2.0 password grant type."
    [jmx]="oauth/OAuth_Password_Grant.jmx"
    [skip]=false
)
declare -A test_scenario4=(
    [name]="04-oauth_client_credential_grant"
    [display_name]="Client Credentials Grant Type"
    [description]="Obtain an access token using the OAuth 2.0 client credential grant type."
    [jmx]="oauth/OAuth_Client_Credentials_Grant.jmx"
    [skip]=false
)
declare -A test_scenario5=(
    [name]="05-oidc_auth_code_redirect_with_consent"
    [display_name]="OIDC Auth Code Grant Redirect With Consent"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent.jmx"
    [skip]=false
)
declare -A test_scenario6=(
    [name]="06-oidc_implicit_redirect_with_consent"
    [display_name]="OIDC Implicit Grant Redirect With Consent"
    [description]="Obtain an access token and an id token using the OAuth 2.0 implicit grant type."
    [jmx]="oidc/OIDC_Implicit_Redirect_WithConsent.jmx"
    [skip]=false
)
declare -A test_scenario7=(
    [name]="07-oidc_password_grant"
    [display_name]="OIDC Password Grant Type"
    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
    [jmx]="oidc/OIDC_Password_Grant.jmx"
    [skip]=false
)
declare -A test_scenario8=(
    [name]="08-oidc_request_path_authenticator"
    [display_name]="OIDC Auth Code Request Path Authenticator With Consent"
    [description]="Obtain an access token and an id token using the request path authenticator."
    [jmx]="oidc/OIDC_AuthCode_Request_Path_Authenticator_WithConsent.jmx"
    [skip]=false
)
declare -A test_scenario9=(
    [name]="09-saml2_sso_redirect_binding"
    [display_name]="SAML2 SSO Redirect Binding"
    [description]="Obtain a SAML 2 assertion response using redirect binding."
    [jmx]="saml/SAML2_SSO_Redirect_Binding.jmx"
    [skip]=false
)

function before_execute_test_scenario() {

    ssh $wso2is_host_alias "./restart-is.sh -m $heap"
    jmeter_params+=("port=9443")

    echo "Cleaning databases..."
    rds_host=$(get_ssh_hostname $rds_ssh_host_alias)
    mysql -u $db_username -h "$rds_host" -p$db_password < /home/ubuntu/workspace/is/clean-database.sql
}

function after_execute_test_scenario() {

    is_home="/home/ubuntu/wso2is"
    write_server_metrics $wso2is_host_alias $wso2is_host_alias
    download_file "$wso2is_host_alias" $is_home/repository/logs/wso2carbon.log "$wso2is_host_alias.log"
    download_file "$wso2is_host_alias" $is_home/repository/logs/gc.log $wso2is_host_alias"_gc.log"
    download_file "$wso2is_host_alias" $is_home/repository/logs/heap-dump.hprof "$wso2is_host_alias-heap-dump.hprof"
}

test_scenarios
