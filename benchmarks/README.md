# WSO2 Identity Server Performance Results.


### Guide to the Existing Data Files
| Sheet | Updated on | Server version | Deployment | IS Instance Type | RDS Instance Type | Test Duration | Wormup period | OS | Java | Database |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| [Single node 4-core](single-node-4-core-5.8.0-2019-05-09.md) | 2019/5/9 | 5.8.0 Beta 6 | Single node | c5.xlarge | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [Single node 2-core](single-node-2-core-5.8.0-2019-05-14.md) | 2019/5/14 | 5.8.0 RC 2 | Single node | c5.large | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [2-node cluster 4-core](2-node-cluster-4-core-5.8.0-2019-05-24.md) | 2019/5/24 | 5.8.0 RC 3 | 2-node cluster | c5.xlarge | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [2-node cluster 2-core](2-node-cluster-2-core-5.8.0-2019-05-30.md) | 2019/5/30 | 5.8.0 RC 3 | 2-node cluster | c5.large | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |


### Deployment Diagram - Single node
![Deployment Diagram - Single node](https://github.com/vihanga-liyanage/performance-is/blob/single-node-performance/images/singlenode-deployment.png)


### Deployment Diagram - Two node cluster
![Deployment Diagram - Two node cluster](https://github.com/vihanga-liyanage/performance-is/blob/master/images/deployment-diagram.png)
