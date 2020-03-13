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

The following are the summaries of performance test results collected for the measurement period.




**1. Authenticate Super Tenant User**

Select random super tenant users and authenticate through the RemoteUserStoreManagerService.
|  Concurrent Users | Throughput (Requests/sec) | Average Response Time (ms) |
|---|---:|---:|
|  50 | 1913.56 | 25.95 |
|  100 | 1906.94 | 52.25 |
|  150 | 1907.63 | 78.44 |
|  300 | 1593.71 | 188.08 |
|  500 | 1739.02 | 287.48 |

**2. Auth Code Grant Redirect With Consent**

Obtain an access token using the OAuth 2.0 authorization code grant type.
|  Concurrent Users | Throughput (Requests/sec) | Average Response Time (ms) |
|---|---:|---:|
|  50 | 179.38 | 277.91 |
|  100 | 196.51 | 508.08 |
|  150 | 207.54 | 722.1 |
|  300 | 208.33 | 1439.9 |
|  500 | 125.54 | 3979.39 |

**3. Implicit Grant Redirect With Consent**

Obtain an access token using the OAuth 2.0 implicit grant type.
|  Concurrent Users | Throughput (Requests/sec) | Average Response Time (ms) |
|---|---:|---:|
|  50 | 254.75 | 195.66 |
|  100 | 280.15 | 356.39 |
|  150 | 299.31 | 500.61 |
|  300 | 303.11 | 989.52 |
|  500 | 271.67 | 1839.78 |

**4. Password Grant Type**

Obtain an access token using the OAuth 2.0 password grant type.
|  Concurrent Users | Throughput (Requests/sec) | Average Response Time (ms) |
|---|---:|---:|
|  50 | 1550.53 | 32.08 |
|  100 | 1579.34 | 63.15 |
|  150 | 1578.13 | 94.86 |
|  300 | 1520.4 | 197.16 |
|  500 | 1433.86 | 348.75 |

**5. Client Credentials Grant Type**

Obtain an access token using the OAuth 2.0 client credential grant type.
|  Concurrent Users | Throughput (Requests/sec) | Average Response Time (ms) |
|---|---:|---:|
|  50 | 9162.05 | 5.27 |
|  100 | 9082.05 | 10.8 |
|  150 | 9042.5 | 16.34 |
|  300 | 9097.73 | 32.65 |
|  500 | 8823.49 | 56.06 |

**6. OIDC Auth Code Grant Redirect With Consent**

Obtain an access token and an id token using the OAuth 2.0 authorization code grant type.
|  Concurrent Users | Throughput (Requests/sec) | Average Response Time (ms) |
|---|---:|---:|
|  50 | 154.71 | 322.35 |
|  100 | 179.12 | 557.55 |
|  150 | 194.11 | 772.15 |
|  300 | 204.56 | 1466.45 |
|  500 | 139.85 | 3571.57 |

**7. OIDC Implicit Grant Redirect With Consent**

Obtain an access token and an id token using the OAuth 2.0 implicit grant type.
|  Concurrent Users | Throughput (Requests/sec) | Average Response Time (ms) |
|---|---:|---:|
|  50 | 189.0 | 263.89 |
|  100 | 211.52 | 472.23 |
|  150 | 228.74 | 655.48 |
|  300 | 240.24 | 1248.56 |
|  500 | 216.21 | 2311.42 |

**8. OIDC Password Grant Type**

Obtain an access token and an id token using the OAuth 2.0 password grant type.
|  Concurrent Users | Throughput (Requests/sec) | Average Response Time (ms) |
|---|---:|---:|
|  50 | 666.36 | 74.86 |
|  100 | 672.62 | 148.49 |
|  150 | 672.59 | 222.95 |
|  300 | 648.26 | 462.67 |
|  500 | 596.03 | 838.31 |

**9. OIDC Auth Code Request Path Authenticator With Consent**

Obtain an access token and an id token using the request path authenticator.
|  Concurrent Users | Throughput (Requests/sec) | Average Response Time (ms) |
|---|---:|---:|
|  50 | 158.93 | 314.27 |
|  100 | 192.61 | 519.03 |
|  150 | 208.54 | 719.27 |
|  300 | 221.92 | 1351.15 |
|  500 | 93.45 | 5346.38 |

**10. SAML2 SSO Redirect Binding**

Obtain a SAML 2 assertion response using redirect binding.
|  Concurrent Users | Throughput (Requests/sec) | Average Response Time (ms) |
|---|---:|---:|
|  50 | 173.47 | 287.18 |
|  100 | 198.96 | 501.54 |
|  150 | 215.74 | 694.32 |
|  300 | 235.21 | 1273.97 |
|  500 | 219.38 | 2274.37 |

