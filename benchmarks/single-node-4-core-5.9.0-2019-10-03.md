# IAM Performance Test Results

During each release, we execute various automated performance test scenarios and publish the results.

| Test Scenarios | Description |
| --- | --- |
| Authenticate Super Tenant User | Select random super tenant users and authenticate through the RemoteUserStoreManagerService. |
| Auth Code Grant Redirect With Consent | Obtain an access token using the OAuth 2.0 authorization code grant type. |
| Challange questions by super tenant users | Challange questions operated by the autheticated super tenant user |
| Refresh token refresh grant | Request refresh token form refresh grant |
| Implicit Grant Redirect With Consent | Obtain an access token using the OAuth 2.0 implicit grant type. |
| Password Grant Type | Obtain an access token using the OAuth 2.0 password grant type. |
| Client Credentials Grant Type | Obtain an access token using the OAuth 2.0 client credential grant type. |
| OIDC Auth Code Grant Redirect With Consent | Obtain an access token and an id token using the OAuth 2.0 authorization code grant type. |
| OIDC Implicit Grant Redirect With Consent | Obtain an access token and an id token using the OAuth 2.0 implicit grant type. |
| OIDC Password Grant Type | Obtain an access token and an id token using the OAuth 2.0 password grant type. |
| OIDC Auth Code Request Path Authenticator With Consent | Obtain an access token and an id token using the request path authenticator. |
| SAML2 SSO Redirect Binding | Obtain a SAML 2 assertion response using redirect binding. |
| Challange questions by super tenant users|Create, retrive, update , delete challange question by user |
|Refresh token refresh grant - Renewal false|Obtain refresh token| 

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
|  Authenticate Super Tenant User | 50 | Authenticate | 0 | 1911.85 | 25.98 | 10.72 | 56 | 98.86 |
|  Authenticate Super Tenant User | 100 | Authenticate | 0 | 1907.99 | 52.23 | 24.05 | 121 | 98.66 |
|  Authenticate Super Tenant User | 150 | Authenticate | 0 | 1860.46 | 80.43 | 40.01 | 205 | 98.53 |
|  Authenticate Super Tenant User | 300 | Authenticate | 0 | 1712.51 | 174.99 | 86.89 | 447 | 98.35 |
|  Authenticate Super Tenant User | 500 | Authenticate | 0 | 1784.46 | 280.16 | 93.54 | 591 | 98.23 |
|  Auth Code Grant Redirect With Consent | 50 | Authorize Request | 0 | 179.65 | 65.47 | 33.96 | 206 | 98.17 |
|  Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 179.66 | 83.33 | 36.3 | 233 | 98.17 |
|  Auth Code Grant Redirect With Consent | 50 | Get access token | 0 | 179.67 | 92.34 | 36.14 | 237 | 98.17 |
|  Auth Code Grant Redirect With Consent | 50 | Send request to authorize end poiont | 0 | 179.66 | 36.29 | 23.76 | 157 | 98.17 |
|  Auth Code Grant Redirect With Consent | 100 | Authorize Request | 0 | 192.23 | 125.21 | 56.6 | 319 | 97.93 |
|  Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 192.27 | 159.75 | 53.2 | 355 | 97.93 |
|  Auth Code Grant Redirect With Consent | 100 | Get access token | 0 | 192.21 | 169.64 | 54.68 | 363 | 97.93 |
|  Auth Code Grant Redirect With Consent | 100 | Send request to authorize end poiont | 0 | 192.28 | 64.67 | 34.67 | 199 | 97.93 |
|  Auth Code Grant Redirect With Consent | 150 | Authorize Request | 0 | 196.88 | 184.03 | 81.28 | 441 | 97.75 |
|  Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 196.85 | 235.85 | 70.81 | 457 | 97.75 |
|  Auth Code Grant Redirect With Consent | 150 | Get access token | 0 | 196.86 | 249.24 | 71.13 | 477 | 97.75 |
|  Auth Code Grant Redirect With Consent | 150 | Send request to authorize end poiont | 0 | 196.89 | 92.18 | 43.65 | 247 | 97.75 |
|  Auth Code Grant Redirect With Consent | 300 | Authorize Request | 0 | 196.31 | 365.87 | 135.1 | 779 | 97.54 |
|  Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 196.34 | 458.28 | 131.67 | 795 | 97.54 |
|  Auth Code Grant Redirect With Consent | 300 | Get access token | 0 | 196.24 | 487.47 | 121.06 | 847 | 97.54 |
|  Auth Code Grant Redirect With Consent | 300 | Send request to authorize end poiont | 0 | 196.35 | 216.43 | 80.76 | 483 | 97.54 |
|  Auth Code Grant Redirect With Consent | 500 | Authorize Request | 0 | 197.77 | 617.82 | 149.75 | 1047 | 97.45 |
|  Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 197.88 | 699.49 | 138.59 | 1039 | 97.45 |
|  Auth Code Grant Redirect With Consent | 500 | Get access token | 0 | 197.86 | 736.53 | 132.48 | 1119 | 97.45 |
|  Auth Code Grant Redirect With Consent | 500 | Send request to authorize end poiont | 0 | 197.91 | 472.3 | 148.84 | 1303 | 97.45 |
|  Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 254.51 | 99.77 | 55.19 | 323 | 98.47 |
|  Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 254.5 | 50.78 | 34.23 | 185 | 98.47 |
|  Implicit Grant Redirect With Consent | 50 | Send request to authorize end point | 0 | 254.51 | 45.29 | 36.79 | 185 | 98.47 |
|  Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 277.21 | 180.45 | 76.3 | 449 | 98.23 |
|  Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 277.24 | 101.87 | 55.87 | 297 | 98.23 |
|  Implicit Grant Redirect With Consent | 100 | Send request to authorize end point | 0 | 277.23 | 77.77 | 50.7 | 277 | 98.23 |
|  Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 284.25 | 262.1 | 91.12 | 551 | 98.04 |
|  Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 284.28 | 154.35 | 76.38 | 387 | 98.04 |
|  Implicit Grant Redirect With Consent | 150 | Send request to authorize end point | 0 | 284.31 | 110.72 | 61.01 | 331 | 98.04 |
|  Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 297.25 | 469.75 | 131.3 | 803 | 97.64 |
|  Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 297.46 | 295.15 | 110.9 | 607 | 97.64 |
|  Implicit Grant Redirect With Consent | 300 | Send request to authorize end point | 0 | 297.38 | 243.74 | 89.2 | 523 | 97.64 |
|  Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 295.99 | 698.79 | 151.16 | 1095 | 97.48 |
|  Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0 | 296.13 | 514.82 | 139.83 | 935 | 97.48 |
|  Implicit Grant Redirect With Consent | 500 | Send request to authorize end point | 0 | 296.02 | 474.89 | 126.35 | 855 | 97.48 |
|  Password Grant Type | 50 | GetToken_Password_Grant | 0 | 1559.41 | 31.89 | 15.04 | 72 | 98.78 |
|  Password Grant Type | 100 | GetToken_Password_Grant | 0 | 1521.62 | 65.54 | 26.66 | 150 | 98.58 |
|  Password Grant Type | 150 | GetToken_Password_Grant | 0 | 1542.29 | 97.07 | 39.23 | 220 | 98.44 |
|  Password Grant Type | 300 | GetToken_Password_Grant | 0 | 1536.04 | 195.15 | 84.09 | 449 | 98.16 |
|  Password Grant Type | 500 | GetToken_Password_Grant | 0 | 1537.7 | 325.26 | 92.55 | 631 | 98.14 |
|  Client Credentials Grant Type | 50 | Get Token Client Credential Grant | 0 | 8874.53 | 5.44 | 3.85 | 23 | 98.63 |
|  Client Credentials Grant Type | 100 | Get Token Client Credential Grant | 0 | 8780.08 | 11.18 | 5.21 | 38 | 98.61 |
|  Client Credentials Grant Type | 150 | Get Token Client Credential Grant | 0 | 9012.58 | 16.37 | 7.01 | 53 | 98.56 |
|  Client Credentials Grant Type | 300 | Get Token Client Credential Grant | 0 | 9119.78 | 32.48 | 14.9 | 108 | 98.37 |
|  Client Credentials Grant Type | 500 | Get Token Client Credential Grant | 0 | 8881.05 | 55.8 | 20.68 | 155 | 98.07 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Authorize call | 0 | 157.18 | 75.7 | 51.28 | 259 | 98.43 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 157.21 | 94.73 | 53.46 | 283 | 98.43 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Get tokens | 0 | 157.16 | 103.08 | 52.77 | 301 | 98.43 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Send request to authorize end poiont | 0 | 157.21 | 43.73 | 35.49 | 176 | 98.43 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Authorize call | 0 | 179.74 | 131.28 | 60.15 | 337 | 98.15 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 179.71 | 168.59 | 64.49 | 377 | 98.15 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Get tokens | 0 | 179.69 | 180.83 | 61.12 | 385 | 98.15 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Send request to authorize end poiont | 0 | 179.74 | 74.93 | 42.91 | 219 | 98.15 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Authorize call | 0 | 190.66 | 189.17 | 73.21 | 425 | 97.92 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 190.71 | 238.14 | 75.55 | 477 | 97.92 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Get tokens | 0 | 190.71 | 254.97 | 72.69 | 503 | 97.92 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Send request to authorize end poiont | 0 | 190.78 | 103.69 | 48.81 | 273 | 97.92 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Authorize call | 0 | 199.09 | 367.52 | 113.71 | 719 | 97.66 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 199.11 | 441.08 | 105.74 | 727 | 97.66 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Get tokens | 0 | 199.06 | 474.27 | 104.15 | 783 | 97.66 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Send request to authorize end poiont | 0 | 199.09 | 223.97 | 73.17 | 471 | 97.66 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Authorize call | 0 | 198.12 | 616.39 | 131.21 | 1003 | 97.63 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 198.04 | 693.75 | 137.7 | 1047 | 97.63 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Get tokens | 0 | 198.15 | 727.92 | 126.05 | 1087 | 97.63 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Send request to authorize end poiont | 0 | 198.13 | 484.24 | 157.05 | 1303 | 97.63 |
|  OIDC Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 191.11 | 109.36 | 59.28 | 291 | 98.42 |
|  OIDC Implicit Grant Redirect With Consent | 50 | Get Tokens | 0 | 191.11 | 99.83 | 52.46 | 263 | 98.42 |
|  OIDC Implicit Grant Redirect With Consent | 50 | Send request to authorize end point | 0 | 191.11 | 51.78 | 40.42 | 184 | 98.42 |
|  OIDC Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 205.71 | 200.17 | 74.99 | 399 | 98.11 |
|  OIDC Implicit Grant Redirect With Consent | 100 | Get Tokens | 0 | 205.74 | 191.03 | 70.65 | 397 | 98.11 |
|  OIDC Implicit Grant Redirect With Consent | 100 | Send request to authorize end point | 0 | 205.7 | 94.37 | 54.92 | 250 | 98.11 |
|  OIDC Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 219.52 | 276.8 | 91.66 | 543 | 97.97 |
|  OIDC Implicit Grant Redirect With Consent | 150 | Get Tokens | 0 | 219.55 | 276.66 | 95.63 | 567 | 97.97 |
|  OIDC Implicit Grant Redirect With Consent | 150 | Send request to authorize end point | 0 | 219.62 | 129.42 | 64.18 | 327 | 97.97 |
|  OIDC Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 236.68 | 489.77 | 138.47 | 835 | 97.58 |
|  OIDC Implicit Grant Redirect With Consent | 300 | Get Tokens | 0 | 236.67 | 513.07 | 151.43 | 943 | 97.58 |
|  OIDC Implicit Grant Redirect With Consent | 300 | Send request to authorize end point | 0 | 236.76 | 264.36 | 89.64 | 531 | 97.58 |
|  OIDC Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 232.94 | 798.72 | 156.73 | 1287 | 97.57 |
|  OIDC Implicit Grant Redirect With Consent | 500 | Get Tokens | 0 | 233.04 | 782.99 | 180.52 | 1327 | 97.57 |
|  OIDC Implicit Grant Redirect With Consent | 500 | Send request to authorize end point | 0 | 233.08 | 562.56 | 150.06 | 1039 | 97.57 |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Send request to authorize end poiont | 0 | 162.11 | 202.24 | 95.7 | 477 | 98.54 |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Send request to authorize end poiont | 0 | 196.38 | 329.61 | 95.41 | 595 | 98.36 |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Send request to authorize end poiont | 0 | 205.77 | 467.72 | 111.51 | 815 | 98.24 |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Send request to authorize end poiont | 0 | 214.39 | 862.27 | 156.36 | 1223 | 97.98 |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Send request to authorize end poiont | 0 | 214.3 | 1327.64 | 250.23 | 2367 | 97.88 |
|  SAML2 SSO Redirect Binding | 50 | Identity Provider Login | 0 | 171.33 | 221.88 | 98.73 | 469 | 97.46 |
|  SAML2 SSO Redirect Binding | 50 | Initial SAML Request | 0 | 171.34 | 68.92 | 40.85 | 197 | 97.46 |
|  SAML2 SSO Redirect Binding | 100 | Identity Provider Login | 0 | 196.14 | 380.31 | 122.11 | 695 | 96.91 |
|  SAML2 SSO Redirect Binding | 100 | Initial SAML Request | 0 | 196.16 | 128.61 | 63.16 | 329 | 96.91 |
|  SAML2 SSO Redirect Binding | 150 | Identity Provider Login | 0 | 211.84 | 520.72 | 167.68 | 915 | 96.73 |
|  SAML2 SSO Redirect Binding | 150 | Initial SAML Request | 0 | 211.99 | 186.13 | 98.43 | 499 | 96.73 |
|  SAML2 SSO Redirect Binding | 300 | Identity Provider Login | 0 | 231.75 | 906.03 | 247.41 | 1583 | 95.97 |
|  SAML2 SSO Redirect Binding | 300 | Initial SAML Request | 0 | 231.84 | 386.16 | 186.64 | 1015 | 95.97 |
|  SAML2 SSO Redirect Binding | 500 | Identity Provider Login | 0 | 229.44 | 1511.57 | 270.05 | 2511 | 95.88 |
|  SAML2 SSO Redirect Binding | 500 | Initial SAML Request | 0 | 229.31 | 663.27 | 200.36 | 1375 | 95.88 |
|  Challange questions by super tenant users | 50 | Answear to a collection of  new challanges | 2.43 | 131.24 | 155.15 | 44.42 | 271 | 98.02 |
|  Challange questions by super tenant users | 50 | Answer new challenge question combination over existing answers. | 1.25 | 131.26 | 85.4 | 30.99 | 174 | 98.02 |
|  Challange questions by super tenant users | 50 | Get user's answered challanges | 0 | 131.25 | 41.6 | 19.77 | 102 | 98.02 |
|  Challange questions by super tenant users | 50 | Remove challenge question answers | 0 | 131.25 | 41.6 | 19.77 | 102 | 98.02 |
|  Challange questions by super tenant users | 50 | Retrieve available challanges | 0 | 131.25 | 42.19 | 21.82 | 111 | 98.02 |
|  Challange questions by super tenant users | 50 | clean answeared questions | 100 | 2083.33 | 0.46 | 1.68 | 1 | 98.02 |
|  Challange questions by super tenant users | 100 | Answear to a collection of  new challanges | 4.67 | 132.97 | 293.06 | 103.05 | 551 | 97.72 |
|  Challange questions by super tenant users | 100 | Answer new challenge question combination over existing answers. | 2.91 | 132.96 | 179.36 | 75.71 | 395 | 97.72 |
|  Challange questions by super tenant users | 100 | Get user's answered challanges | 0 | 132.96 | 85.4 | 53.31 | 254 | 97.72 |
|  Challange questions by super tenant users | 100 | Remove challenge question answers | 0 | 132.96 | 85.4 | 53.31 | 254 | 97.72 |
|  Challange questions by super tenant users | 100 | Retrieve available challanges | 0 | 132.97 | 95.54 | 62.02 | 289 | 97.72 |
|  Challange questions by super tenant users | 100 | clean answeared questions | 100 | 2079 | 0.47 | 1.8 | 1 | 97.72 |
|  Challange questions by super tenant users | 150 | Answear to a collection of  new challanges | 6.99 | 129.86 | 428.78 | 157.27 | 823 | 97.53 |
|  Challange questions by super tenant users | 150 | Answer new challenge question combination over existing answers. | 4.93 | 129.86 | 276.67 | 124.36 | 627 | 97.53 |
|  Challange questions by super tenant users | 150 | Get user's answered challanges | 0 | 129.84 | 140.69 | 98.24 | 453 | 97.53 |
|  Challange questions by super tenant users | 150 | Remove challenge question answers | 0 | 129.84 | 140.69 | 98.24 | 453 | 97.53 |
|  Challange questions by super tenant users | 150 | Retrieve available challanges | 0 | 129.89 | 165.58 | 114.74 | 515 | 97.53 |
|  Challange questions by super tenant users | 150 | clean answeared questions | 100 | 2192.98 | 0.43 | 1.8 | 1 | 97.53 |
|  Challange questions by super tenant users | 300 | Answear to a collection of  new challanges | 13 | 128.39 | 769.37 | 303.2 | 1655 | 97.12 |
|  Challange questions by super tenant users | 300 | Answer new challenge question combination over existing answers. | 9.6 | 128.38 | 560.63 | 232.48 | 1319 | 97.12 |
|  Challange questions by super tenant users | 300 | Get user's answered challanges | 0 | 128.38 | 319.31 | 177.72 | 903 | 97.12 |
|  Challange questions by super tenant users | 300 | Remove challenge question answers | 0 | 128.38 | 319.31 | 177.72 | 903 | 97.12 |
|  Challange questions by super tenant users | 300 | Retrieve available challanges | 0 | 128.43 | 376.4 | 205.55 | 1015 | 97.12 |
|  Challange questions by super tenant users | 300 | clean answeared questions | 100 | 2164.5 | 0.44 | 1.82 | 1 | 97.12 |
|  Challange questions by super tenant users | 500 | Answear to a collection of  new challanges | 20.81 | 132.36 | 1031.43 | 310.84 | 1871 | 97.23 |
|  Challange questions by super tenant users | 500 | Answer new challenge question combination over existing answers. | 14.97 | 132.34 | 839.2 | 240.27 | 1591 | 97.23 |
|  Challange questions by super tenant users | 500 | Get user's answered challanges | 0 | 132.35 | 621.69 | 225.76 | 1599 | 97.23 |
|  Challange questions by super tenant users | 500 | Remove challenge question answers | 0 | 132.35 | 621.69 | 225.76 | 1599 | 97.23 |
|  Challange questions by super tenant users | 500 | Retrieve available challanges | 0 | 132.35 | 675.67 | 260.29 | 1727 | 97.23 |
|  Challange questions by super tenant users | 500 | clean answeared questions | 100 | 2257.34 | 0.41 | 1.64 | 1 | 97.23 |
|  Refresh token refresh grant | 50 | Get refresh token form map | 0 | 326.75 | 1083.08 | 667.28 | 3183 | 99.65 |
|  Refresh token refresh grant | 50 | TEST - Refresh Token Request | 0 | 332.8 | 14.18 | 33.48 | 113 | 99.65 |
|  Refresh token refresh grant | 100 | Get refresh token form map | 0 | 328.55 | 1111.24 | 687.03 | 3279 | 99.66 |
|  Refresh token refresh grant | 100 | TEST - Refresh Token Request | 0 | 334.75 | 13.87 | 25.86 | 115 | 99.66 |
|  Refresh token refresh grant | 150 | Get refresh token form map | 0 | 324.86 | 1094.17 | 674.12 | 3183 | 99.64 |
|  Refresh token refresh grant | 150 | TEST - Refresh Token Request | 0 | 331.12 | 15.85 | 32.1 | 144 | 99.64 |
|  Refresh token refresh grant | 300 | Get refresh token form map | 0 | 333.01 | 1156.3 | 711.48 | 3359 | 99.64 |
|  Refresh token refresh grant | 300 | TEST - Refresh Token Request | 0 | 340.26 | 15.39 | 35.24 | 134 | 99.64 |
|  Refresh token refresh grant | 500 | Get refresh token form map | 0 | 329.42 | 1159.95 | 702.92 | 3279 | 99.65 |
|  Refresh token refresh grant | 500 | TEST - Refresh Token Request | 0 | 336.5 | 15.62 | 29.27 | 142 | 99.65 |
