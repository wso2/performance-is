# V1

In this version of Performance results the tests were executed with the following configs added with the intension of disabling the newly introduced features/improvements. This has been done in order to ease cross-comparison with earlier versions of the product.

```
[authentication_policy]
disable_account_lock_handler=true

[identity_mgt.events.schemes.WorkflowPendingUserAuthnHandler]
subscriptions=[]

[authorization_manager.properties]
GroupAndRoleSeparationEnabled=false
```
