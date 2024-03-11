# IAM Performance Test Results Comparison

During each release, we execute various automated performance test scenarios and publish the results.

| Test Scenarios                                                                                           | Description                                                                                                                                                                                                                     |
|----------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Client Credentials Grant Type                                                                            | Obtain an access token using the OAuth 2.0 client credential grant type.                                                                                                                                                        |
| OIDC Auth Code Grant Redirect With Consent                                                               | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.                                                                                                                                       |
| OIDC Auth Code Grant Redirect Without Consent                                                            | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent.                                                                                                                       |
| OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes, Groups and Roles               | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent. Retrieve country, email, first name and last name as user attributes. Additionally retrieve groups and roles as well. |
| Burst Traffic OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes, Groups and Roles | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent while 3000 burst one time traffic. Retrieve country, email, first name and last name as user attributes.               |
| Token Exchange Grant Type                                                                                | Obtain an access token and an id token using the token exchange grant type.                                                                                                                                                     |
| SAML2 SSO Redirect Binding                                                                               | Obtain a SAML 2 assertion response using redirect binding.                                                                                                                                                                      |

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
|------------------|-----------------------|-----------------|-----------------|-------------------|------------------|
| 50               | 198                   | 307             | 117             | 59                | 48               |
| 100              | 457                   | 687             | 365             | 195               | 154              |
| 150              | 719                   | 1215            | 539             | 341               | 285              |
| 300              | 1679                  | 2543            | 1471            | 1127              | 855              |
| 500              | 2287                  | 3551            | 2463            | 1983              | 1711             |
| 1000             | 3423                  | 6207            | 3823            | 3391              | 3295             |
| 1500             | 4511                  | 8639            | 5151            | 4479              | 4639             |
| 2000             | 5631                  | 11839           | 6335            | 5983              | 6047             |
| 2500             | 7039                  | 15103           | 7711            | 7551              | 6367             |
| 3000             | 8319                  | 18303           | 8959            | 8447              | 9023             |


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/Client_Credentials_Grant_Type/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/Client_Credentials_Grant_Type/50_3000_lines.png)

### 2. OIDC Auth Code Grant Redirect With Consent

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.

Note: Response time is calculated only for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|------------------|-----------------------|-----------------|-----------------|-------------------|------------------|
| 50               | 198                   | 307             | 117             | 59                | 48               |
| 100              | 457                   | 687             | 365             | 195               | 154              |
| 150              | 719                   | 1215            | 539             | 341               | 285              |
| 300              | 1679                  | 2543            | 1471            | 1127              | 855              |
| 500              | 2287                  | 3551            | 2463            | 1983              | 1711             |
| 1000             | 3423                  | 6207            | 3823            | 3391              | 3295             |
| 1500             | 4511                  | 8639            | 5151            | 4479              | 4639             |
| 2000             | 5631                  | 11839           | 6335            | 5983              | 6047             |
| 2500             | 7039                  | 15103           | 7711            | 7551              | 6367             |
| 3000             | 8319                  | 18303           | 8959            | 8447              | 9023             |


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_With_Consent/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_With_Consent/50_3000_lines.png)

### 3. OIDC Auth Code Grant Redirect Without Consent

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.

Note: Response time is calculated only for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|------------------|-----------------------|-----------------|-----------------|-------------------|------------------|
| 50               | 198                   | 307             | 117             | 59                | 48               |
| 100              | 457                   | 687             | 365             | 195               | 154              |
| 150              | 719                   | 1215            | 539             | 341               | 285              |
| 300              | 1679                  | 2543            | 1471            | 1127              | 855              |
| 500              | 2287                  | 3551            | 2463            | 1983              | 1711             |
| 1000             | 3423                  | 6207            | 3823            | 3391              | 3295             |
| 1500             | 4511                  | 8639            | 5151            | 4479              | 4639             |
| 2000             | 5631                  | 11839           | 6335            | 5983              | 6047             |
| 2500             | 7039                  | 15103           | 7711            | 7551              | 6367             |
| 3000             | 8319                  | 18303           | 8959            | 8447              | 9023             |


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent/50_3000_lines.png)


### 3.1. OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes, Groups and Roles

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. Retrieve country, email, first name and last name as user attributes.

Note: Response time is calculated only for the access token endpoint request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|------------------|-----------------------|-----------------|-----------------|-------------------|------------------|
| 50               | 198                   | 307             | 117             | 59                | 48               |
| 100              | 457                   | 687             | 365             | 195               | 154              |
| 150              | 719                   | 1215            | 539             | 341               | 285              |
| 300              | 1679                  | 2543            | 1471            | 1127              | 855              |
| 500              | 2287                  | 3551            | 2463            | 1983              | 1711             |
| 1000             | 3423                  | 6207            | 3823            | 3391              | 3295             |
| 1500             | 4511                  | 8639            | 5151            | 4479              | 4639             |
| 2000             | 5631                  | 11839           | 6335            | 5983              | 6047             |
| 2500             | 7039                  | 15103           | 7711            | 7551              | 6367             |
| 3000             | 8319                  | 18303           | 8959            | 8447              | 9023             |


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieving_User_Attributes_Groups_and_Roles/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieving_User_Attributes_Groups_and_Roles/50_3000_lines.png)


### 3.1.1. Burst Traffic OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes, Groups and Roles

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. Retrieve country, email, first name and last name as user attributes. Further, the 6th minute of the test 3000 one time burst of concurrent requests are sent.

Note: Response time is calculated only for the access token endpoint request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|------------------|-----------------------|-----------------|-----------------|-------------------|------------------|
| 50               | 198                   | 307             | 117             | 59                | 48               |
| 100              | 457                   | 687             | 365             | 195               | 154              |
| 150              | 719                   | 1215            | 539             | 341               | 285              |
| 300              | 1679                  | 2543            | 1471            | 1127              | 855              |
| 500              | 2287                  | 3551            | 2463            | 1983              | 1711             |
| 1000             | 3423                  | 6207            | 3823            | 3391              | 3295             |
| 1500             | 4511                  | 8639            | 5151            | 4479              | 4639             |
| 2000             | 5631                  | 11839           | 6335            | 5983              | 6047             |
| 2500             | 7039                  | 15103           | 7711            | 7551              | 6367             |
| 3000             | 8319                  | 18303           | 8959            | 8447              | 9023             |


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/Burst_Traffic_OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieving_User_Attributes_Groups_and_Roles/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/Burst_Traffic_OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieving_User_Attributes_Groups_and_Roles/50_3000_lines.png)


### 4. OIDC Password Grant Type

#### Obtain an access token and an id token using the OAuth 2.0 password grant type.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|------------------|-----------------------|-----------------|-----------------|-------------------|------------------|
| 50               | 198                   | 307             | 117             | 59                | 48               |
| 100              | 457                   | 687             | 365             | 195               | 154              |
| 150              | 719                   | 1215            | 539             | 341               | 285              |
| 300              | 1679                  | 2543            | 1471            | 1127              | 855              |
| 500              | 2287                  | 3551            | 2463            | 1983              | 1711             |
| 1000             | 3423                  | 6207            | 3823            | 3391              | 3295             |
| 1500             | 4511                  | 8639            | 5151            | 4479              | 4639             |
| 2000             | 5631                  | 11839           | 6335            | 5983              | 6047             |
| 2500             | 7039                  | 15103           | 7711            | 7551              | 6367             |
| 3000             | 8319                  | 18303           | 8959            | 8447              | 9023             |


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Password_Grant_Type/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Password_Grant_Type/50_3000_lines.png)


### 5. Token Exchange Grant Type

#### Obtain an access token and an id token using the token exchange grant type.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|------------------|-----------------------|-----------------|-----------------|-------------------|------------------|
| 50               | 108                   | 335             | 92              | 89                | 68               |
| 100              | 223                   | 739             | 247             | 236               | 144              |
| 150              | 347                   | 1111            | 455             | 377               | 251              |
| 300              | 799                   | 2191            | 967             | 831               | 787              |
| 500              | 1399                  | 3903            | 1639            | 1511              | 1487             |
| 1000             | 2239                  | 7487            | 2927            | 3215              | 2815             |
| 1500             | 3247                  | 11327           | 4415            | 4639              | 4351             |
| 2000             | 3711                  | 15935           | 5503            | 6207              | 6239             |
| 2500             | 4543                  | 18047           | 7423            | 7263              | 7647             |
| 3000             | 5663                  | 23935           | 8703            | 9151              | 9151             |


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/Token_Exchange_Grant_Type/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/Token_Exchange_Grant_Type/50_3000_lines.png)


### 6. SAML2 SSO Redirect Binding

#### Obtain a SAML 2 assertion response using redirect binding.

Note: Response time is calculated only for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Active-Passive 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|------------------|-----------------------|-----------------|-----------------|-------------------|------------------|
| 50               | 232                   | 551             | 207             | 234               | 257              |
| 100              | 489                   | 1327            | 591             | 445               | 495              |
| 150              | 771                   | 1895            | 827             | 663               | 743              |
| 300              | 1623                  | 4031            | 1767            | 1455              | 1543             |
| 500              | 2703                  | 7775            | 3071            | 2959              | 3391             |
| 1000             | 5823                  | 15103           | 6111            | 6463              | 7487             |
| 1500             | 8095                  | 20735           | 8959            | 8575              | 10751            |
| 2000             | 11199                 | 20863           | 11199           | 12287             | 9151             |
| 2500             | 14207                 | 36095           | 15167           | 14719             | 16511            |
| 3000             | 14975                 | 38911           | 15871           | 22271             | 17279            |


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/SAML2_SSO_Redirect_Binding/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/SAML2_SSO_Redirect_Binding/50_3000_lines.png)
