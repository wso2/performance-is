#!/bin/bash -e
# Copyright 2023 WSO2, LLC. http://www.wso2.org
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
# Run Ballerina Performance Tests
# ----------------------------------------------------------------------------

declare -A test_scenario0=(
    [name]="00-authenticate_super_tenant_users"
    [display_name]="Authenticate Super Tenant User"
    [description]="Select random super tenant users and authenticate through the RemoteUserStoreManagerService."
    [jmx]="authenticate/Authenticate_Super_Tenant_User.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK"
)
declare -A test_scenario1=(
    [name]="01-oauth_auth_code_redirect_with_consent"
    [display_name]="Auth Code Grant Redirect With Consent"
    [description]="Obtain an access token using the OAuth 2.0 authorization code grant type."
    [jmx]="oauth/OAuth_AuthCode_Redirect_WithConsent.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL"
)
declare -A test_scenario2=(
    [name]="02-oauth_implicit_redirect_with_consent"
    [display_name]="Implicit Grant Redirect With Consent"
    [description]="Obtain an access token using the OAuth 2.0 implicit grant type."
    [jmx]="oauth/OAuth_Implicit_Redirect_WithConsent.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL"
)
declare -A test_scenario3=(
    [name]="03-oauth_password_grant"
    [display_name]="Password Grant Type"
    [description]="Obtain an access token using the OAuth 2.0 password grant type."
    [jmx]="oauth/OAuth_Password_Grant.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL"
)
declare -A test_scenario4=(
    [name]="04-oauth_client_credential_grant"
    [display_name]="Client Credentials Grant Type"
    [description]="Obtain an access token using the OAuth 2.0 client credential grant type."
    [jmx]="oauth/OAuth_Client_Credentials_Grant.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL PUBLISH"
)
declare -A test_scenario5=(
    [name]="05-oidc_auth_code_redirect_with_consent"
    [display_name]="OIDC Auth Code Grant Redirect With Consent"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
declare -A test_scenario6=(
    [name]="06-oidc_implicit_redirect_with_consent"
    [display_name]="OIDC Implicit Grant Redirect With Consent"
    [description]="Obtain an access token and an id token using the OAuth 2.0 implicit grant type."
    [jmx]="oidc/OIDC_Implicit_Redirect_WithConsent.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL"
)
declare -A test_scenario7=(
    [name]="07-oidc_password_grant"
    [display_name]="OIDC Password Grant Type"
    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
    [jmx]="oidc/OIDC_Password_Grant.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
declare -A test_scenario8=(
    [name]="08-oidc_request_path_authenticator"
    [display_name]="OIDC Auth Code Request Path Authenticator With Consent"
    [description]="Obtain an access token and an id token using the request path authenticator."
    [jmx]="oidc/OIDC_AuthCode_Request_Path_Authenticator_WithConsent.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL"
)
declare -A test_scenario9=(
    [name]="09-saml2_sso_redirect_binding"
    [display_name]="SAML2 SSO Redirect Binding"
    [description]="Obtain a SAML 2 assertion response using redirect binding."
    [jmx]="saml/SAML2_SSO_Redirect_Binding.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
#declare -A test_scenario10=(
#    [name]="10-oauth_auth_code_redirect_with_consent_tenant"
#    [display_name]="Auth Code Grant Redirect With Consent"
#    [description]="Obtain an access token using the OAuth 2.0 authorization code grant type."
#    [jmx]="oauth/OAuth_AuthCode_Redirect_WithConsent.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL"
#)
#declare -A test_scenario11=(
#    [name]="11-oauth_implicit_redirect_with_consent_tenant"
#    [display_name]="Implicit Grant Redirect With Consent"
#    [description]="Obtain an access token using the OAuth 2.0 implicit grant type."
#    [jmx]="oauth/OAuth_Implicit_Redirect_WithConsent.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL"
#)
#declare -A test_scenario12=(
#    [name]="12-oauth_password_grant_tenant"
#    [display_name]="Password Grant Type"
#    [description]="Obtain an access token using the OAuth 2.0 password grant type."
#    [jmx]="oauth/OAuth_Password_Grant.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL"
#)
#declare -A test_scenario13=(
#    [name]="04-oauth_client_credential_grant_tenant"
#    [display_name]="Client Credentials Grant Type"
#    [description]="Obtain an access token using the OAuth 2.0 client credential grant type."
#    [jmx]="oauth/OAuth_Client_Credentials_Grant.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL"
#)
#declare -A test_scenario14=(
#    [name]="14-oidc_auth_code_redirect_with_consent_tenant"
#    [display_name]="OIDC Auth Code Grant Redirect With Consent"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
#    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL"
#)
#declare -A test_scenario15=(
#    [name]="15-oidc_implicit_redirect_with_consent_tenant"
#    [display_name]="OIDC Implicit Grant Redirect With Consent"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 implicit grant type."
#    [jmx]="oidc/OIDC_Implicit_Redirect_WithConsent.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL"
#)
#declare -A test_scenario16=(
#    [name]="16-oidc_password_grant_tenant"
#    [display_name]="OIDC Password Grant Type"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
#    [jmx]="oidc/OIDC_Password_Grant.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL"
#)
#declare -A test_scenario17=(
#    [name]="17-oidc_request_path_authenticator_tenant"
#    [display_name]="OIDC Auth Code Request Path Authenticator With Consent"
#    [description]="Obtain an access token and an id token using the request path authenticator."
#    [jmx]="oidc/OIDC_AuthCode_Request_Path_Authenticator_WithConsent.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL"
#)
#declare -A test_scenario18=(
#    [name]="18-saml2_sso_redirect_binding_tenant"
#    [display_name]="SAML2 SSO Redirect Binding"
#    [description]="Obtain a SAML 2 assertion response using redirect binding."
#    [jmx]="saml/SAML2_SSO_Redirect_Binding.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL"
#)
declare -A test_scenario19=(
  [name]="19-oidc_device_code_grant"
  [display_name]="Device Code Grant Flow"
  [description]="Obtain an access token using the OAuth 2.0 device code grant type."
  [jmx]="oauth/OAuth_DeviceCode_Grant.jmx"
  [tenantMode]=false
  [skip]=false
  [modes]="FULL DEVICE_FLOW"
)
#declare -A test_scenario20=(
#  [name]="20-oidc_device_code_grant_tenant"
#  [display_name]="Device Code Grant Flow"
#  [description]="Obtain an access token using the OAuth 2.0 device code grant type."
#  [jmx]="oauth/OAuth_DeviceCode_Grant.jmx"
#  [tenantMode]=true
#  [skip]=true
#  [modes]="FULL DEVICE_FLOW"
#)
declare -A test_scenario21=(
    [name]="21-oauth_jwt_grant_tenant"
    [display_name]="Jwt Grant Type"
    [description]="Obtain an access token using the OAuth 2.0 jwt grant type."
    [jmx]="oauth/OAuth_Jwt_Grant.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL JWT_GRANT_FLOW PUBLISH"
)
#declare -A test_scenario22=(
#    [name]="22-oauth_jwt_grant_tenant"
#    [display_name]="Jwt Grant Type"
#    [description]="Obtain an access token using the OAuth 2.0 jwt grant type."
#    [jmx]="oauth/OAuth_Jwt_Grant.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL JWT_GRANT_FLOW"
#)
declare -A test_scenario23=(
    [name]="23-oidc_auth_code_redirect_with_consent_retrieve_user_attributes"
    [display_name]="OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent_Retrieve_User_Attributes.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
#declare -A test_scenario24=(
#    [name]="24-oidc_auth_code_redirect_with_consent_retrieve_user_attributes"
#    [display_name]="OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
#    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent_Retrieve_User_Attributes.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL QUICK"
#)
declare -A test_scenario25=(
    [name]="25-oidc_auth_code_redirect_with_consent_retrieve_user_attributes_and_groups"
    [display_name]="OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes and Groups"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent_Retrieve_User_Attributes_And_Groups.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
#declare -A test_scenario26=(
#    [name]="26-oidc_auth_code_redirect_with_consent_retrieve_user_attributes_and_groups"
#    [display_name]="OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes and Groups"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
#    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent_Retrieve_User_Attributes_And_Groups.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL QUICK"
#)
declare -A test_scenario27=(
    [name]="27-oidc_auth_code_redirect_with_consent_retrieve_user_attributes_groups_and_roles"
    [display_name]="OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes Groups and Roles"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent_Retrieve_User_Attributes_Groups_And_Roles.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
#declare -A test_scenario28=(
#    [name]="28-oidc_auth_code_redirect_with_consent_retrieve_user_attributes_groups_and_roles"
#    [display_name]="OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes Groups and Roles"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
#    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent_Retrieve_User_Attributes_Groups_And_Roles.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL QUICK"
#)
declare -A test_scenario29=(
    [name]="29-oidc_password_grant_retrieve_user_attributes"
    [display_name]="OIDC Password Grant Type Retrieve User Attributes"
    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
    [jmx]="oidc/OIDC_Password_Grant_Retrieve_User_Attributes.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
#declare -A test_scenario30=(
#    [name]="30-oidc_password_grant_retrieve_user_attributes"
#    [display_name]="OIDC Password Grant Type Retrieve User Attributes"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
#    [jmx]="oidc/OIDC_Password_Grant_Retrieve_User_Attributes.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL QUICK"
#)
declare -A test_scenario31=(
    [name]="31-oidc_password_grant_retrieve_user_attributes_and_groups"
    [display_name]="OIDC Password Grant Type Retrieve User Attributes and Groups"
    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
    [jmx]="oidc/OIDC_Password_Grant_Retrieve_User_Attributes_And_Groups.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
#declare -A test_scenario32=(
#    [name]="32-oidc_password_grant_retrieve_user_attributes_and_groups"
#    [display_name]="OIDC Password Grant Type Retrieve User Attributes and Groups"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
#    [jmx]="oidc/OIDC_Password_Grant_Retrieve_User_Attributes_And_Groups.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL QUICK"
#)
declare -A test_scenario33=(
    [name]="33-oidc_password_grant_retrieve_user_attributes_groups_and_roles"
    [display_name]="OIDC Password Grant Type Retrieve User Attributes Groups and Roles"
    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
    [jmx]="oidc/OIDC_Password_Grant_Retrieve_User_Attributes_Groups_And_Roles.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
#declare -A test_scenario34=(
#    [name]="34-oidc_password_grant_retrieve_user_attributes_groups_and_roles"
#    [display_name]="OIDC Password Grant Type Retrieve User Attributes Groups and Roles"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
#    [jmx]="oidc/OIDC_Password_Grant_Retrieve_User_Attributes_Groups_And_Roles.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL QUICK"
#)
declare -A test_scenario35=(
    [name]="35-oidc_auth_code_redirect_without_consent_retrieve_user_attributes"
    [display_name]="OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithoutConsent_Retrieve_User_Attributes.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
#declare -A test_scenario36=(
#    [name]="36-oidc_auth_code_redirect_without_consent_retrieve_user_attributes"
#    [display_name]="OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
#    [jmx]="oidc/OIDC_AuthCode_Redirect_WithoutConsent_Retrieve_User_Attributes.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL QUICK"
#)
declare -A test_scenario37=(
    [name]="37-oidc_auth_code_redirect_without_consent_retrieve_user_attributes_and_groups"
    [display_name]="OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes and Groups"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithoutConsent_Retrieve_User_Attributes_And_Groups.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
#declare -A test_scenario38=(
#    [name]="38-oidc_auth_code_redirect_without_consent_retrieve_user_attributes_and_groups"
#    [display_name]="OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes and Groups"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
#    [jmx]="oidc/OIDC_AuthCode_Redirect_WithoutConsent_Retrieve_User_Attributes_And_Groups.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL QUICK"
#)
declare -A test_scenario39=(
    [name]="39-oidc_auth_code_redirect_without_consent_retrieve_user_attributes_groups_and_roles"
    [display_name]="OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes Groups and Roles"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithoutConsent_Retrieve_User_Attributes_Groups_And_Roles.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
#declare -A test_scenario40=(
#    [name]="28-oidc_auth_code_redirect_without_consent_retrieve_user_attributes_groups_and_roles"
#    [display_name]="OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes Groups and Roles"
#    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
#    [jmx]="oidc/OIDC_AuthCode_Redirect_WithoutConsent_Retrieve_User_Attributes_Groups_And_Roles.jmx"
#    [tenantMode]=true
#    [skip]=true
#    [modes]="FULL QUICK"
#)
