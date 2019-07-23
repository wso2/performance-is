# IAM Performance Test Results

During each release, we execute various automated performance test scenarios and publish the results.

| Test Scenarios | Description |
| --- | --- |
| Authenticate Super Tenant User | Select random super tenant users and authenticate through the RemoteUserStoreManagerService. |
| Auth Code Grant Redirect With Consent | Obtain an access token using the OAuth 2.0 authorization code grant type. |
| SCIM2 Get User | Get user details by passing the SCIM ID. |
| Implicit Grant Redirect With Consent | Obtain an access token using the OAuth 2.0 implicit grant type. |
| Password Grant Type | Obtain an access token using the OAuth 2.0 password grant type. |
| Client Credentials Grant Type | Obtain an access token using the OAuth 2.0 client credential grant type. |
| OIDC Auth Code Grant Redirect With Consent | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. |
| OIDC Implicit Grant Redirect With Consent | Obtain an access token and an id token using the OAuth 2.0 implicit grant type. |
| OIDC Password Grant Type | Obtain an access token and an id token using the OAuth 2.0 password grant type. |
| OIDC Auth Code Request Path Authenticator With Consent | Obtain an access token and an id token using the request path authenticator. |
| SAML2 SSO Redirect Binding | Obtain a SAML 2 assertion response using redirect binding. |

Our test client is [Apache JMeter](https://jmeter.apache.org/index.html). We test each scenario for a fixed duration of
time. We split the test results into warmup and measurement parts and use the measurement part to compute the
performance metrics.

We run the performance tests under different numbers of concurrent users and heap sizes to gain a better understanding on how the server reacts to different loads.

The main performance metrics:

1. **Throughput**: The number of requests that the WSO2 Identity Server processes during a specific time interval (e.g. per second).
2. **Response Time**: The end-to-end latency for a given operation of the WSO2 Identity Server. The complete distribution of response times was recorded.

In addition to the above metrics, we measure the load average and several memory-related metrics.

The following are the test parameters.

| Test Parameter | Description | Values |
| --- | --- | --- |
| Scenario Name | The name of the test scenario. | Refer to the above table. |
| Heap Size | The amount of memory allocated to the application | 2G |
| Concurrent Users | The number of users accessing the application at the same time. | 50, 100, 150, 300, 500 |
    

The duration of each test is **15 minutes**. The warm-up period is **5 minutes**.
The measurement results are collected after the warm-up period.

Two [**c5.xlarge** Amazon EC2 instance](https://aws.amazon.com/ec2/instance-types/)s were used to install WSO2 Identity Server.

The following are the measurements collected from each performance test conducted for a given combination of
test parameters.

| Measurement | Description |
| --- | --- |
| Error % | Percentage of requests with errors |
| Average Response Time (ms) | The average response time of a set of results |
| Standard Deviation of Response Time (ms) | The “Standard Deviation” of the response time. |
| 99th Percentile of Response Time (ms) | 99% of the requests took no more than this time. The remaining samples took at least as long as this |
| Throughput (Requests/sec) | The throughput measured in requests per second. |
| Average Memory Footprint After Full GC (M) | The average memory consumed by the application after a full garbage collection event. |

The following is the summary of performance test results collected for the measurement period.

|  Scenario Name | Concurrent Users | Label | Error % | Throughput (Requests/sec) | Average Response Time (ms) | Standard Deviation of Response Time (ms) | 99th Percentile of Response Time (ms) | WSO2 Identity Server 1 GC Throughput (%) | WSO2 Identity Server GC 2 Throughput (%) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
|  Authenticate Super Tenant User | 50 | Authenticate | 0 | 1471.08 | 33.79 | 24.56 | 137 | 98.17 |  |
|  Authenticate Super Tenant User | 100 | Authenticate | 0 | 1564.52 | 63.71 | 48.45 | 275 | 97.88 |  |
|  Authenticate Super Tenant User | 150 | Authenticate | 0 | 1625.76 | 92.04 | 70.16 | 375 | 97.88 |  |
|  Authenticate Super Tenant User | 300 | Authenticate | 0 | 1561.53 | 191.88 | 290.07 | 1223 | 97.33 |  |
|  Authenticate Super Tenant User | 500 | Authenticate | 0.18 | 1580.44 | 315.6 | 640.75 | 3199 | 97.32 |  |
|  Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 169.44 | 59.24 | 20.96 | 154 | 98.89 |  |
|  Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 169.44 | 34.16 | 15.2 | 103 | 98.89 |  |
|  Auth Code Grant Redirect With Consent | 50 | Get Authorization Code | 0 | 169.41 | 53.57 | 24.66 | 168 | 98.89 |  |
|  Auth Code Grant Redirect With Consent | 50 | Get access token | 0 | 169.39 | 106.99 | 25.21 | 213 | 98.89 |  |
|  Auth Code Grant Redirect With Consent | 50 | Send request to authorize end poiont | 0 | 169.45 | 40.03 | 22.58 | 138 | 98.89 |  |
|  Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 200.91 | 103.1 | 29.28 | 216 | 98.72 |  |
|  Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 200.91 | 55.9 | 17.69 | 120 | 98.72 |  |
|  Auth Code Grant Redirect With Consent | 100 | Get Authorization Code | 0 | 200.91 | 86.88 | 25.63 | 201 | 98.72 |  |
|  Auth Code Grant Redirect With Consent | 100 | Get access token | 0 | 200.92 | 182.84 | 34.21 | 287 | 98.72 |  |
|  Auth Code Grant Redirect With Consent | 100 | Send request to authorize end poiont | 0 | 200.94 | 67.81 | 23.72 | 154 | 98.72 |  |
|  Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 197.62 | 163.58 | 62.77 | 423 | 98.63 |  |
|  Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 197.63 | 86.66 | 34.28 | 228 | 98.63 |  |
|  Auth Code Grant Redirect With Consent | 150 | Get Authorization Code | 0 | 197.61 | 136.99 | 53.69 | 369 | 98.63 |  |
|  Auth Code Grant Redirect With Consent | 150 | Get access token | 0 | 197.6 | 264.75 | 52.74 | 427 | 98.63 |  |
|  Auth Code Grant Redirect With Consent | 150 | Send request to authorize end poiont | 0 | 197.62 | 106.03 | 38 | 257 | 98.63 |  |
|  Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 187.4 | 331.16 | 140.67 | 867 | 98.49 |  |
|  Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 187.34 | 193.08 | 82.93 | 515 | 98.49 |  |
|  Auth Code Grant Redirect With Consent | 300 | Get Authorization Code | 0 | 187.31 | 300.56 | 118.97 | 771 | 98.49 |  |
|  Auth Code Grant Redirect With Consent | 300 | Get access token | 0 | 187.31 | 523.2 | 101.61 | 843 | 98.49 |  |
|  Auth Code Grant Redirect With Consent | 300 | Send request to authorize end poiont | 0 | 187.39 | 252.6 | 94.31 | 607 | 98.49 |  |
|  Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 206.4 | 457.14 | 98.98 | 763 | 98.08 |  |
|  Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0 | 206.42 | 291.38 | 76.99 | 547 | 98.08 |  |
|  Auth Code Grant Redirect With Consent | 500 | Get Authorization Code | 0 | 206.36 | 467.95 | 91.33 | 715 | 98.08 |  |
|  Auth Code Grant Redirect With Consent | 500 | Get access token | 0 | 206.16 | 809.83 | 124.85 | 1143 | 98.08 |  |
|  Auth Code Grant Redirect With Consent | 500 | Send request to authorize end poiont | 0 | 206.27 | 396.81 | 91.93 | 691 | 98.08 |  |
|  Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 262.5 | 67.19 | 24 | 163 | 98.86 |  |
|  Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 262.54 | 40.11 | 17.45 | 110 | 98.86 |  |
|  Implicit Grant Redirect With Consent | 50 | Get Access token | 0 | 262.56 | 33.81 | 13.43 | 68 | 98.86 |  |
|  Implicit Grant Redirect With Consent | 50 | Send request to authorize end point | 0 | 262.52 | 48.42 | 26.43 | 152 | 98.86 |  |
|  Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 308.16 | 113.87 | 29.89 | 210 | 98.58 |  |
|  Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 308.16 | 67.05 | 21.9 | 135 | 98.58 |  |
|  Implicit Grant Redirect With Consent | 100 | Get Access token | 0 | 308.16 | 59.93 | 19.83 | 120 | 98.58 |  |
|  Implicit Grant Redirect With Consent | 100 | Send request to authorize end point | 0 | 308.16 | 82.63 | 31.73 | 182 | 98.58 |  |
|  Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 323.52 | 162.89 | 51.9 | 397 | 98.49 |  |
|  Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 323.5 | 94.29 | 31.22 | 213 | 98.49 |  |
|  Implicit Grant Redirect With Consent | 150 | Get Access token | 0 | 323.56 | 91.61 | 40.36 | 253 | 98.49 |  |
|  Implicit Grant Redirect With Consent | 150 | Send request to authorize end point | 0 | 323.57 | 113.79 | 33.36 | 241 | 98.49 |  |
|  Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 297.54 | 341.58 | 137.86 | 839 | 98.23 |  |
|  Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 297.54 | 213.19 | 87.37 | 505 | 98.23 |  |
|  Implicit Grant Redirect With Consent | 300 | Get Access token | 0 | 297.58 | 181.46 | 92.45 | 527 | 98.23 |  |
|  Implicit Grant Redirect With Consent | 300 | Send request to authorize end point | 0 | 297.52 | 271.35 | 102.02 | 599 | 98.23 |  |
|  Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 284.03 | 579.01 | 243.67 | 1439 | 97.86 |  |
|  Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0 | 284.17 | 380.82 | 175.65 | 1135 | 97.86 |  |
|  Implicit Grant Redirect With Consent | 500 | Get Access token | 0 | 284.12 | 298.82 | 174.13 | 999 | 97.86 |  |
|  Implicit Grant Redirect With Consent | 500 | Send request to authorize end point | 0 | 284.1 | 501.05 | 212.53 | 1391 | 97.86 |  |
|  Password Grant Type | 50 | GetToken_Password_Grant | 0 | 1271.67 | 39.14 | 20.02 | 121 | 99.1 |  |
|  Password Grant Type | 100 | GetToken_Password_Grant | 0 | 1381.56 | 72.19 | 43.15 | 244 | 98.98 |  |
|  Password Grant Type | 150 | GetToken_Password_Grant | 0 | 1369.01 | 109.37 | 65.92 | 365 | 98.9 |  |
|  Password Grant Type | 300 | GetToken_Password_Grant | 0 | 1366.45 | 219.38 | 142.62 | 731 | 98.74 |  |
|  Password Grant Type | 500 | GetToken_Password_Grant | 0.05 | 1335.06 | 374.28 | 241.3 | 1303 | 98.49 |  |
|  Client Credentials Grant Type | 50 | Get Token Client Credential Grant | 0 | 4477.39 | 10.99 | 7.11 | 49 | 98.82 |  |
|  Client Credentials Grant Type | 100 | Get Token Client Credential Grant | 0 | 4706.75 | 21.05 | 13.67 | 74 | 98.74 |  |
|  Client Credentials Grant Type | 150 | Get Token Client Credential Grant | 0 | 4696.84 | 31.72 | 23.38 | 122 | 98.7 |  |
|  Client Credentials Grant Type | 300 | Get Token Client Credential Grant | 0 | 4796.02 | 62.25 | 78.04 | 210 | 98.52 |  |
|  Client Credentials Grant Type | 500 | Get Token Client Credential Grant | 0 | 4692.14 | 106.15 | 255.16 | 1167 | 98.33 |  |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 152.45 | 67.2 | 31.73 | 175 | 98.98 |  |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 152.44 | 38.04 | 22.19 | 118 | 98.98 |  |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Get Authorization Code | 0 | 152.44 | 58.74 | 36.66 | 196 | 98.98 |  |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Get tokens | 0 | 152.45 | 116.21 | 39.33 | 255 | 98.98 |  |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Send request to authorize end poiont | 0 | 152.44 | 46.68 | 34.46 | 165 | 98.98 |  |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 191.41 | 110.92 | 35.59 | 236 | 98.78 |  |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 191.42 | 58.36 | 25.83 | 164 | 98.78 |  |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Get Authorization Code | 0 | 191.39 | 90.2 | 37.62 | 229 | 98.78 |  |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Get tokens | 0 | 191.35 | 187.72 | 47.88 | 343 | 98.78 |  |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Send request to authorize end poiont | 0 | 191.4 | 74.07 | 36.98 | 195 | 98.78 |  |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 208.53 | 155.08 | 42.69 | 319 | 98.61 |  |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 208.6 | 80.83 | 27.51 | 192 | 98.61 |  |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Get Authorization Code | 0 | 208.61 | 126.22 | 38.71 | 279 | 98.61 |  |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Get tokens | 0 | 208.62 | 255.39 | 49.94 | 413 | 98.61 |  |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Send request to authorize end poiont | 0 | 208.59 | 100.49 | 33.5 | 223 | 98.61 |  |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 209.47 | 287.07 | 65.64 | 515 | 98.37 |  |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 209.35 | 167.87 | 47.51 | 333 | 98.37 |  |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Get Authorization Code | 0 | 209.3 | 262.58 | 58.16 | 455 | 98.37 |  |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Get tokens | 0 | 209.27 | 494.19 | 78.66 | 715 | 98.37 |  |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Send request to authorize end poiont | 0 | 209.42 | 220.68 | 56.37 | 407 | 98.37 |  |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 204.84 | 475.46 | 119.45 | 971 | 98.07 |  |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0 | 204.86 | 290.87 | 82.12 | 587 | 98.07 |  |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Get Authorization Code | 0 | 204.97 | 476.2 | 111.22 | 935 | 98.07 |  |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Get tokens | 0 | 205.09 | 803.74 | 127.94 | 1191 | 98.07 |  |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Send request to authorize end poiont | 0 | 204.88 | 392.9 | 95.53 | 727 | 98.07 |  |
|  OIDC Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 161.14 | 87.07 | 33.19 | 186 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 161.14 | 54.8 | 23.48 | 128 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 50 | Get tokens | 0 | 161.13 | 104.49 | 32.38 | 198 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 50 | Send request to authorize end point | 0 | 161.13 | 63.04 | 34.63 | 169 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 176.02 | 152.35 | 45.17 | 283 | 99.76 |  |
|  OIDC Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 176.04 | 111.64 | 31.08 | 207 | 99.76 |  |
|  OIDC Implicit Grant Redirect With Consent | 100 | Get tokens | 0 | 176.08 | 178.29 | 47.55 | 321 | 99.76 |  |
|  OIDC Implicit Grant Redirect With Consent | 100 | Send request to authorize end point | 0 | 176.04 | 124.81 | 39.55 | 243 | 99.76 |  |
|  OIDC Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 182.12 | 215.45 | 62.9 | 391 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 182.12 | 168.74 | 51.13 | 321 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 150 | Get tokens | 0 | 182.15 | 253.29 | 71.1 | 461 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 150 | Send request to authorize end point | 0 | 182.1 | 185.41 | 54.91 | 341 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 182.39 | 409.16 | 566.68 | 3247 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 182.16 | 369.72 | 549.41 | 3231 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 300 | Get tokens | 0 | 182.16 | 440.78 | 539.36 | 3247 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 300 | Send request to authorize end point | 0 | 182.16 | 421.38 | 631.87 | 3263 | 99.75 |  |
|  OIDC Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 1.44 | 184.51 | 664.81 | 1202.86 | 4191 | 99.76 |  |
|  OIDC Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 1.12 | 183.89 | 632.85 | 1197.23 | 4959 | 99.76 |  |
|  OIDC Implicit Grant Redirect With Consent | 500 | Get tokens | 1.97 | 184.88 | 684.02 | 1172.69 | 4799 | 99.76 |  |
|  OIDC Implicit Grant Redirect With Consent | 500 | Send request to authorize end point | 1.17 | 184.42 | 708.28 | 1290.83 | 7455 | 99.76 |  |
|  OIDC Password Grant Type | 50 | GetToken_Password_Grant | 0 | 632.07 | 78.92 | 22.52 | 170 | 99.33 |  |
|  OIDC Password Grant Type | 100 | GetToken_Password_Grant | 0 | 648.59 | 154 | 60.08 | 375 | 99.24 |  |
|  OIDC Password Grant Type | 150 | GetToken_Password_Grant | 0 | 642.37 | 233.38 | 87.95 | 559 | 99.19 |  |
|  OIDC Password Grant Type | 300 | GetToken_Password_Grant | 0 | 662.61 | 452.75 | 167.73 | 1079 | 99.06 |  |
|  OIDC Password Grant Type | 500 | GetToken_Password_Grant | 1.12 | 652.03 | 766.13 | 303.65 | 1863 | 98.94 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Get Authorization Code | 0 | 156.27 | 61.52 | 40.56 | 195 | 99.07 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Get tokens | 0 | 156.22 | 117.83 | 39.46 | 251 | 99.07 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Send request to authorize end poiont | 0 | 156.25 | 139.98 | 67.95 | 333 | 99.07 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Get Authorization Code | 0 | 210.18 | 83.83 | 30.84 | 209 | 98.84 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Get tokens | 0 | 210.17 | 182.12 | 42.83 | 311 | 98.84 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Send request to authorize end poiont | 0 | 210.12 | 209.21 | 52.55 | 363 | 98.84 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Get Authorization Code | 0 | 216.82 | 129.59 | 53.05 | 363 | 98.71 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Get tokens | 0 | 216.79 | 261.21 | 58.47 | 445 | 98.71 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Send request to authorize end poiont | 0 | 216.77 | 300.84 | 74.37 | 579 | 98.71 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Get Authorization Code | 0 | 212.02 | 280.94 | 98.26 | 695 | 98.54 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Get tokens | 0 | 212.06 | 514.32 | 94.26 | 803 | 98.54 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Send request to authorize end poiont | 0 | 212.14 | 619 | 145.19 | 1183 | 98.54 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Get Authorization Code | 0.12 | 206.55 | 517.71 | 174.53 | 1175 | 98.28 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Get tokens | 0.07 | 206.35 | 844.41 | 157.54 | 1335 | 98.28 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Send request to authorize end poiont | 0.11 | 206.62 | 1057.31 | 258.93 | 1975 | 98.28 |  |
|  SAML2 SSO Redirect Binding | 50 | Identity Provider Login | 0 | 265.6 | 142.78 | 66.97 | 315 | 98.15 |  |
|  SAML2 SSO Redirect Binding | 50 | Initial SAML Request | 0 | 265.65 | 44.17 | 31.27 | 132 | 98.15 |  |
|  SAML2 SSO Redirect Binding | 100 | Identity Provider Login | 0 | 302.66 | 245.31 | 73.13 | 409 | 97.87 |  |
|  SAML2 SSO Redirect Binding | 100 | Initial SAML Request | 0 | 302.73 | 83.81 | 36.35 | 175 | 97.87 |  |
|  SAML2 SSO Redirect Binding | 150 | Identity Provider Login | 0 | 335.93 | 330.54 | 69 | 505 | 97.54 |  |
|  SAML2 SSO Redirect Binding | 150 | Initial SAML Request | 0 | 336.04 | 114.75 | 39.06 | 233 | 97.54 |  |
|  SAML2 SSO Redirect Binding | 300 | Identity Provider Login | 0 | 353.64 | 613.68 | 315.21 | 1631 | 97.21 |  |
|  SAML2 SSO Redirect Binding | 300 | Initial SAML Request | 0 | 353.78 | 233.03 | 158.85 | 1023 | 97.21 |  |
|  SAML2 SSO Redirect Binding | 500 | Identity Provider Login | 0 | 339.01 | 1031.84 | 524.04 | 2735 | 97.12 |  |
|  SAML2 SSO Redirect Binding | 500 | Initial SAML Request | 0 | 339.44 | 439.46 | 343.54 | 1719 | 97.12 |  |
