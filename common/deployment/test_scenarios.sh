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
    [modes]="FULL QUICK PUBLISH"
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
    [name]="02-oidc_password_grant"
    [display_name]="OIDC Password Grant Type"
    [description]="Obtain an access token and an id token using the OAuth 2.0 password grant type."
    [jmx]="oidc/OIDC_Password_Grant.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
declare -A test_scenario3=(
    [name]="03-saml2_sso_redirect_binding"
    [display_name]="SAML2 SSO Redirect Binding"
    [description]="Obtain a SAML 2 assertion response using redirect binding."
    [jmx]="saml/SAML2_SSO_Redirect_Binding.jmx"
    [tenantMode]=false
    [skip]=false
    [modes]="FULL QUICK PUBLISH"
)
