# WSO2 Identity Server Performance Results.


### Guide to the Existing Performance Results
Server version | Deployment | Updated on | IS Instance Type | RDS Instance Type | Link
-------------- | ---------- | ---------- | ---------------- | ----------------- | -----
5.6.0 GA | Single node | 2019/10/31 | c5.large (2 core) | db.m4.xlarge | [:arrow_upper_right:](5.6.0/5.6.0_single-node_2-core.md)
5.6.0 GA | Single node | 2019/11/13 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.6.0/5.6.0_single-node_4-core.md)
5.7.0 GA | Single node | 2019/10/31 | c5.large (2 core) | db.m4.xlarge | [:arrow_upper_right:](5.7.0/5.7.0_single-node_2-core.md)
5.7.0 GA | Single node | 2019/10/23 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.7.0/5.7.0_single-node_4-core.md)
5.8.0 Beta 6 | Single node | 2019/5/9 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.8.0/5.8.0-beta6_single-node_4-core.md)
5.8.0 GA | Single node | 2019/11/13 | c5.large (2 core) | db.m4.xlarge | [:arrow_upper_right:](5.8.0/5.8.0_single-node_2-core.md)
5.8.0 GA | Single node | 2019/11/13 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.8.0/5.8.0_single-node_4-core.md)
5.8.0 RC 2 | Single node | 2019/5/14 | c5.large (2 core) | db.m4.xlarge | [:arrow_upper_right:](5.8.0/5.8.0-rc2_single-node_2-core.md)
5.8.0 GA | 2-node cluster | 2019/5/24 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.8.0/5.8.0_two-nodes_4-core.md)
5.8.0 GA | 2-node cluster | 2019/5/30 | c5.large (2 core) | db.m4.xlarge | [:arrow_upper_right:](5.8.0/5.8.0_two-nodes_2-core.md)
5.9.0 GA | Single node | 2019/10/3 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.9.0/5.9.0_single-node_4-core.md)
5.9.0 GA | Single node | 2019/10/23 | c5.large (2 core) | db.m4.xlarge | [:arrow_upper_right:](5.9.0/5.9.0_single-node_2-core.md)
5.9.0 GA | 2-node cluster | 2019/10/23 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.9.0/5.9.0_two-nodes_4-core.md)
5.10.0 GA | 2-node cluster | 2020/10/04 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.10.0/5.10.0_two-nodes_4-core.md)
5.10.0 WUM (1600099543376) | 2-node cluster | 2020/09/21 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.10.0/WUM/1600099543376/5.10.0_two-nodes_4-core.md)
5.10.0 WUM (1600099543376) | Single node | 2020/09/21 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.10.0/WUM/1600099543376/5.10.0_single-node_4-core.md)
5.10.0 WUM (1600099543376) | 2-node cluster | 2020/09/21 | c5.large (2 core) | db.m4.xlarge | [:arrow_upper_right:](5.10.0/WUM/1600099543376/5.10.0_two-nodes_2-core.md)
5.10.0 WUM (1600099543376) | Single node | 2020/09/21 | c5.large (2 core) | db.m4.xlarge | [:arrow_upper_right:](5.10.0/WUM/1600099543376/5.10.0_single-node_2-core.md)
5.11.0 GA | Single node | 2020/12/23 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.11.0/jdk-8/5.11.0_single-node_4-core_dk-8.md)
5.11.0 GA | Single node | 2020/12/23 | c5.large (2 core) | db.m4.xlarge | [:arrow_upper_right:](5.11.0/jdk-8/5.11.0_single-node_2-core_jdk-8.md)
5.11.0 GA | 2-node cluster | 2021/01/02 | c5.xlarge (4 core) | db.m4.xlarge | [:arrow_upper_right:](5.11.0/jdk-8/5.11.0_two-nodes_4-core_jdk-8.md)
5.11.0 GA | Single node | 2022/09/25 | c5.xlarge (2 core) | db.m4.2xlarge | [:arrow_upper_right:](5.11.0/jdk-11/5.11.0_single-node_2-core_jdk-11.md)
5.11.0 GA | 2-node cluster | 2022/09/26 | c5.xlarge (2 core) | db.m4.2xlarge | [:arrow_upper_right:](5.11.0/jdk-11/5.11.0_two-node_2-core_jdk-11.md)
6.0.0 GA | Single node | 2022/09/27 | c5.xlarge (2 core) | db.m4.2xlarge | [:arrow_upper_right:](6.0.0/6.0.0_single-node_2-core_jdk-11.md)
6.0.0 GA | Single node | 2022/09/25 | c5.xlarge (4 core) | db.m4.2xlarge | [:arrow_upper_right:](6.0.0/6.0.0_single-node_4-core_jdk-11.md)
6.0.0 GA | 2-node cluster | 2022/09/27 | c5.xlarge (2 core) | db.m4.2xlarge | [:arrow_upper_right:](6.0.0/6.0.0_two-node_2-core_jdk-11.md)

### Deployment Diagram - Single node
![Deployment Diagram - Single node](https://github.com/wso2/performance-is/blob/master/common/images/deployment-diagram-singlenode.png)


### Deployment Diagram - Two node cluster
![Deployment Diagram - Two node cluster](https://github.com/wso2/performance-is/blob/master/common/images/deployment-diagram-twonode-cluster.png)
