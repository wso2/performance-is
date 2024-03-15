# V1

In this version of Performance results, the tests were executed with the following configs added which disable some of the newly added features/improvements. This has been done in order to ease cross-comparison with earlier versions of the product.

```
[authentication_policy]
disable_account_lock_handler=true

[identity_mgt.events.schemes.WorkflowPendingUserAuthnHandler]
subscriptions=[]

[authorization_manager.properties]
GroupAndRoleSeparationEnabled=false
```

In order to see the performance results with the with above features enabled, please refer the [v2 results](https://github.com/wso2/performance-is/tree/master/benchmarks/6.1.0/v2/README.md) which use the default pack without enabling or disabling any additional features.

Please note that in both cases, [performance tuning parameters](https://is.docs.wso2.com/en/6.1.0/deploy/performance/performance-tuning-recommendations/) has been fine tuned as needed.
