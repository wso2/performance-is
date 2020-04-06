# IAM Performance Test Results

During each release, we execute various automated performance test scenarios and publish the results.

| Test Scenarios | Description |
| --- | --- |
| Authenticate Super Tenant User | Select random super tenant users and authenticate through the RemoteUserStoreManagerService. |
| Auth Code Grant Redirect With Consent | Obtain an access token using the OAuth 2.0 authorization code grant type. |
| SCIM2 Get User | Get user details by passing the SCIM ID. |
| SCIM2 Update User | Update user details by passing the SCIM ID. |
| SCIM2 Add User | Add user to the system with SCIM APIs. |
| Implicit Grant Redirect With Consent | Obtain an access token using the OAuth 2.0 implicit grant type. |
| Password Grant Type | Obtain an access token using the OAuth 2.0 password grant type. |
| Client Credentials Grant Type | Obtain an access token using the OAuth 2.0 client credential grant type. |
| OIDC Auth Code Grant Redirect With Consent | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. |
| OIDC Implicit Grant Redirect With Consent | Obtain an access token and an id token using the OAuth 2.0 implicit grant type. |
| OIDC Password Grant Type | Obtain an access token and an id token using the OAuth 2.0 password grant type. |
| OIDC Auth Code Request Path Authenticator With Consent | Obtain an access token and an id token using the request path authenticator. |
| SAML2 SSO Redirect Binding | Obtain a SAML 2 assertion response using redirect binding. |

Our test client is [Apache JMeter](https://jmeter.apache.org/index.html). We test each scenario for a fixed duration of
time and split the test results into warm-up and measurement parts and use the measurement part to compute the
performance metrics. For this particular instance, the duration of each test is **15 minutes** and the warm-up period is **5 minutes**.

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
| IS Instance Type | The AWS instance type used to run the Identity Server. | [**c5.xlarge**](https://aws.amazon.com/ec2/instance-types/) |

The following are the measurements collected from each performance test conducted for a given combination of
test parameters.

| Measurement | Description |
| --- | --- |
| Error % | Percentage of requests with errors |
| Average Response Time (ms) | The average response time of a set of results |
| Standard Deviation of Response Time (ms) | The Standard Deviation of the response time. |
| 99th Percentile of Response Time (ms) | 99% of the requests took no more than this time. The remaining samples took at least as long as this |
| Throughput (Requests/sec) | The throughput measured in requests per second. |
| Average Memory Footprint After Full GC (M) | The average memory consumed by the application after a full garbage collection event. |

The following is the summary of performance test results collected for the measurement period.

|  Scenario Name | Concurrent Users | Label | Error % | Throughput (Requests/sec) | Average Response Time (ms) | Standard Deviation of Response Time (ms) | 99th Percentile of Response Time (ms) | WSO2 Identity Server GC Throughput (%) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
|  Authenticate Super Tenant User | 50 | Authenticate | 0 | 2043.14 | 24.3 | 9.96 | 54 | 98.75 |
|  Authenticate Super Tenant User | 100 | Authenticate | 0 | 2036.46 | 48.92 | 22.2 | 113 | 98.57 |
|  Authenticate Super Tenant User | 150 | Authenticate | 0 | 1992.39 | 75.09 | 35.76 | 186 | 98.41 |
|  Authenticate Super Tenant User | 300 | Authenticate | 0 | 1866.71 | 160.51 | 91.13 | 447 | 97.97 |
|  Authenticate Super Tenant User | 500 | Authenticate | 0 | 1834.18 | 272.57 | 137.56 | 675 | 97.2 |
|  Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 146.73 | 70.28 | 36.88 | 210 | 98.36 |
|  Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 146.73 | 39.47 | 27.35 | 163 | 98.36 |
|  Auth Code Grant Redirect With Consent | 50 | Get Authorization Code | 0 | 146.72 | 65.51 | 41.17 | 215 | 98.36 |
|  Auth Code Grant Redirect With Consent | 50 | Get access token | 0 | 146.74 | 116.98 | 50.81 | 289 | 98.36 |
|  Auth Code Grant Redirect With Consent | 50 | Send request to authorize end poiont | 0 | 146.73 | 47.55 | 35.21 | 184 | 98.36 |
|  Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 164.53 | 130.02 | 46.32 | 297 | 98.08 |
|  Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 164.54 | 71.77 | 35.44 | 203 | 98.08 |
|  Auth Code Grant Redirect With Consent | 100 | Get Authorization Code | 0 | 164.54 | 116.9 | 50.16 | 291 | 98.08 |
|  Auth Code Grant Redirect With Consent | 100 | Get access token | 0 | 164.53 | 206.58 | 60.88 | 415 | 98.08 |
|  Auth Code Grant Redirect With Consent | 100 | Send request to authorize end poiont | 0 | 164.54 | 81.59 | 41.75 | 226 | 98.08 |
|  Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 172.97 | 189.5 | 54.9 | 373 | 97.85 |
|  Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 173.02 | 106.58 | 45.77 | 265 | 97.85 |
|  Auth Code Grant Redirect With Consent | 150 | Get Authorization Code | 0 | 173.01 | 168.95 | 61.7 | 383 | 97.85 |
|  Auth Code Grant Redirect With Consent | 150 | Get access token | 0 | 173.01 | 288.55 | 69.95 | 509 | 97.85 |
|  Auth Code Grant Redirect With Consent | 150 | Send request to authorize end poiont | 0 | 172.98 | 112.73 | 46.83 | 277 | 97.85 |
|  Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 174.01 | 377.45 | 93.87 | 659 | 97.55 |
|  Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 173.96 | 223.17 | 84.54 | 497 | 97.55 |
|  Auth Code Grant Redirect With Consent | 300 | Get Authorization Code | 0 | 173.98 | 339.01 | 119.76 | 739 | 97.55 |
|  Auth Code Grant Redirect With Consent | 300 | Get access token | 0 | 173.97 | 568.39 | 118.34 | 923 | 97.55 |
|  Auth Code Grant Redirect With Consent | 300 | Send request to authorize end poiont | 0 | 174.02 | 215.8 | 76.95 | 461 | 97.55 |
|  Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0.01 | 154.11 | 617.92 | 1034.06 | 959 | 97.25 |
|  Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0.01 | 154.01 | 389.02 | 1099.63 | 783 | 97.25 |
|  Auth Code Grant Redirect With Consent | 500 | Get Authorization Code | 0 | 154.04 | 629.61 | 2126.07 | 1111 | 97.25 |
|  Auth Code Grant Redirect With Consent | 500 | Get access token | 0 | 153.64 | 1156.18 | 2538.86 | 1615 | 97.25 |
|  Auth Code Grant Redirect With Consent | 500 | Send request to authorize end poiont | 0 | 154.14 | 354.44 | 721.47 | 659 | 97.25 |
|  Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 203.54 | 85.24 | 51.43 | 295 | 98.37 |
|  Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 203.55 | 53.49 | 40 | 205 | 98.37 |
|  Implicit Grant Redirect With Consent | 50 | Get Access token | 0 | 203.54 | 47.49 | 31.4 | 177 | 98.37 |
|  Implicit Grant Redirect With Consent | 50 | Send request to authorize end point | 0 | 203.53 | 58.62 | 48.11 | 238 | 98.37 |
|  Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 224.45 | 151.62 | 57.7 | 347 | 98.21 |
|  Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 224.46 | 98.38 | 51.57 | 273 | 98.21 |
|  Implicit Grant Redirect With Consent | 100 | Get Access token | 0 | 224.48 | 93.44 | 47.36 | 246 | 98.21 |
|  Implicit Grant Redirect With Consent | 100 | Send request to authorize end point | 0 | 224.48 | 101.25 | 58.68 | 293 | 98.21 |
|  Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 235.79 | 213.01 | 74.23 | 475 | 97.98 |
|  Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 235.77 | 142.91 | 69.67 | 375 | 97.98 |
|  Implicit Grant Redirect With Consent | 150 | Get Access token | 0 | 235.83 | 142.53 | 70.45 | 355 | 97.98 |
|  Implicit Grant Redirect With Consent | 150 | Send request to authorize end point | 0 | 235.84 | 136.98 | 68.5 | 367 | 97.98 |
|  Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 244.81 | 401.37 | 110.07 | 735 | 97.33 |
|  Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 244.88 | 284.61 | 116.71 | 607 | 97.33 |
|  Implicit Grant Redirect With Consent | 300 | Get Access token | 0 | 244.89 | 286.25 | 130.31 | 611 | 97.33 |
|  Implicit Grant Redirect With Consent | 300 | Send request to authorize end point | 0 | 244.85 | 252.8 | 97.72 | 571 | 97.33 |
|  Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 233.64 | 703.67 | 160.01 | 1151 | 97 |
|  Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0 | 233.92 | 503.07 | 183.05 | 1011 | 97 |
|  Implicit Grant Redirect With Consent | 500 | Get Access token | 0 | 233.95 | 492.13 | 205.31 | 1003 | 97 |
|  Implicit Grant Redirect With Consent | 500 | Send request to authorize end point | 0 | 233.91 | 439.03 | 136.87 | 863 | 97 |
|  Password Grant Type | 50 | GetToken_Password_Grant | 0 | 1352.14 | 36.82 | 15.42 | 76 | 98.79 |
|  Password Grant Type | 100 | GetToken_Password_Grant | 0 | 1352.44 | 73.78 | 29.17 | 158 | 98.54 |
|  Password Grant Type | 150 | GetToken_Password_Grant | 0 | 1327.57 | 112.8 | 45.17 | 251 | 98.47 |
|  Password Grant Type | 300 | GetToken_Password_Grant | 0 | 1251.66 | 239.59 | 108.71 | 579 | 98.11 |
|  Password Grant Type | 500 | GetToken_Password_Grant | 0 | 1189.98 | 420.26 | 144.96 | 887 | 97.74 |
|  Client Credentials Grant Type | 50 | Get Token Client Credential Grant | 0 | 4347.19 | 11.34 | 17.55 | 86 | 99.03 |
|  Client Credentials Grant Type | 100 | Get Token Client Credential Grant | 0 | 4163.04 | 23.85 | 39.27 | 185 | 98.94 |
|  Client Credentials Grant Type | 150 | Get Token Client Credential Grant | 0 | 4126.49 | 36.18 | 59.83 | 275 | 98.85 |
|  Client Credentials Grant Type | 300 | Get Token Client Credential Grant | 0 | 4037.5 | 74.12 | 118.15 | 509 | 98.38 |
|  Client Credentials Grant Type | 500 | Get Token Client Credential Grant | 0 | 3969.23 | 125.82 | 188.88 | 783 | 97.7 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 143.33 | 72.99 | 38 | 208 | 98.3 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 143.31 | 40.68 | 27.6 | 158 | 98.3 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Get Authorization Code | 0 | 143.31 | 66.77 | 41.31 | 216 | 98.3 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Get tokens | 0 | 143.32 | 117.92 | 49.74 | 289 | 98.3 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Send request to authorize end poiont | 0 | 143.34 | 49.49 | 36.1 | 183 | 98.3 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 160.29 | 136.87 | 55.16 | 353 | 98.08 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 160.32 | 74.14 | 40.79 | 230 | 98.08 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Get Authorization Code | 0 | 160.3 | 119.03 | 56.32 | 337 | 98.08 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Get tokens | 0 | 160.3 | 209.84 | 71.48 | 473 | 98.08 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Send request to authorize end poiont | 0 | 160.35 | 82.93 | 47.73 | 273 | 98.08 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 161.88 | 207.6 | 77.34 | 483 | 97.91 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 161.9 | 112.89 | 55.53 | 323 | 97.91 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Get Authorization Code | 0 | 161.88 | 179.35 | 76.58 | 441 | 97.91 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Get tokens | 0 | 161.88 | 303.66 | 95.63 | 631 | 97.91 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Send request to authorize end poiont | 0 | 161.89 | 122.39 | 63.16 | 357 | 97.91 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 170.62 | 390.31 | 104.48 | 695 | 97.59 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 170.65 | 226.86 | 90.08 | 515 | 97.59 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Get Authorization Code | 0 | 170.62 | 340.7 | 122.13 | 743 | 97.59 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Get tokens | 0 | 170.65 | 576.51 | 131.79 | 979 | 97.59 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Send request to authorize end poiont | 0 | 170.69 | 223.51 | 89.7 | 511 | 97.59 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0.01 | 150.06 | 656.93 | 1106.48 | 1031 | 97.28 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0.01 | 150.03 | 397.79 | 1158.99 | 795 | 97.28 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Get Authorization Code | 0.02 | 150.11 | 601.55 | 1496.15 | 1135 | 97.28 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Get tokens | 0 | 149.89 | 1216.31 | 3097.71 | 1631 | 97.28 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Send request to authorize end poiont | 0 | 150.17 | 370.05 | 759.87 | 707 | 97.28 |
|  OIDC Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 174.49 | 82.46 | 48.37 | 269 | 98.42 |
|  OIDC Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 174.51 | 47.85 | 36.52 | 187 | 98.42 |
|  OIDC Implicit Grant Redirect With Consent | 50 | Get tokens | 0 | 174.49 | 100.38 | 50.57 | 299 | 98.42 |
|  OIDC Implicit Grant Redirect With Consent | 50 | Send request to authorize end point | 0 | 174.51 | 55.05 | 45.74 | 222 | 98.42 |
|  OIDC Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 184.7 | 154.01 | 66.92 | 381 | 98.15 |
|  OIDC Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 184.73 | 90.28 | 53.96 | 297 | 98.15 |
|  OIDC Implicit Grant Redirect With Consent | 100 | Get tokens | 0 | 184.72 | 198.47 | 76.46 | 461 | 98.15 |
|  OIDC Implicit Grant Redirect With Consent | 100 | Send request to authorize end point | 0 | 184.71 | 97.87 | 62.87 | 313 | 98.15 |
|  OIDC Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 198.02 | 206.72 | 65.84 | 401 | 97.91 |
|  OIDC Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 198.07 | 128.65 | 57.54 | 309 | 97.91 |
|  OIDC Implicit Grant Redirect With Consent | 150 | Get tokens | 0 | 198.07 | 281.84 | 86.99 | 539 | 97.91 |
|  OIDC Implicit Grant Redirect With Consent | 150 | Send request to authorize end point | 0 | 198.07 | 139.53 | 63.12 | 327 | 97.91 |
|  OIDC Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 205.68 | 386.19 | 107.54 | 691 | 97.46 |
|  OIDC Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 205.63 | 257.14 | 111.54 | 575 | 97.46 |
|  OIDC Implicit Grant Redirect With Consent | 300 | Get tokens | 0 | 205.67 | 573.33 | 169.82 | 1007 | 97.46 |
|  OIDC Implicit Grant Redirect With Consent | 300 | Send request to authorize end point | 0 | 205.79 | 241.49 | 88.62 | 515 | 97.46 |
|  OIDC Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 201.08 | 648.53 | 148.1 | 1031 | 97.01 |
|  OIDC Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0 | 201.03 | 450.59 | 165.5 | 927 | 97.01 |
|  OIDC Implicit Grant Redirect With Consent | 500 | Get tokens | 0 | 201.08 | 983.61 | 256.9 | 1671 | 97.01 |
|  OIDC Implicit Grant Redirect With Consent | 500 | Send request to authorize end point | 0 | 201.19 | 402.86 | 119.74 | 751 | 97.01 |
|  OIDC Password Grant Type | 50 | GetToken_Password_Grant | 0 | 581.6 | 85.8 | 21.22 | 145 | 99.1 |
|  OIDC Password Grant Type | 100 | GetToken_Password_Grant | 0 | 586.76 | 170.24 | 47.75 | 299 | 98.93 |
|  OIDC Password Grant Type | 150 | GetToken_Password_Grant | 0 | 574.95 | 260.85 | 82.31 | 493 | 98.84 |
|  OIDC Password Grant Type | 300 | GetToken_Password_Grant | 0 | 524.26 | 571.97 | 230.4 | 1295 | 98.67 |
|  OIDC Password Grant Type | 500 | GetToken_Password_Grant | 0 | 542.1 | 921.11 | 270.75 | 1647 | 98.25 |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Get Authorization Code | 0 | 158.39 | 63.75 | 40.18 | 207 | 98.33 |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Get tokens | 0 | 158.4 | 114.09 | 46.12 | 277 | 98.33 |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Send request to authorize end poiont | 0 | 158.38 | 137.05 | 60.29 | 339 | 98.33 |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Get Authorization Code | 0 | 182.56 | 112.33 | 48.96 | 277 | 98.08 |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Get tokens | 0 | 182.52 | 199.53 | 55.73 | 383 | 98.08 |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Send request to authorize end poiont | 0 | 182.51 | 235.16 | 63.31 | 437 | 98.08 |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Get Authorization Code | 0 | 187.68 | 167.04 | 72.28 | 413 | 97.96 |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Get tokens | 0 | 187.64 | 290.45 | 79.94 | 567 | 97.96 |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Send request to authorize end poiont | 0 | 187.64 | 341.55 | 84.86 | 643 | 97.96 |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Get Authorization Code | 0 | 188.27 | 345.85 | 130.97 | 759 | 97.53 |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Get tokens | 0 | 188.23 | 570.77 | 122.66 | 923 | 97.53 |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Send request to authorize end poiont | 0 | 188.31 | 676.46 | 127.55 | 1047 | 97.53 |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Get Authorization Code | 0.04 | 164.89 | 590.91 | 1560.74 | 1183 | 97.27 |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Get tokens | 0 | 164.58 | 1149.26 | 2393.19 | 1631 | 97.27 |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Send request to authorize end poiont | 0.01 | 165.04 | 1168.33 | 1690.1 | 1647 | 97.27 |
|  SAML2 SSO Redirect Binding | 50 | Identity Provider Login | 0 | 217.9 | 166.75 | 78.42 | 379 | 97.44 |
|  SAML2 SSO Redirect Binding | 50 | Initial SAML Request | 0 | 217.89 | 61.62 | 41.16 | 191 | 97.44 |
|  SAML2 SSO Redirect Binding | 100 | Identity Provider Login | 0 | 239.27 | 292.7 | 101.27 | 563 | 97.06 |
|  SAML2 SSO Redirect Binding | 100 | Initial SAML Request | 0 | 239.29 | 124.13 | 64.17 | 329 | 97.06 |
|  SAML2 SSO Redirect Binding | 150 | Identity Provider Login | 0 | 261.37 | 405.39 | 117.71 | 731 | 96.68 |
|  SAML2 SSO Redirect Binding | 150 | Initial SAML Request | 0 | 261.38 | 167.57 | 77.69 | 419 | 96.68 |
|  SAML2 SSO Redirect Binding | 300 | Identity Provider Login | 0 | 298.73 | 693.64 | 176.08 | 1167 | 95.92 |
|  SAML2 SSO Redirect Binding | 300 | Initial SAML Request | 0 | 298.77 | 309.41 | 143.69 | 743 | 95.92 |
|  SAML2 SSO Redirect Binding | 500 | Identity Provider Login | 0 | 287.38 | 1153.71 | 386.9 | 2351 | 95.63 |
|  SAML2 SSO Redirect Binding | 500 | Initial SAML Request | 0 | 287.35 | 583.73 | 327.77 | 1647 | 95.63 |
|  SCIM2 Get User | 50 | Get User Request | 100 | 0.11 | 446095.36 | 14066.88 | 456703 | 99.76 |
|  SCIM2 Get User | 100 | Get User Request | 100 | 0.06 | 182345.14 | 17445.45 | 226303 | 99.71 |
|  SCIM2 Get User | 500 | Get User Request | 100 | 3.31 | 60032 | 0 | 60159 | 99.89 |
|  SCIM2 Update User | 50 | Update User Account | 100 | 0.1 | 402948.34 | 119575.47 | 481279 | 99.7 |
|  SCIM2 Update User | 100 | Update User Account | 100 | 0.06 | 165120 | 10626.31 | 186367 | 99.63 |
|  SCIM2 Update User | 500 | Update User Account | 100 | 3.31 | 60032 | 0 | 60159 | 99.91 |
|  SCIM2 Add User | 50 | Create User Account | 92.37 | 1437.54 | 34.74 | 18.08 | 107 | 98.71 |
|  SCIM2 Add User | 100 | Create User Account | 100 | 1555.44 | 64.25 | 22.23 | 133 | 98.63 |
|  SCIM2 Add User | 150 | Create User Account | 100 | 1521.52 | 98.53 | 42.99 | 240 | 98.5 |
|  SCIM2 Add User | 300 | Create User Account | 100 | 1431.57 | 209.6 | 110.78 | 551 | 98.03 |
|  SCIM2 Add User | 500 | Create User Account | 100 | 1378.79 | 362.85 | 127.31 | 739 | 97.53 |
