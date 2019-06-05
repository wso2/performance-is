# WSO2 Identity Server Performance

WSO2 Identity Server performance artifacts are used to continuously test the performance of the Identity Server.

These performance test scripts make use of the Apache JMeter 3.x to run the tests with different cocurrent users.

At the moment, there are two types of deployments to choose from.
1. [Single Node Deployment](https://github.com/wso2/performance-is/tree/single-node-performance) - Only one IS node is used with an MySQL Amzon RDS database.
2. [Two Node Cluster Deployment](https://github.com/wso2/performance-is/tree/two-node-performance) - Two IS nodes are clustered together and fronted with an dedicated NGinx load balancer. The Database is an MySQL Amzon RDS.
