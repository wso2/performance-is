# IAM Performance Test Results Comparison

During each release, we execute various automated performance test scenarios and publish the results.

| Test Scenarios                                                                                           | Description                                                                                                                                                                                                       |
|----------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Client Credentials Grant Type                                                                            | Obtain an access token using the OAuth 2.0 client credential grant type.                                                                                                                                          |
| OIDC Auth Code Grant Redirect With Consent                                                               | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.                                                                                                                         |
| OIDC Auth Code Grant Redirect Without Consent                                                            | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent.                                                                                                         |
| OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes                                 | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent. Retrieve country, email, first name and last name as user attributes.                                   |
| OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes, Groups and Roles               | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent. Retrieve country, email, first name and last name as user attributes.                                   |
| Burst Traffic OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes, Groups and Roles | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent while 3000 burst one time traffic. Retrieve country, email, first name and last name as user attributes. |
| Token Exchange Grant Type                                                                                | Obtain an access token and an id token using the token exchange grant type.                                                                                                                                       |
| SAML2 SSO Redirect Binding                                                                               | Obtain a SAML 2 assertion response using redirect binding.                                                                                                                                                        |

Our test client is [Apache JMeter](https://jmeter.apache.org/index.html). We test each scenario for a fixed duration of
time and split the test results into warm-up and measurement parts and use the measurement part to compute the
performance metrics. For this particular instance, the duration of each test is **15 minutes** and the warm-up period is **5 minutes**.

We run the performance tests under different numbers of concurrent users and heap sizes to gain a better understanding on how the server reacts to different loads.

The main performance metrics:

1. **Response Time**: The end-to-end latency for a given operation of the WSO2 Identity Server. The complete distribution of response times was recorded.

The following are the test specifications.

| Test Specification       | Description                                                 | Values                                                          |
|--------------------------|-------------------------------------------------------------|-----------------------------------------------------------------|
| No of Users              | The number of users created for the test cases              | 1000                                                            |
| No of OAuth Applications | The number of OAuth applications created for the test cases | 1000                                                            |
| No of SAML Applications  | The number of SAML applications created for the test cases  | 1000                                                            |
| Token Issuer             | Token issuer type                                           | JWT                                                             |

The following are the test parameters.

| Test Parameter                    | Description                                                                                                       | Values                                                          |
|-----------------------------------|-------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------|
| Scenario Name                     | The name of the test scenario.                                                                                    | Refer to the above table.                                       |
| Heap Size                         | The amount of memory allocated to the application                                                                 | 2G                                                              |
| Concurrent Users                  | The number of users accessing the application at the same time.                                                   | 50, 100, 150, 300, 500, 1000, 1500, 2000, 2500, 3000            |
| IS Instance Type 2 Cores          | The AWS EC2 instance type used to run the Identity Server.                                                        | [**c5.large**](https://aws.amazon.com/ec2/instance-types/)      |
| IS Instance Type 4 Cores          | The AWS EC2 instance type used to run the Identity Server.                                                        | [**c5.xlarge**](https://aws.amazon.com/ec2/instance-types/)     |
| RDS Instance Type                 | The AWS RDS instance type used to run the Identity Server.                                                        | [**db.m4.2xlarge**](https://aws.amazon.com/rds/instance-types/) |
| RDS Instance max_connections      | The AWS RDS max_connections metric monitors the set maximum number of (allowed) simultaneous client connections.  | 2500                                                            |
| JDK version                       | The JDK version used to run the Identity Server.                                                                  | JDK 11.0.15.1                                                   |

Product Configurations: deployment.toml

```
[user_store.properties]
CaseInsensitiveUsername = false
SCIMEnabled=true
IsBulkImportSupported=false

[database.identity_db.pool_options]
maxActive = "400"

[database.shared_db.pool_options]
maxActive = "400"

[database.user.pool_options]
maxActive = "400"

[transport.https]
maxThreads = "400"
acceptCount = "400"
```

The following is the summary of performance test results collected for the measurement period.

### 1. Client Credentials Grant Type

#### Obtain an access token using the OAuth 2.0 client credential grant type.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50 | 88 | 307 | 117 | 59 | 48 |
| 100 | 192 | 687 | 365 | 195 | 154 |
| 150 | 307 | 1215 | 539 | 341 | 285 |
| 300 | 631 | 2543 | 1471 | 1127 | 855 |
| 500 | 1015 | 3551 | 2463 | 1983 | 1711 |
| 1000 | 1679 | 6207 | 3823 | 3391 | 3295 |
| 1500 | 2335 | 8639 | 5151 | 4479 | 4639 |
| 2000 | 2911 | 11839 | 6335 | 5983 | 6047 |
| 2500 | 3551 | 15103 | 7711 | 7551 | 6367 |
| 3000 | 4047 | 18303 | 8959 | 8447 | 9023 |

<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/Client_Credentials_Grant_Type/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/Client_Credentials_Grant_Type/50_3000_lines.png)

### 2. OIDC Auth Code Grant Redirect With Consent

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.

Note: Response time is calculated only for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50 | 12 | 14 | 13 | 81 | 72 |
| 100 | 51 | 51 | 48 | 77 | 68 |
| 150 | 50 | 50 | 46 | 72 | 64 |
| 300 | 50 | 53 | 48 | 73 | 81 |
| 500 | 52 | 67 | 53 | 82 | 142 |
| 1000 | 56 | 110 | 60 | 95 | 176 |
| 1500 | 118 | 3375 | 105 | 163 | 214 |
| 2000 | 1807 | 7231 | 583 | 363 | 317 |
| 2500 | 2703 | 10943 | 2847 | 1711 | 555 |
| 3000 | 3679 | 15551 | 4927 | 3183 | 1175 |

<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_With_Consent/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_With_Consent/50_3000_lines.png)

### 3. OIDC Auth Code Grant Redirect Without Consent (Sample Data)

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.

Note: Response time is calculated only for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50 | 12 | 14 | 13 | 81 | 72 |
| 100 | 51 | 51 | 48 | 77 | 68 |
| 150 | 50 | 50 | 46 | 72 | 64 |
| 300 | 50 | 53 | 48 | 73 | 81 |
| 500 | 52 | 67 | 53 | 82 | 142 |
| 1000 | 56 | 110 | 60 | 95 | 176 |
| 1500 | 118 | 3375 | 105 | 163 | 214 |
| 2000 | 1807 | 7231 | 583 | 363 | 317 |
| 2500 | 2703 | 10943 | 2847 | 1711 | 555 |
| 3000 | 3679 | 15551 | 4927 | 3183 | 1175 |

<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent/50_3000_lines.png)

### 3.1. OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. Retrieve country, email, first name and last name as user attributes.

Note: Response time is calculated only for the access token endpoint request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50  | 39  | 46  | 43  | 61  | 63  |
| 100 | 40  | 50  | 48  | 65  | 62  |
| 150 | 42  | 55  | 47  | 65  | 64  |
| 300 | 46  | 75  | 54  | 83  | 85  |
| 500 | 67  | 443 | 62  | 108 | 130 |
| 1000| 1423| 7519| 140 | 172 | 185 |
| 1500| 3471| 8319| 1439| 431 | 433 |
| 2000| 4575| 14655| 4191| 1511| 1567|
| 2500| 6591| 19199| 5951| 3327| 3279|
| 3000| 8255| 29567| 7935| 5887| 3711|

<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_User_Attributes/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_User_Attributes/50_3000_lines.png)


### 3.2. OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes, Groups and Roles

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. Retrieve country, email, first name and last name as user attributes.

Note: Response time is calculated only for the access token endpoint request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50  | 44  | 53  | 42  | 40  | 42  |
| 100 | 45  | 58  | 46  | 42  | 42  |
| 150 | 47  | 62  | 50  | 43  | 48  |
| 300 | 52  | 88  | 57  | 57  | 51  |
| 500 | 63  | 497 | 63  | 82  | 65  |
| 1000| 1863| 5983| 161 | 175 | 134 |
| 1500| 2671| 12863| 2079| 427 | 397 |
| 2000| 3967| 11071| 4735| 1575| 1823|
| 2500| 6815| 19583| 7391| 3247| 3311|
| 3000| 6687| 20735| 8063| 5695| 3999|

<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_User_Attributes_Groups_And_Roles/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_User_Attributes_Groups_And_Roles/50_3000_lines.png)


### 3.2.1. Burst Traffic OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes, Groups and Roles

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. Retrieve country, email, first name and last name as user attributes. Further, the 6th minute of the test 3000 one time burst of concurrent requests are sent.

Note: Response time is calculated only for the access token endpoint request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50  | 3567  | 7615  | 2239  | 307  | 235  |
| 100 | 4255  | 7359  | 1623  | 207  | 301  |
| 150 | 4015  | 7007  | 1935  | 655  | 429  |
| 300 | 3935  | 7743  | 2047  | 429  | 421  |
| 500 | 3775  | 9279 | 2319  | 503  | 935  |
| 1000| 5759| 18303| 2975 | 639 | 467 |
| 1500| 7103| 17151| 6527| 2143 | 2383 |
| 2000| 10431| 29183| 7519| 2319| 6655|
| 2500| 8383| 21119| 9535| 4863| 9087|
| 3000| 10879| 34815| 12351| 7359| 11775|

<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/3000_Burst_OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieve_User_Attributes_Groups_and_Roles/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/3000_Burst_OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieve_User_Attributes_Groups_and_Roles/50_3000_lines.png)


### 4. OIDC Password Grant Type

#### Obtain an access token and an id token using the OAuth 2.0 password grant type.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50 | 176 | 449 | 188 | 82 | 70 |
| 100 | 391 | 911 | 463 | 244 | 151 |
| 150 | 599 | 1423 | 635 | 501 | 283 |
| 300 | 1255 | 2847 | 1415 | 935 | 863 |
| 500 | 2079 | 4607 | 2399 | 1903 | 1927 |
| 1000 | 4127 | 9215 | 4575 | 4799 | 3279 |
| 1500 | 5183 | 13631 | 6591 | 5983 | 6571 |
| 2000 | 6559 | 17791 | 7775 | 8703 | 7615 |
| 2500 | 8127 | 23167 | 10815 | 11583 | 10559 |
| 3000 | 9791 | 27903 | 12927 | 12671 | 12223 |

<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Password_Grant_Type/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Password_Grant_Type/50_3000_lines.png)


### 5. Token Exchange Grant Type

#### Obtain an access token and an id token using the token exchange grant type.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50 | 108 | 335 | 92 | 89 | 68 |
| 100 | 223 | 739 | 247 | 236 | 144 |
| 150 | 347 | 1111 | 455 | 377 | 251 |
| 300 | 799 | 2191 | 967 | 831 | 787 |
| 500 | 1399 | 3903 | 1639 | 1511 | 1487 |
| 1000 | 2239 | 7487 | 2927 | 3215 | 2815 |
| 1500 | 3247 | 11327 | 4415 | 4639 | 4351 |
| 2000 | 3711 | 15935 | 5503 | 6207 | 6239 |
| 2500 | 4543 | 18047 | 7423 | 7263 | 7647 |
| 3000 | 5663 | 23935 | 8703 | 9151 | 9151 |

<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/Token_Exchange_Grant/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/Token_Exchange_Grant/50_3000_lines.png)


### 6. SAML2 SSO Redirect Binding

#### Obtain a SAML 2 assertion response using redirect binding.

Note: Response time is calculated only for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50  | 232 | 551  | 207  | 234  | 257  |
| 100 | 489 | 1327 | 591  | 445  | 495  |
| 150 | 771 | 1895 | 827  | 663  | 743  |
| 300 |1623 | 4031 | 1767 | 1455 | 1543 |
| 500 |2703 | 7775 | 3071 | 2959 | 3391 |
| 1000|5823 |15103 | 6111 | 6463 | 7487 |
| 1500|8095 |20735 | 8959 | 8575 |10751 |
| 2000|11199|20863 |11199 |12287 | 9151 |
| 2500|14207|36095 |15167 |14719 |16511 |
| 3000|14975|38911 |15871 |22271 |17279 |

<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/SAML2_SSO_Redirect_Binding/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/SAML2_SSO_Redirect_Binding/50_3000_lines.png)
