## run-performance-tests.sh

This is the shell script that runs a given set of JMeter tests against the deployment.

See usage:
```
./run-performance-tests.sh [-c <concurrent_users>] [-m <heap_sizes>] [-d <test_duration>] [-w <warm_up_time>]
   [-j <jmeter_client_heap_size>] [-i <include_scenario_name>] [-e <exclude_scenario_name>]
   [-t] [-p <estimated_processing_time_in_between_tests>] [-h]

-c: Concurrency levels to test. You can give multiple options to specify multiple levels. Default "50 100 150 300 500".
-m: Application heap memory sizes. You can give multiple options to specify multiple heap memory sizes. Default "2G".
-d: Test Duration in minutes. Default 15 m.
-w: Warm-up time in minutes. Default 5 m.
-j: Heap Size of JMeter Client. Default 2G.
-i: Scenario name to to be included. You can give multiple options to filter scenarios.
-e: Scenario name to to be excluded. You can give multiple options to filter scenarios.
-t: Estimate time without executing tests.
-p: Estimated processing time in between tests in seconds. Default 220.
-h: Display this help and exit.

```

All tests are defined in this script file. To add a new test, use below format.
```
declare -A test_scenario<NUMBER>=(
    [name]=""
    [display_name]=""
    [description]=""
    [jmx]=""
    [skip]=false
)
```