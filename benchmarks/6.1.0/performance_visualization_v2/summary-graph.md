# IAM Performance Test Results Comparison

During each release, we execute various automated performance test scenarios and publish the results.

| Test Scenarios                                                                              | Description                                                                                                                                                                    |
|---------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Client Credentials Grant Type                                                               | Obtain an access token using the OAuth 2.0 client credential grant type.                                                                                                       |
| OIDC Auth Code Grant Redirect With Consent                                                  | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.                                                                                      |
| OIDC Auth Code Grant Redirect Without Consent                                               | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent.                                                                      |
| OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes                    | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent. Retrieve country, email, first name and last name as user attributes. |
| OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes and Groups         | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent. Retrieve country, email, first name and last name as user attributes. |
| OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes, Groups and Roles  | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent. Retrieve country, email, first name and last name as user attributes. |
| OIDC Password Grant Type                                                                    | Obtain an access token and an id token using the OAuth 2.0 password grant type.                                                                                                |
| OIDC Password Grant Type Retrieving User Attributes.                                        | Obtain an access token and an id token using the OAuth 2.0 password grant type. Retrieve country, email, first name and last name as user attributes.                          |
| OIDC Password Grant Type Retrieving User Attributes and Groups                              | Obtain an access token and an id token using the OAuth 2.0 password grant type. Retrieve country, email, first name and last name as user attributes.                          |
| OIDC Password Grant Type Retrieving User Attributes, Groups and Roles                       | Obtain an access token and an id token using the OAuth 2.0 password grant type. Retrieve country, email, first name and last name as user attributes.                          |
| SAML2 SSO Redirect Binding                                                                  | Obtain a SAML 2 assertion response using redirect binding.                                                                                                                     |

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

| Test Parameter           | Description                                                     | Values                                                         |
|--------------------------|-----------------------------------------------------------------|----------------------------------------------------------------|
| Scenario Name            | The name of the test scenario.                                  | Refer to the above table.                                      |
| Heap Size                | The amount of memory allocated to the application               | 2G                                                             |
| Concurrent Users         | The number of users accessing the application at the same time. | 50, 100, 150, 300, 500, 1000, 1500, 2000, 2500, 3000           |
| IS Instance Type 2 Cores | The AWS EC2 instance type used to run the Identity Server.      | [**c5.large**](https://aws.amazon.com/ec2/instance-types/)     |
| IS Instance Type 4 Cores | The AWS EC2 instance type used to run the Identity Server.      | [**c5.xlarge**](https://aws.amazon.com/ec2/instance-types/)    |
| RDS Instance Type        | The AWS RDS instance type used to run the Identity Server.      | [**db.m4.2xlarge**](https://aws.amazon.com/rds/instance-types/) |
| JDK version              | The JDK version used to run the Identity Server.                | JDK 11.0.15.1                                                  |

Product Configurations: deployment.toml

```
[database.identity_db.pool_options]
maxActive = "500"

[database.shared_db.pool_options]
maxActive = "500"

[database.user.pool_options]
maxActive = "500"

[transport.https]
maxThreads = "500"
acceptCount = "500"
```

The following is the summary of performance test results collected for the measurement period.

### 1. Client Credentials Grant Type

#### Obtain an access token using the OAuth 2.0 client credential grant type.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
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

![image info](./graphs/Client_Credentials_Grant_Type/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](./graphs/Client_Credentials_Grant_Type/50_3000_lines.png)

### 2. OIDC Auth Code Grant Redirect With Consent

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.

Note: Response time is calculated only for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
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

![image info](./graphs/OIDC_Auth_Code_Grant_Redirect_With_Consent/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](./graphs/OIDC_Auth_Code_Grant_Redirect_With_Consent/50_3000_lines.png)

### 3. OIDC Auth Code Grant Redirect Without Consent (Sample Data)

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.

Note: Response time is calculated only for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
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

![image info](./graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](./graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent/50_3000_lines.png)

### 3.1. OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. Retrieve country, email, first name and last name as user attributes.

Note: Response time is calculated only for the access token endpoint request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
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

![image info](./graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_User_Attributes/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](./graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_User_Attributes/50_3000_lines.png)

### 3.2. OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes and Groups

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. Retrieve country, email, first name and last name as user attributes.

Note: Response time is calculated only for the access token endpoint request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50  | 33  | 55  | 44  | 65  | 64  |
| 100 | 35  | 53  | 45  | 66  | 64  |
| 150 | 36  | 59  | 51  | 66  | 65  |
| 300 | 44  | 83  | 54  | 95  | 88  |
| 500 | 83  | 655 | 64  | 120 | 130 |
| 1000| 1535| 4991| 135 | 191 | 189 |
| 1500| 3183| 8703| 2095| 551 | 411 |
| 2000| 4575| 13119| 4351| 1359| 1783|
| 2500| 6303| 16895| 6143| 3023| 3599|
| 3000| 7199| 25215| 8095| 6303| 4447|

<ins> Concurrency: 50 - 500 </ins>

![image info](./graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_User_Attributes_And_Groups/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](./graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_User_Attributes_And_Groups/50_3000_lines.png)


### 3.3. OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes, Groups and Roles

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. Retrieve country, email, first name and last name as user attributes.

Note: Response time is calculated only for the access token endpoint request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
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

![image info](./graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_User_Attributes_Groups_And_Roles/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](./graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_User_Attributes_Groups_And_Roles/50_3000_lines.png)

### 4. OIDC Password Grant Type

#### Obtain an access token and an id token using the OAuth 2.0 password grant type.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
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

![image info](./graphs/OIDC_Password_Grant_Type/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](./graphs/OIDC_Password_Grant_Type/50_3000_lines.png)

### 4.1. OIDC Password Grant Type Retrieving User Attributes.

#### Obtain an access token and an id token using the OAuth 2.0 password grant type. Retrieve country, email, first name and last name as user attributes.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50  | 229  | 519  | 182  | 234  | 247  |
| 100  | 495  | 1207  | 555  | 441  | 491  |
| 150  | 767  | 1943  | 891  | 839  | 739  |
| 300  | 1615  | 5023  | 1863  | 1367  | 1943  |
| 500  | 2863  | 6911  | 3087  | 2383  | 2687  |
| 1000  | 5215  | 14207  | 6015  | 5503  | 7295  |
| 1500  | 7551  | 19327  | 8575  | 9215  | 10495  |
| 2000  | 10943  | 22527  | 11775  | 14271  | 9343  |
| 2500  | 12287  | 29439  | 15871  | 17407  | 15295  |
| 3000  | 17023  | 75775  | 18175  | 19839  | 19199  |

<ins> Concurrency: 50 - 500 </ins>

![image info](./graphs/OIDC_Password_Grant_Type_User_Attributes/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](./graphs/OIDC_Password_Grant_Type_User_Attributes/50_3000_lines.png)

### 4.2. OIDC Password Grant Type Retrieving User Attributes and Groups.

#### Obtain an access token and an id token using the OAuth 2.0 password grant type. Retrieve country, email, first name and last name as user attributes.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50  | 232 | 527 | 197 | 219 | 267 |
| 100 | 497 | 1231 | 567 | 433 | 519 |
| 150 | 783 | 2015 | 867 | 655 | 775 |
| 300 | 1735 | 4447 | 1855 | 1703 | 1639 |
| 500 | 3039 | 7359 | 3135 | 2559 | 3567 |
| 1000 | 5823 | 16383 | 6047 | 6431 | 7615 |
| 1500 | 8319 | 25215 | 8447 | 9215 | 11199 |
| 2000 | 12863 | 29055 | 11903 | 14527 | 10175 |
| 2500 | 13951 | 27519 | 12543 | 14207 | 14527 |
| 3000 | 16191 | 66559 | 17919 | 19071 | 19199 |

<ins> Concurrency: 50 - 500 </ins>

![image info](./graphs/OIDC_Password_Grant_Type_User_Attributes_And_Groups/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](./graphs/OIDC_Password_Grant_Type_User_Attributes_And_Groups/50_3000_lines.png)

### 4.3. OIDC Password Grant Type Retrieving User Attributes, Groups and Roles.

#### Obtain an access token and an id token using the OAuth 2.0 password grant type. Retrieve country, email, first name and last name as user attributes.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
|---|---:|---:|---:|---:|---:|
| 50 | 232 | 527 | 197 | 219 | 267 |
| 100 | 497 | 1231| 567 | 433 | 519 |
| 150 | 783 | 2015| 867 | 655 | 775 |
| 300 | 1735| 4447| 1855| 1703| 1639|
| 500 | 3039| 7359| 3135| 2559| 3567|
| 1000 | 5823| 16383|6047 | 6431| 7615|
| 1500 | 8319| 25215|8447 | 9215| 11199|
| 2000 | 12863|29055|11903| 14527|10175|
| 2500 | 13951|27519|12543| 14207|14527|
| 3000 | 16191|66559|17919| 19071|19199|

<ins> Concurrency: 50 - 500 </ins>

![image info](./graphs/OIDC_Password_Grant_Type_User_Attributes_Groups_And_Roles/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](./graphs/OIDC_Password_Grant_Type_User_Attributes_Groups_And_Roles/50_3000_lines.png)

### 5. SAML2 SSO Redirect Binding

#### Obtain a SAML 2 assertion response using redirect binding.

Note: Response time is calculated only for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

| Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core |
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

![image info](./graphs/SAML2_SSO_Redirect_Binding/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](./graphs/SAML2_SSO_Redirect_Binding/50_3000_lines.png)
