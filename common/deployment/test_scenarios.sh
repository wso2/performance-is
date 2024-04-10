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
    [name]="00-oauth_client_credential_grant"
    [display_name]="Client Credentials Grant Type"
    [description]="Obtain an access token using the OAuth 2.0 client credential grant type."
    [jmx]="oauth/OAuth_Client_Credentials_Grant.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL PUBLISH"
)
declare -A test_scenario1=(
    [name]="01-oidc_auth_code_redirect_with_consent"
    [display_name]="OIDC Auth Code Grant Redirect With Consent"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
declare -A test_scenario2=(
    [name]="02-oidc_auth_code_redirect_with_consent_retrieve_user_attributes"
    [display_name]="OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent_Retrieve_User_Attributes.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK"
)
declare -A test_scenario03=(
    [name]="03-oidc_auth_code_redirect_with_consent_retrieve_user_attributes_and_groups"
    [display_name]="OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes and Groups"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent_Retrieve_User_Attributes_And_Groups.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK"
)
declare -A test_scenario04=(
    [name]="04-oidc_auth_code_redirect_with_consent_retrieve_user_attributes_groups_and_roles"
    [display_name]="OIDC Auth Code Grant Redirect With Consent Retrieve User Attributes Groups and Roles"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithConsent_Retrieve_User_Attributes_Groups_And_Roles.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK"
)
declare -A test_scenario05=(
    [name]="05-oidc_auth_code_redirect_without_consent"
    [display_name]="OIDC Auth Code Grant Redirect Without Consent"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code redirect without consent."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithoutConsent.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
declare -A test_scenario06=(
    [name]="06-oidc_auth_code_redirect_without_consent_retrieve_user_attributes"
    [display_name]="OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithoutConsent_Retrieve_User_Attributes.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
declare -A test_scenario07=(
    [name]="07-oidc_auth_code_redirect_without_consent_retrieve_user_attributes_and_groups"
    [display_name]="OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes and Groups"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithoutConsent_Retrieve_User_Attributes_And_Groups.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK"
)
declare -A test_scenario08=(
    [name]="08-oidc_auth_code_redirect_without_consent_retrieve_user_attributes_groups_and_roles"
    [display_name]="OIDC Auth Code Grant Redirect Without Consent Retrieve User Attributes Groups and Roles"
    [description]="Obtain an access token and an id token using the OAuth 2.0 authorization code grant type."
    [jmx]="oidc/OIDC_AuthCode_Redirect_WithoutConsent_Retrieve_User_Attributes_Groups_And_Roles.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH OIDC_AUTH_CODE_REDIRECT_WITHOUT_CONSENT_UA_GROUPS_ROLES_FLOW"
)
declare -A test_scenario09=(
    [name]="09-oidc_password_grant"
    [display_name]="OIDC Password Grant Type"
    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
    [jmx]="oidc/OIDC_Password_Grant.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
declare -A test_scenario10=(
    [name]="10-oidc_password_grant_retrieve_user_attributes"
    [display_name]="OIDC Password Grant Type Retrieve User Attributes"
    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
    [jmx]="oidc/OIDC_Password_Grant_Retrieve_User_Attributes.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK"
)
declare -A test_scenario11=(
    [name]="11-oidc_password_grant_retrieve_user_attributes_and_groups"
    [display_name]="OIDC Password Grant Type Retrieve User Attributes and Groups"
    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
    [jmx]="oidc/OIDC_Password_Grant_Retrieve_User_Attributes_And_Groups.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK"
)
declare -A test_scenario12=(
    [name]="12-oidc_password_grant_retrieve_user_attributes_groups_and_roles"
    [display_name]="OIDC Password Grant Type Retrieve User Attributes Groups and Roles"
    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
    [jmx]="oidc/OIDC_Password_Grant_Retrieve_User_Attributes_Groups_And_Roles.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK"
)
declare -A test_scenario13=(
    [name]="13-saml2_sso_redirect_binding"
    [display_name]="SAML2 SSO Redirect Binding"
    [description]="Obtain a SAML 2 assertion response using redirect binding."
    [jmx]="saml/SAML2_SSO_Redirect_Binding.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
declare -A test_scenario14=(
    [name]="14-Token_Exchange_Grant"
    [display_name]="Token Exchange Grant"
    [description]="Obtain an access token and an id token using the OAuth Token Exchange grant type."
    [jmx]="oauth/Token_Exchange_Grant.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
declare -A test_scenario15=(
    [name]="15-B2B_oidc_auth_code_redirect_with_consent"
    [display_name]="B2B OIDC Auth Code Grant Redirect With Consent"
    [description]="Obtain an access token using the OAuth 2.0 authorization code grant type as a Sub org user to a Shared App."
    [jmx]="oidc/B2B_OIDC_AuthCode_Redirect_WithConsent.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="B2B"
)
