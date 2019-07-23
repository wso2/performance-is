# IAM Performance Test Results

During each release, we execute various automated performance test scenarios and publish the results.

| Test Scenarios | Description |
| --- | --- |
| Authenticate Super Tenant User | Select random super tenant users and authenticate through the RemoteUserStoreManagerService. |
| Auth Code Grant Redirect With Consent | Obtain an access token using the OAuth 2.0 authorization code grant type. |
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
| IS Instance Type | The AWS instance type used to run the Identity Server. | [**c5.large**](https://aws.amazon.com/ec2/instance-types/) |

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
|  Authenticate Super Tenant User | 50 | Authenticate | 0 | 868.88 | 57.37 | 32.65 | 138 | 98.86 |
|  Authenticate Super Tenant User | 100 | Authenticate | 0 | 749.71 | 133.19 | 66.9 | 305 | 98.78 |
|  Authenticate Super Tenant User | 150 | Authenticate | 0 | 763.24 | 196.32 | 106.25 | 497 | 98.63 |
|  Authenticate Super Tenant User | 300 | Authenticate | 0 | 674.02 | 444.94 | 238.47 | 1135 | 98.22 |
|  Authenticate Super Tenant User | 500 | Authenticate | 0 | 705.69 | 707.91 | 362.6 | 1791 | 97.33 |
|  Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 69.77 | 135.73 | 35.81 | 246 | 98.11 |
|  Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 69.75 | 63.98 | 24.08 | 149 | 98.11 |
|  Auth Code Grant Redirect With Consent | 50 | Get Authorization Code | 0 | 69.74 | 102.29 | 34.18 | 213 | 98.11 |
|  Auth Code Grant Redirect With Consent | 50 | Get access token | 0 | 69.74 | 344.58 | 58.21 | 491 | 98.11 |
|  Auth Code Grant Redirect With Consent | 50 | Send request to authorize end poiont | 0 | 69.78 | 69.58 | 51.06 | 355 | 98.11 |
|  Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 66.04 | 292.91 | 64.34 | 477 | 98.08 |
|  Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 66.06 | 147.7 | 48.88 | 313 | 98.08 |
|  Auth Code Grant Redirect With Consent | 100 | Get Authorization Code | 0 | 66.03 | 213.98 | 56.46 | 393 | 98.08 |
|  Auth Code Grant Redirect With Consent | 100 | Get access token | 0 | 66.04 | 703.82 | 93.23 | 927 | 98.08 |
|  Auth Code Grant Redirect With Consent | 100 | Send request to authorize end poiont | 0 | 66 | 155.24 | 106.11 | 771 | 98.08 |
|  Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 64.52 | 460.1 | 127.85 | 795 | 98.09 |
|  Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 64.58 | 246.24 | 96.57 | 539 | 98.09 |
|  Auth Code Grant Redirect With Consent | 150 | Get Authorization Code | 0 | 64.58 | 331.91 | 109.09 | 639 | 98.09 |
|  Auth Code Grant Redirect With Consent | 150 | Get access token | 0 | 64.56 | 1036.11 | 173.5 | 1447 | 98.09 |
|  Auth Code Grant Redirect With Consent | 150 | Send request to authorize end poiont | 0 | 64.55 | 248.3 | 164.44 | 1111 | 98.09 |
|  Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 61.84 | 987.22 | 292.28 | 1775 | 97.9 |
|  Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 61.89 | 571.36 | 251.16 | 1367 | 97.9 |
|  Auth Code Grant Redirect With Consent | 300 | Get Authorization Code | 0 | 61.87 | 727.97 | 275.18 | 1583 | 97.9 |
|  Auth Code Grant Redirect With Consent | 300 | Get access token | 0 | 61.86 | 1978.52 | 412.35 | 2991 | 97.9 |
|  Auth Code Grant Redirect With Consent | 300 | Send request to authorize end poiont | 0 | 61.78 | 579.23 | 371.13 | 2335 | 97.9 |
|  Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 56.27 | 1748.87 | 519.51 | 3183 | 97.62 |
|  Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0 | 56.34 | 1166.07 | 536.66 | 2783 | 97.62 |
|  Auth Code Grant Redirect With Consent | 500 | Get Authorization Code | 0 | 56.6 | 1338.58 | 537.91 | 3007 | 97.62 |
|  Auth Code Grant Redirect With Consent | 500 | Get access token | 0 | 56.59 | 3423.91 | 776.58 | 5375 | 97.62 |
|  Auth Code Grant Redirect With Consent | 500 | Send request to authorize end poiont | 0 | 56.42 | 1156.37 | 679.48 | 4255 | 97.62 |
|  Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 140.34 | 141.23 | 49.12 | 277 | 97.6 |
|  Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 140.34 | 68.95 | 31.23 | 165 | 97.6 |
|  Implicit Grant Redirect With Consent | 50 | Get Access token | 0 | 140.34 | 71.88 | 30.65 | 164 | 97.6 |
|  Implicit Grant Redirect With Consent | 50 | Send request to authorize end point | 0 | 140.32 | 73.43 | 47.64 | 295 | 97.6 |
|  Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 132.64 | 285.32 | 83.22 | 487 | 97.46 |
|  Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 132.67 | 149.51 | 55.57 | 315 | 97.46 |
|  Implicit Grant Redirect With Consent | 100 | Get Access token | 0 | 132.7 | 157.61 | 57.67 | 323 | 97.46 |
|  Implicit Grant Redirect With Consent | 100 | Send request to authorize end point | 0 | 132.66 | 160.74 | 94.05 | 683 | 97.46 |
|  Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 124.96 | 451.24 | 96.24 | 695 | 97.51 |
|  Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 124.96 | 244.49 | 74.88 | 469 | 97.51 |
|  Implicit Grant Redirect With Consent | 150 | Get Access token | 0 | 124.96 | 250.43 | 74.7 | 473 | 97.51 |
|  Implicit Grant Redirect With Consent | 150 | Send request to authorize end point | 0 | 124.99 | 253.95 | 143.25 | 1119 | 97.51 |
|  Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 115.82 | 925.6 | 222.03 | 1535 | 97.32 |
|  Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 115.85 | 560.7 | 204.83 | 1199 | 97.32 |
|  Implicit Grant Redirect With Consent | 300 | Get Access token | 0 | 115.8 | 581.14 | 217.43 | 1311 | 97.32 |
|  Implicit Grant Redirect With Consent | 300 | Send request to authorize end point | 0 | 115.84 | 521.01 | 294.89 | 2031 | 97.32 |
|  Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 107.29 | 1556.53 | 417.13 | 2607 | 96.87 |
|  Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0 | 107.41 | 1052.67 | 422.86 | 2383 | 96.87 |
|  Implicit Grant Redirect With Consent | 500 | Get Access token | 0 | 107.46 | 1101.51 | 459.83 | 2655 | 96.87 |
|  Implicit Grant Redirect With Consent | 500 | Send request to authorize end point | 0 | 107.35 | 938.75 | 525.7 | 3375 | 96.87 |
|  Password Grant Type | 50 | GetToken_Password_Grant | 0 | 600.32 | 83.13 | 40.5 | 190 | 98.66 |
|  Password Grant Type | 100 | GetToken_Password_Grant | 0 | 544.24 | 183.56 | 65.63 | 347 | 98.51 |
|  Password Grant Type | 150 | GetToken_Password_Grant | 0 | 529.85 | 283.15 | 95.77 | 555 | 98.44 |
|  Password Grant Type | 300 | GetToken_Password_Grant | 0 | 470.82 | 636.95 | 213.58 | 1327 | 98.16 |
|  Password Grant Type | 500 | GetToken_Password_Grant | 0 | 454.67 | 1097.98 | 390.11 | 2383 | 97.74 |
|  Client Credentials Grant Type | 50 | Get Token Client Credential Grant | 0 | 2247.87 | 22.09 | 31.22 | 147 | 99.02 |
|  Client Credentials Grant Type | 100 | Get Token Client Credential Grant | 0 | 2241.03 | 44.47 | 62.62 | 285 | 98.92 |
|  Client Credentials Grant Type | 150 | Get Token Client Credential Grant | 0 | 2201.51 | 67.99 | 92.75 | 409 | 98.87 |
|  Client Credentials Grant Type | 300 | Get Token Client Credential Grant | 0 | 2050.12 | 146.19 | 184.57 | 759 | 97.91 |
|  Client Credentials Grant Type | 500 | Get Token Client Credential Grant | 0 | 1955.35 | 255.46 | 293.88 | 1159 | 97.21 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 69.33 | 134.84 | 37.6 | 250 | 98.12 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 69.37 | 64.42 | 25.32 | 149 | 98.12 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Get Authorization Code | 0 | 69.35 | 104.37 | 37.88 | 224 | 98.12 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Get tokens | 0 | 69.35 | 345.08 | 63.56 | 501 | 98.12 |
|  OIDC Auth Code Grant Redirect With Consent | 50 | Send request to authorize end poiont | 0 | 69.34 | 71.57 | 51.85 | 349 | 98.12 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 66.03 | 278.38 | 66.57 | 469 | 98.13 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 66.02 | 140.16 | 49.22 | 303 | 98.13 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Get Authorization Code | 0 | 66.02 | 203.71 | 58.07 | 387 | 98.13 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Get tokens | 0 | 66.02 | 739.21 | 98.15 | 975 | 98.13 |
|  OIDC Auth Code Grant Redirect With Consent | 100 | Send request to authorize end poiont | 0 | 66.03 | 152.29 | 112.34 | 815 | 98.13 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 63.71 | 455.32 | 106.78 | 771 | 98.13 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 63.71 | 237.62 | 87.1 | 539 | 98.13 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Get Authorization Code | 0 | 63.68 | 323.3 | 93.52 | 631 | 98.13 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Get tokens | 0 | 63.66 | 1092.24 | 165.11 | 1511 | 98.13 |
|  OIDC Auth Code Grant Redirect With Consent | 150 | Send request to authorize end poiont | 0 | 63.74 | 245.55 | 181.26 | 1295 | 98.13 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 59.47 | 980.66 | 278.77 | 1751 | 97.93 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 59.54 | 574.89 | 264.74 | 1463 | 97.93 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Get Authorization Code | 0 | 59.56 | 719.77 | 283.71 | 1647 | 97.93 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Get tokens | 0 | 59.48 | 2137.89 | 433.78 | 3247 | 97.93 |
|  OIDC Auth Code Grant Redirect With Consent | 300 | Send request to authorize end poiont | 0 | 59.39 | 624.49 | 408.3 | 2591 | 97.93 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 57.29 | 1643.53 | 470.57 | 2943 | 97.64 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0 | 57.49 | 1126.93 | 517.04 | 2783 | 97.64 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Get Authorization Code | 0 | 57.38 | 1290.35 | 499.13 | 2895 | 97.64 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Get tokens | 0 | 57.4 | 3501.6 | 796.43 | 5471 | 97.64 |
|  OIDC Auth Code Grant Redirect With Consent | 500 | Send request to authorize end poiont | 0 | 57.32 | 1130.65 | 722.89 | 4415 | 97.64 |
|  OIDC Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request | 0 | 77.73 | 135.03 | 38.95 | 255 | 98.29 |
|  OIDC Implicit Grant Redirect With Consent | 50 | Common Auth Login HTTP Request Redirect | 0 | 77.71 | 66.12 | 26.13 | 159 | 98.29 |
|  OIDC Implicit Grant Redirect With Consent | 50 | Get tokens | 0 | 77.7 | 370.81 | 60.72 | 519 | 98.29 |
|  OIDC Implicit Grant Redirect With Consent | 50 | Send request to authorize end point | 0 | 77.72 | 70.99 | 51.83 | 365 | 98.29 |
|  OIDC Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request | 0 | 74.42 | 286.69 | 69.14 | 497 | 98.14 |
|  OIDC Implicit Grant Redirect With Consent | 100 | Common Auth Login HTTP Request Redirect | 0 | 74.43 | 146.42 | 51.05 | 325 | 98.14 |
|  OIDC Implicit Grant Redirect With Consent | 100 | Get tokens | 0 | 74.41 | 754.48 | 99.88 | 1007 | 98.14 |
|  OIDC Implicit Grant Redirect With Consent | 100 | Send request to authorize end point | 0 | 74.4 | 155.64 | 108.21 | 803 | 98.14 |
|  OIDC Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request | 0 | 74.08 | 437.92 | 96.55 | 731 | 98.11 |
|  OIDC Implicit Grant Redirect With Consent | 150 | Common Auth Login HTTP Request Redirect | 0 | 74.2 | 238.92 | 82.11 | 527 | 98.11 |
|  OIDC Implicit Grant Redirect With Consent | 150 | Get tokens | 0 | 74.18 | 1094.34 | 155.14 | 1503 | 98.11 |
|  OIDC Implicit Grant Redirect With Consent | 150 | Send request to authorize end point | 0 | 74.1 | 250.42 | 164.63 | 1175 | 98.11 |
|  OIDC Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request | 0 | 68.37 | 988.85 | 278.18 | 1815 | 98.02 |
|  OIDC Implicit Grant Redirect With Consent | 300 | Common Auth Login HTTP Request Redirect | 0 | 68.35 | 577.17 | 259.11 | 1463 | 98.02 |
|  OIDC Implicit Grant Redirect With Consent | 300 | Get tokens | 0 | 68.37 | 2211.39 | 437.9 | 3343 | 98.02 |
|  OIDC Implicit Grant Redirect With Consent | 300 | Send request to authorize end point | 0 | 68.35 | 605.7 | 363.74 | 2271 | 98.02 |
|  OIDC Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request | 0 | 65.89 | 1821.57 | 529.68 | 3375 | 97.68 |
|  OIDC Implicit Grant Redirect With Consent | 500 | Common Auth Login HTTP Request Redirect | 0 | 66.03 | 1113.56 | 474.79 | 2527 | 97.68 |
|  OIDC Implicit Grant Redirect With Consent | 500 | Get tokens | 0 | 65.97 | 3507.6 | 830.13 | 5663 | 97.68 |
|  OIDC Implicit Grant Redirect With Consent | 500 | Send request to authorize end point | 0 | 65.95 | 1118.6 | 662.83 | 4191 | 97.68 |
|  OIDC Password Grant Type | 50 | GetToken_Password_Grant | 0 | 134.34 | 372.31 | 79.82 | 579 | 99.21 |
|  OIDC Password Grant Type | 100 | GetToken_Password_Grant | 0 | 142.07 | 703.56 | 174.06 | 1135 | 99.1 |
|  OIDC Password Grant Type | 150 | GetToken_Password_Grant | 0 | 137.21 | 1092.17 | 237.94 | 1783 | 99.1 |
|  OIDC Password Grant Type | 300 | GetToken_Password_Grant | 0 | 136 | 2201.88 | 600.77 | 3919 | 98.81 |
|  OIDC Password Grant Type | 500 | GetToken_Password_Grant | 0 | 133.91 | 3711.95 | 1047.65 | 6687 | 98.43 |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Get Authorization Code | 0 | 74.12 | 101.65 | 41.39 | 227 | 98.23 |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Get tokens | 0 | 74.1 | 355.69 | 68.41 | 535 | 98.23 |
|  OIDC Auth Code Request Path Authenticator With Consent | 50 | Send request to authorize end poiont | 0 | 74.12 | 217.03 | 56.65 | 379 | 98.23 |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Get Authorization Code | 0 | 70.75 | 212.65 | 76.16 | 435 | 98.16 |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Get tokens | 0 | 70.79 | 737.38 | 108.31 | 1003 | 98.16 |
|  OIDC Auth Code Request Path Authenticator With Consent | 100 | Send request to authorize end poiont | 0 | 70.77 | 462.44 | 96.89 | 751 | 98.16 |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Get Authorization Code | 0 | 69.18 | 327.72 | 127.1 | 727 | 98.07 |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Get tokens | 0 | 69.15 | 1107.8 | 168.52 | 1527 | 98.07 |
|  OIDC Auth Code Request Path Authenticator With Consent | 150 | Send request to authorize end poiont | 0 | 69.09 | 733.47 | 138.28 | 1143 | 98.07 |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Get Authorization Code | 0 | 66.27 | 734.21 | 304.15 | 1775 | 97.85 |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Get tokens | 0 | 66.27 | 2146.69 | 456.34 | 3375 | 97.85 |
|  OIDC Auth Code Request Path Authenticator With Consent | 300 | Send request to authorize end poiont | 0 | 66.16 | 1641.48 | 370.95 | 2783 | 97.85 |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Get Authorization Code | 0 | 63.32 | 1321.68 | 542.7 | 3183 | 97.73 |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Get tokens | 0 | 63.08 | 3550.7 | 840.14 | 6079 | 97.73 |
|  OIDC Auth Code Request Path Authenticator With Consent | 500 | Send request to authorize end poiont | 0 | 63.24 | 3012.43 | 729.31 | 5279 | 97.73 |
|  SAML2 SSO Redirect Binding | 50 | Identity Provider Login | 0 | 89.77 | 460.53 | 92.33 | 751 | 97.75 |
|  SAML2 SSO Redirect Binding | 50 | Initial SAML Request | 0 | 89.8 | 95.57 | 59.85 | 283 | 97.75 |
|  SAML2 SSO Redirect Binding | 100 | Identity Provider Login | 0 | 86.81 | 936.54 | 207.86 | 1535 | 97.73 |
|  SAML2 SSO Redirect Binding | 100 | Initial SAML Request | 0 | 86.87 | 213.86 | 136.65 | 651 | 97.73 |
|  SAML2 SSO Redirect Binding | 150 | Identity Provider Login | 0 | 84.31 | 1419.25 | 336.77 | 2319 | 97.63 |
|  SAML2 SSO Redirect Binding | 150 | Initial SAML Request | 0 | 84.33 | 358.29 | 247.69 | 1215 | 97.63 |
|  SAML2 SSO Redirect Binding | 300 | Identity Provider Login | 0 | 79.7 | 2977.81 | 754.91 | 4991 | 97.38 |
|  SAML2 SSO Redirect Binding | 300 | Initial SAML Request | 0 | 79.74 | 768.11 | 553.92 | 2799 | 97.38 |
|  SAML2 SSO Redirect Binding | 500 | Identity Provider Login | 0 | 66.92 | 5792.67 | 2247.65 | 13375 | 96.85 |
|  SAML2 SSO Redirect Binding | 500 | Initial SAML Request | 0 | 66.88 | 1637.81 | 1364.99 | 6815 | 96.85 |
