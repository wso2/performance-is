# IAM Performance Test Results Comparison

During each release, we execute various automated performance test scenarios and publish the results.

| Test Scenarios                                                                                           | Description                                                                                                                                                                                                                     |
|----------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| OIDC Auth Code Grant Redirect With Consent                                                               | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.                                                                                                                                       |
| OIDC Auth Code Grant Redirect Without Consent                                                            | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent.                                                                                                                       |
| OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes                                 | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent. Retrieve country, email, first name and last name as user attributes. |
| OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes, Groups and Roles               | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type without consent. Retrieve country, email, first name and last name as user attributes. Additionally retrieve groups and roles as well. |
| SAML2 SSO Redirect Binding                                                                               | Obtain a SAML 2 assertion response using redirect binding.                                                                                                                                                                      |
| Token Exchange Grant Type                                                                                | Obtain an access token and an id token using the token exchange grant type.                                                                                                                                                     |
| Client Credentials Grant Type                                                                            | Obtain an access token using the OAuth 2.0 client credential grant type.                                                                                                                                                        |
| OIDC Password Grant Type                                                                                 | Obtain an access token and an id token using the OAuth 2.0 password grant type. |

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
| IS Instance Type 2 Cores          | The AWS EC2 instance type used to run the Identity Server.                                                        | [**c6i.large**](https://aws.amazon.com/ec2/instance-types/)      |
| IS Instance Type 4 Cores          | The AWS EC2 instance type used to run the Identity Server.                                                        | [**c6i.xlarge**](https://aws.amazon.com/ec2/instance-types/)     |
| RDS Instance Type                 | The AWS RDS instance type used to run the Identity Server.                                                        | [**db.m6i.2xlarge**](https://aws.amazon.com/rds/instance-types/) |
| JDK version                       | The JDK version used to run the Identity Server.                                                                  | JDK 11.0.15.1                                                   |

The following is the summary of performance test results collected for the measurement period.

### 1. OIDC Auth Code Grant Redirect With Consent

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.

Note: Response time is calculated for the user consent providing request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core
-----------------|-----------------------|-----------------|-----------------|-------------------|------------------
50 | 31 | 52 | 47 | 66 | 42
100 | 30 | 52 | 46 | 67 | 40
150 | 31 | 51 | 46 | 64 | 39
300 | 32 | 51 | 47 | 61 | 36
500 | 36 | 59 | 47 | 61 | 37
1000 | 100 | 4878 | 52 | 64 | 39
1500 | 3302 | 12958 | 68 | 64 | 37
2000 | 6558 | 21822 | 127 | 84 | 47
2500 | 11582 | 29438 | 1028 | 111 | 63
3000 | 14942 | 35710 | 4398 | 310 | 248


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_With_Consent/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_With_Consent/50_3000_lines.png)

### 2. OIDC Auth Code Grant Redirect Without Consent

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.

Note: Response time is calculated for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core
-----------------|-----------------------|-----------------|-----------------|-------------------|------------------
50 | 67 | 79 | 112 | 120 | 77
100 | 69 | 81 | 111 | 119 | 79
150 | 56 | 71 | 100 | 109 | 66
300 | 60 | 78 | 98 | 107 | 67
500 | 77 | 107 | 102 | 108 | 68
1000 | 3205 | 14477 | 112 | 108 | 65
1500 | 8437 | 23357 | 169 | 127 | 75
2000 | 13965 | 44221 | 2005 | 175 | 94
2500 | 21725 | 65725 | 8845 | 619 | 487
3000 | 26781 | 69053 | 12029 | 3625 | 2597


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent/50_3000_lines.png)

### 3. OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. Retrieve country, email, first name and last name as user attributes.

Note: Response time is calculated for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core
-----------------|-----------------------|-----------------|-----------------|-------------------|------------------
50 | 57 | 81 | 114 | 134 | 112
100 | 56 | 83 | 112 | 133 | 112
150 | 56 | 75 | 100 | 124 | 100
300 | 60 | 79 | 101 | 122 | 97
500 | 73 | 149 | 102 | 76 | 115
1000 | 3305 | 11645 | 110 | 74 | 112
1500 | 8205 | 26109 | 165 | 85 | 114
2000 | 14381 | 39805 | 1280 | 125 | 123
2500 | 21053 | 51453 | 7605 | 634 | 523
3000 | 28509 | 60413 | 12701 | 6181 | 2613


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieve_User_Attributes/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieve_User_Attributes/50_3000_lines.png)

### 4. OIDC Auth Code Grant Redirect Without Consent Retrieving User Attributes Groups and Roles

#### Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. Retrieve country, email, first name and last name as user attributes. Additionally retrieve groups and roles as well.

Note: Response time is calculated for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core
-----------------|-----------------------|-----------------|-----------------|-------------------|------------------
50 | 111 | 69 | 99 | 123 | 99
100 | 111 | 67 | 98 | 119 | 98
150 | 100 | 68 | 97 | 116 | 98
300 | 103 | 74 | 96 | 117 | 95
500 | 124 | 151 | 89 | 61 | 103
1000 | 2905 | 12573 | 105 | 68 | 105
1500 | 8685 | 24477 | 163 | 114 | 112
2000 | 13965 | 35965 | 2237 | 127 | 125
2500 | 21757 | 49789 | 8101 | 631 | 504
3000 | 27613 | 64381 | 11677 | 6949 | 2645


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieve_User_Attributes_Groups_and_Roles/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Auth_Code_Grant_Redirect_Without_Consent_Retrieve_User_Attributes_Groups_and_Roles/50_3000_lines.png)

### 5. SAML2 SSO Redirect Binding

#### Obtain a SAML 2 assertion response using redirect binding.

Note: Response time is calculated for the user credentials submission request.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core
-----------------|-----------------------|-----------------|-----------------|-------------------|------------------
50 | 42 | 34 | 51 | 68 | 74
100 | 40 | 33 | 52 | 68 | 73
150 | 41 | 33 | 51 | 64 | 72
300 | 40 | 35 | 51 | 59 | 63
500 | 43 | 40 | 50 | 59 | 63
1000 | 65 | 531 | 59 | 61 | 64
1500 | 1879 | 10943 | 65 | 64 | 65
2000 | 5535 | 20991 | 89 | 71 | 71
2500 | 8831 | 29055 | 285 | 90 | 81
3000 | 13055 | 43007 | 4703 | 543 | 419


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/SAML2_SSO_Redirect_Binding/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/SAML2_SSO_Redirect_Binding/50_3000_lines.png)

### 6. Token Exchange Grant Type

#### Obtain an access token and an id token using the token exchange grant type.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core
-----------------|-----------------------|-----------------|-----------------|-------------------|------------------
50 | 159 | 267 | 98 | 97 | 54
100 | 337 | 627 | 252 | 250 | 188
150 | 543 | 995 | 431 | 429 | 339
300 | 1159 | 2191 | 995 | 995 | 835
500 | 2023 | 3727 | 1743 | 1735 | 1511
1000 | 3839 | 8191 | 3599 | 3439 | 3103
1500 | 5343 | 14143 | 6015 | 4991 | 4703
2000 | 6431 | 18687 | 8895 | 6047 | 5855
2500 | 7551 | 15167 | 12799 | 7423 | 6623
3000 | 8895 | 36863 | 16895 | 8127 | 7583


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/Token_Exchange_Grant/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/Token_Exchange_Grant/50_3000_lines.png)

### 7. Client Credentials Grant Type

#### Obtain an access token using the OAuth 2.0 client credential grant type.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core
-----------------|-----------------------|-----------------|-----------------|-------------------|------------------
50 | 88 | 165 | 51 | 40 | 27
100 | 165 | 407 | 161 | 134 | 74
150 | 275 | 679 | 270 | 263 | 174
300 | 691 | 1511 | 688 | 587 | 413
500 | 1127 | 2319 | 1125 | 1095 | 799
1000 | 1943 | 5471 | 2447 | 2159 | 1847
1500 | 2655 | 7903 | 3551 | 3231 | 2991
2000 | 3375 | 10687 | 5087 | 4927 | 4287
2500 | 4031 | 12927 | 6911 | 6463 | 4767
3000 | 4799 | 16767 | 8767 | 8127 | 5471


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/Client_Credentials_Grant_Type/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/Client_Credentials_Grant_Type/50_3000_lines.png)

### 8. OIDC Password Grant Type

#### Obtain an access token and an id token using the OAuth 2.0 password grant type.

Performance Comparison of Different Node Configurations with 95th Percentile of Response Time (ms)

Concurrent Users | Single Node 4 Core | Two Node 2 Core | Two Node 4 Core | Three Node 4 Core | Four Node 4 Core
-----------------|-----------------------|-----------------|-----------------|-------------------|------------------
50 | 164 | 307 | 103 | 60 | 47
100 | 307 | 675 | 252 | 203 | 108
150 | 489 | 1071 | 447 | 365 | 279
300 | 1143 | 2367 | 979 | 939 | 895
500 | 1847 | 4351 | 1815 | 1607 | 1559
1000 | 3727 | 9599 | 3695 | 3487 | 3231
1500 | 4895 | 16639 | 6847 | 6207 | 5535
2000 | 6111 | 22783 | 10303 | 9087 | 8895
2500 | 7423 | 32639 | 13823 | 12799 | 10495
3000 | 8831 | 35071 | 17023 | 15679 | 11527


<ins> Concurrency: 50 - 500 </ins>

![image info](graphs/OIDC_Password_Grant_Type/50_500_lines.png)

<ins> Concurrency: 50 - 3000 </ins>

![image info](graphs/OIDC_Password_Grant_Type/50_3000_lines.png)
