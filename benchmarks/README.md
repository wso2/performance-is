# WSO2 Identity Server Performance Results.


### Guide to the Existing Data Files
| Sheet | Updated on | Server version | Deployment | IS Instance Type | RDS Instance Type | Test Duration | Warmup period | OS | Java | Database |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| [Single node 4-core](5.8.0-beta6_single-node_4-core.md) | 2019/5/9 | 5.8.0 Beta 6 | Single node | c5.xlarge | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [Single node 2-core](5.8.0-rc2_single-node_2-core.md) | 2019/5/14 | 5.8.0 RC 2 | Single node | c5.large | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [2-node cluster 4-core](5.8.0-rc3_two-node_4-core.md) | 2019/5/24 | 5.8.0 GA | 2-node cluster | c5.xlarge | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [2-node cluster 2-core](5.8.0-rc3_two-nodes_2-core.md) | 2019/5/30 | 5.8.0 GA | 2-node cluster | c5.large | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [Single node 4-core](5.9.0-rc2-single-node-4-core.md) | 2019/10/3 | 5.9.0 GA | Single node | c5.xlarge | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |



### Deployment Diagram - Single node
![Deployment Diagram - Single node](https://github.com/wso2/performance-is/blob/master/common/images/deployment-diagram-singlenode.png)


### Deployment Diagram - Two node cluster
![Deployment Diagram - Two node cluster](https://github.com/wso2/performance-is/blob/master/common/images/deployment-diagram-twonode-cluster.png)
