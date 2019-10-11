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

Two [**c5.large** Amazon EC2 instance](https://aws.amazon.com/ec2/instance-types/)s were used to install WSO2 Identity Server.

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
|  Authenticate Super Tenant User | 50 | Authenticate | 0 | 872.45 | 57.11 | 35.42 | 173 | 98.16 |  |
|  Authenticate Super Tenant User | 100 | Authenticate | 0 | 871.09 | 114.57 | 70.61 | 287 | 98.04 |  |
|  Authenticate Super Tenant User | 150 | Authenticate | 0 | 858.65 | 174.59 | 132.85 | 433 | 97.83 |  |
|  Authenticate Super Tenant User | 300 | Authenticate | 0 | 850.07 | 351.62 | 693.02 | 3375 | 98.24 |  |
|  Authenticate Super Tenant User | 500 | Authenticate | 1.22 | 853.1 | 576.21 | 1751.78 | 7391 | 97.98 |  |
|  Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 135.29 | 78.89 | 28.93 | 175 | 98.43 |  |
|  Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 135.31 | 43.43 | 19.31 | 111 | 98.43 |  |
|  Auth Code Grant Redirect With Consent | 50 | Get Authorization Code | 0 | 135.29 | 67.97 | 30.84 | 181 | 98.43 |  |
|  Auth Code Grant Redirect With Consent | 50 | Get access token | 0 | 135.29 | 130.3 | 37 | 248 | 98.43 |  |
|  Auth Code Grant Redirect With Consent | 50 | Send request to authorize end poiont | 0 | 135.3 | 47.89 | 26.75 | 143 | 98.43 |  |
|  Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 140.92 | 149.06 | 55.27 | 329 | 97.68 |  |
|  Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 140.94 | 99.37 | 43.86 | 219 | 97.68 |  |
|  Auth Code Grant Redirect With Consent | 100 | Get Authorization Code | 0 | 140.91 | 134.05 | 53.11 | 299 | 97.68 |  |
|  Auth Code Grant Redirect With Consent | 100 | Get access token | 0 | 140.92 | 220.48 | 72.11 | 437 | 97.68 |  |
|  Auth Code Grant Redirect With Consent | 100 | Send request to authorize end poiont | 0 | 140.92 | 105.63 | 44.84 | 237 | 97.68 |  |
|  Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 144.3 | 215.09 | 100.29 | 451 | 97.88 |  |
|  Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 144.3 | 169.72 | 92.77 | 375 | 97.88 |  |
|  Auth Code Grant Redirect With Consent | 150 | Get Authorization Code | 0 | 144.31 | 201.67 | 98.74 | 439 | 97.88 |  |
|  Auth Code Grant Redirect With Consent | 150 | Get access token | 0 | 144.33 | 275.26 | 107.05 | 535 | 97.88 |  |
|  Auth Code Grant Redirect With Consent | 150 | Send request to authorize end poiont | 0 | 144.31 | 177.04 | 97.19 | 395 | 97.88 |  |
|  Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 140.87 | 418 | 455.33 | 1863 | 97.45 |  |
|  Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 140.94 | 396.71 | 500.27 | 2255 | 97.45 |  |
|  Auth Code Grant Redirect With Consent | 300 | Get Authorization Code | 0 | 140.79 | 410.08 | 485.92 | 1911 | 97.45 |  |
|  Auth Code Grant Redirect With Consent | 300 | Get access token | 0 | 140.82 | 497.57 | 495.43 | 2335 | 97.45 |  |
|  Auth Code Grant Redirect With Consent | 300 | Send request to authorize end poiont | 0 | 140.84 | 404.25 | 516.84 | 2271 | 97.45 |  |
|  Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 2.07 | 136.53 | 741.21 | 2182.06 | 7775 | 97.33 |  |
|  Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 1.64 | 134.93 | 665.34 | 1910.77 | 7679 | 97.33 |  |
|  Auth Code Grant Redirect With Consent | 500 | Get Authorization Code | 1.61 | 136.56 | 686.39 | 1921.14 | 7647 | 97.33 |  |
|  Auth Code Grant Redirect With Consent | 500 | Get access token | 0.98 | 136.2 | 788.01 | 1822.63 | 7807 | 97.33 |  |
|  Auth Code Grant Redirect With Consent | 500 | Send request to authorize end poiont | 1.63 | 139.32 | 607.01 | 1772.65 | 7551 | 97.33 |  |
|  Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 210.51 | 84.67 | 31.4 | 187 | 98.43 |  |
|  Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 210.52 | 50 | 22.14 | 123 | 98.43 |  |
|  Implicit Grant Redirect With Consent | 50 | Get Access token | 0 | 210.52 | 48.27 | 20.67 | 121 | 98.43 |  |
|  Implicit Grant Redirect With Consent | 50 | Send request to authorize end point | 0 | 210.51 | 53.76 | 27.45 | 148 | 98.43 |  |
|  Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 212.26 | 151.75 | 82.99 | 387 | 97.47 |  |
|  Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 212.26 | 104.57 | 63.76 | 277 | 97.47 |  |
|  Implicit Grant Redirect With Consent | 100 | Get Access token | 0 | 212.26 | 103.24 | 65.01 | 285 | 97.47 |  |
|  Implicit Grant Redirect With Consent | 100 | Send request to authorize end point | 0 | 212.26 | 110.74 | 66.75 | 285 | 97.47 |  |
|  Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 217.91 | 202 | 120.62 | 481 | 97.32 |  |
|  Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 217.92 | 158.9 | 109.03 | 387 | 97.32 |  |
|  Implicit Grant Redirect With Consent | 150 | Get Access token | 0 | 217.92 | 157.75 | 109.77 | 391 | 97.32 |  |
|  Implicit Grant Redirect With Consent | 150 | Send request to authorize end point | 0 | 217.93 | 169.25 | 113.41 | 405 | 97.32 |  |
|  Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 214.19 | 385.92 | 619.52 | 3375 | 97.36 |  |
|  Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 213.99 | 352.92 | 604.4 | 3375 | 97.36 |  |
|  Implicit Grant Redirect With Consent | 300 | Get Access token | 0 | 213.97 | 338.18 | 583.45 | 3343 | 97.36 |  |
|  Implicit Grant Redirect With Consent | 300 | Send request to authorize end point | 0 | 213.94 | 320.64 | 525.89 | 1871 | 97.36 |  |
|  Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 1.44 | 210.74 | 659.88 | 1800.22 | 7615 | 97.37 |  |
|  Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 1.1 | 213.98 | 584.46 | 1707.24 | 7519 | 97.37 |  |
|  Implicit Grant Redirect With Consent | 500 | Get Access token | 2.02 | 213.99 | 571.62 | 1686.63 | 7327 | 97.37 |  |
|  Implicit Grant Redirect With Consent | 500 | Send request to authorize end point | 1.13 | 214.21 | 496.54 | 1353.47 | 4255 | 97.37 |  |
|  Password Grant Type | 50 | GetToken_Password_Grant | 0 | 943.78 | 52.81 | 23.28 | 130 | 98.9 |  |
|  Password Grant Type | 100 | GetToken_Password_Grant | 0 | 930.81 | 107.23 | 64.96 | 244 | 98.74 |  |
|  Password Grant Type | 150 | GetToken_Password_Grant | 0 | 921.08 | 162.76 | 109.19 | 357 | 98.84 |  |
|  Password Grant Type | 300 | GetToken_Password_Grant | 0 | 910.29 | 328.3 | 563.22 | 3311 | 98.71 |  |
|  Password Grant Type | 500 | GetToken_Password_Grant | 0.72 | 899.02 | 534.27 | 1438.17 | 6655 | 98.61 |  |
|  Client Credentials Grant Type | 50 | Get Token Client Credential Grant | 0 | 2567.23 | 19.31 | 42.05 | 70 | 99.01 |  |
|  Client Credentials Grant Type | 100 | Get Token Client Credential Grant | 0 | 2654.91 | 37.51 | 23.28 | 123 | 98.95 |  |
|  Client Credentials Grant Type | 150 | Get Token Client Credential Grant | 0 | 2668.64 | 56.01 | 38.66 | 189 | 98.81 |  |
|  Client Credentials Grant Type | 300 | Get Token Client Credential Grant | 0 | 2648.02 | 112.99 | 197.88 | 1143 | 98.74 |  |
|  Client Credentials Grant Type | 500 | Get Token Client Credential Grant | 0 | 2628.64 | 189.14 | 453.15 | 1559 | 98.66 |  |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 130.23 | 81.38 | 32.63 | 185 | 98.54 |  |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 130.24 | 45 | 22.12 | 118 | 98.54 |  |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Get Authorization Code | 0 | 130.24 | 72.03 | 37.01 | 197 | 98.54 |  |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Get tokens | 0 | 130.24 | 133.51 | 42.91 | 267 | 98.54 |  |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Send request to authorize end poiont | 0 | 130.23 | 50.93 | 31.49 | 155 | 98.54 |  |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 140.93 | 149.6 | 61.7 | 319 | 97.49 |  |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 140.94 | 99.02 | 49.47 | 235 | 97.49 |  |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Get Authorization Code | 0 | 140.95 | 135.9 | 63.71 | 309 | 97.49 |  |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Get tokens | 0 | 140.94 | 217.29 | 70.61 | 405 | 97.49 |  |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Send request to authorize end poiont | 0 | 140.93 | 106.67 | 57.07 | 259 | 97.49 |  |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 141.83 | 219.95 | 110.17 | 459 | 98.3 |  |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 141.86 | 163.55 | 100.81 | 375 | 98.3 |  |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Get Authorization Code | 0 | 141.86 | 204.74 | 111.37 | 455 | 98.3 |  |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Get tokens | 0 | 141.84 | 292.84 | 111.9 | 547 | 98.3 |  |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Send request to authorize end poiont | 0 | 141.83 | 175.87 | 108.88 | 403 | 98.3 |  |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 141.12 | 415.64 | 534.55 | 2175 | 97.36 |  |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 141.16 | 383.15 | 621.78 | 3407 | 97.36 |  |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Get Authorization Code | 0 | 141.15 | 396.33 | 536.29 | 2271 | 97.36 |  |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Get tokens | 0 | 141.12 | 533.2 | 589.41 | 3503 | 97.36 |  |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Send request to authorize end poiont | 0 | 141.16 | 376.2 | 572.18 | 2703 | 97.36 |  |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 1.28 | 142.94 | 707.17 | 1221.81 | 4287 | 97.41 |  |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 1.01 | 142.65 | 651.41 | 1196.56 | 3871 | 97.41 |  |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Get Authorization Code | 1.73 | 142.68 | 652.72 | 1010.2 | 3855 | 97.41 |  |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Get tokens | 0.61 | 140.75 | 836.34 | 1223.46 | 4383 | 97.41 |  |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Send request to authorize end poiont | 1.03 | 142.65 | 635.48 | 995.46 | 3807 | 97.41 |  |
|  OIDC Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 90.35 | 153.51 | 59.74 | 333 | 99.67 |  |
|  OIDC Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 90.35 | 99.05 | 37.05 | 218 | 99.67 |  |
|  OIDC Implicit Grant Redirect With Consent | 50 | Get tokens | 0 | 90.35 | 195.33 | 68.57 | 387 | 99.67 |  |
|  OIDC Implicit Grant Redirect With Consent | 50 | Send request to authorize end point | 0 | 90.35 | 104.73 | 40.9 | 231 | 99.67 |  |
|  OIDC Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 89.38 | 296.08 | 74.56 | 503 | 99.66 |  |
|  OIDC Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 89.41 | 239.87 | 50.59 | 379 | 99.66 |  |
|  OIDC Implicit Grant Redirect With Consent | 100 | Get tokens | 0 | 89.41 | 334.96 | 83.93 | 563 | 99.66 |  |
|  OIDC Implicit Grant Redirect With Consent | 100 | Send request to authorize end point | 0 | 89.4 | 247.39 | 53.26 | 397 | 99.66 |  |
|  OIDC Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 88.56 | 440.22 | 126.61 | 747 | 99.65 |  |
|  OIDC Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 88.59 | 380.98 | 124.73 | 1319 | 99.65 |  |
|  OIDC Implicit Grant Redirect With Consent | 150 | Get tokens | 0 | 88.54 | 484.06 | 134.96 | 819 | 99.65 |  |
|  OIDC Implicit Grant Redirect With Consent | 150 | Send request to authorize end point | 0 | 88.53 | 388.55 | 130.93 | 1343 | 99.65 |  |
|  OIDC Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 87.16 | 850.59 | 1129.52 | 4319 | 99.67 |  |
|  OIDC Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0.01 | 86.92 | 847.87 | 1228.66 | 4319 | 99.67 |  |
|  OIDC Implicit Grant Redirect With Consent | 300 | Get tokens | 0.01 | 86.75 | 850.05 | 1069.35 | 4191 | 99.67 |  |
|  OIDC Implicit Grant Redirect With Consent | 300 | Send request to authorize end point | 0 | 86.92 | 882.36 | 1104.68 | 4767 | 99.67 |  |
|  OIDC Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 4.69 | 90.98 | 1362.18 | 2691.51 | 10687 | 99.68 |  |
|  OIDC Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 4.11 | 91.19 | 1386.93 | 2933.64 | 11071 | 99.68 |  |
|  OIDC Implicit Grant Redirect With Consent | 500 | Get tokens | 5.64 | 90.97 | 1309.23 | 2676.56 | 9343 | 99.68 |  |
|  OIDC Implicit Grant Redirect With Consent | 500 | Send request to authorize end point | 4.21 | 91.04 | 1349.91 | 2751.33 | 14463 | 99.68 |  |
|  OIDC Password Grant Type | 50 | GetToken_Password_Grant | 0 | 475.47 | 104.97 | 46.43 | 248 | 99.2 |  |
|  OIDC Password Grant Type | 100 | GetToken_Password_Grant | 0 | 462.01 | 216.37 | 126.9 | 481 | 99.18 |  |
|  OIDC Password Grant Type | 150 | GetToken_Password_Grant | 0 | 459.3 | 326.36 | 232.78 | 723 | 99.15 |  |
|  OIDC Password Grant Type | 300 | GetToken_Password_Grant | 0 | 449.66 | 647.64 | 1083.78 | 3983 | 98.83 |  |
|  OIDC Password Grant Type | 500 | GetToken_Password_Grant | 2.29 | 457.92 | 1013.89 | 2465.18 | 9471 | 99.04 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Get Authorization Code | 0 | 143.92 | 68.22 | 34.61 | 190 | 98.56 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Get tokens | 0 | 143.91 | 127.45 | 38.43 | 255 | 98.56 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Send request to authorize end poiont | 0 | 143.92 | 151.08 | 53.3 | 315 | 98.56 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Get Authorization Code | 0 | 164.88 | 122.68 | 54.76 | 287 | 97.54 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Get tokens | 0 | 164.88 | 222.04 | 71.37 | 433 | 97.54 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Send request to authorize end poiont | 0 | 164.85 | 261.36 | 86.96 | 511 | 97.54 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Get Authorization Code | 0 | 165.08 | 219.58 | 119.9 | 497 | 97.23 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Get tokens | 0 | 165.05 | 323.79 | 125.92 | 631 | 97.23 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Send request to authorize end poiont | 0 | 165.07 | 365.02 | 135.4 | 683 | 97.23 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Get Authorization Code | 0 | 157.22 | 587.87 | 862.16 | 3839 | 97.91 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Get tokens | 0 | 157.04 | 611.02 | 738.45 | 3807 | 97.91 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Send request to authorize end poiont | 0 | 157.07 | 705.74 | 807.76 | 3967 | 97.91 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Get Authorization Code | 2.87 | 155.63 | 1081.02 | 2903.53 | 9471 | 97.58 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Get tokens | 1.43 | 155.63 | 975.01 | 2067.88 | 8511 | 97.58 |  |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Send request to authorize end poiont | 2.37 | 158.99 | 982.81 | 2204.15 | 8255 | 97.58 |  |
|  SAML2 SSO Redirect Binding | 50 | Identity Provider Login | 0 | 196.91 | 192.26 | 74.43 | 395 | 98.08 |  |
|  SAML2 SSO Redirect Binding | 50 | Initial SAML Request | 0 | 196.98 | 60.49 | 35.56 | 168 | 98.08 |  |
|  SAML2 SSO Redirect Binding | 100 | Identity Provider Login | 0 | 206.64 | 349.01 | 143.25 | 691 | 97.93 |  |
|  SAML2 SSO Redirect Binding | 100 | Initial SAML Request | 0 | 206.7 | 133.82 | 72.86 | 331 | 97.93 |  |
|  SAML2 SSO Redirect Binding | 150 | Identity Provider Login | 0 | 207.24 | 505.2 | 281.75 | 1047 | 97.97 |  |
|  SAML2 SSO Redirect Binding | 150 | Initial SAML Request | 0 | 207.3 | 217.18 | 149.37 | 539 | 97.97 |  |
|  SAML2 SSO Redirect Binding | 300 | Identity Provider Login | 0 | 198.17 | 1018.71 | 1336.18 | 5887 | 98.12 |  |
|  SAML2 SSO Redirect Binding | 300 | Initial SAML Request | 0 | 198.22 | 477.8 | 873.48 | 3711 | 98.12 |  |
|  SAML2 SSO Redirect Binding | 500 | Identity Provider Login | 1.12 | 198.02 | 1708.13 | 3312.14 | 16511 | 97.92 |  |
|  SAML2 SSO Redirect Binding | 500 | Initial SAML Request | 4.21 | 206.7 | 743.12 | 2015.38 | 7839 | 97.92 |  |
