# WSO2 Identity Server Performance Results.


### Guide to the Existing Data Files
| Sheet | Server version | Deployment | Updated on | IS Instance Type | RDS Instance Type | Test Duration | Warmup period | OS | Java | Database |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| [5.8.0-beta6_single-node_4-core](5.8.0-beta6_single-node_4-core.md) | 5.8.0 Beta 6 | Single node | 2019/5/9 | c5.xlarge | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [5.8.0-rc2_single-node_2-core](5.8.0-rc2_single-node_2-core.md) | 5.8.0 RC 2 | Single node | 2019/5/14 | c5.large | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [5.8.0_two-node_4-core](5.8.0_two-node_4-core.md) | 5.8.0 GA | 2-node cluster | 2019/5/24 | c5.xlarge | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [5.8.0_two-nodes_2-core](5.8.0_two-nodes_2-core.md) | 5.8.0 GA | 2-node cluster | 2019/5/30 | c5.large | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [5.9.0-single-node-4-core](5.9.0-single-node-4-core.md) | 5.9.0 GA | Single node | 2019/10/3 | c5.xlarge | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |
| [5.9.0-single-node-2-core](5.9.0-single-node-2-core.md) | 5.9.0 GA | Single node | 2019/10/23 | c5.xlarge | db.m4.xlarge | 15 min | 5 min | Ubuntu 18.04 (LTS) | 1.8.0_201-b09 | MySQL 5.7 |



### Deployment Diagram - Single node
![Deployment Diagram - Single node](https://github.com/wso2/performance-is/blob/master/common/images/deployment-diagram-singlenode.png)


### Deployment Diagram - Two node cluster
![Deployment Diagram - Two node cluster](https://github.com/wso2/performance-is/blob/master/common/images/deployment-diagram-twonode-cluster.png)
