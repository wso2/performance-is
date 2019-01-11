## setup-bastion.sh

This script is used to install required software on the all nodes and setup ssh host configurations.

See usage:
```
./setup-bastion.sh -w <wso2_is_1_ip> -i <wso2_is_2_ip> -l <lb_host> -r <rds_host>

-w: The private IP of WSO2 IS node 1.
-i: The private IP of WSO2 IS node 2.
-l: The private hostname of Load balancer instance.
-r: The private hostname of RDS instance.
-h: Display this help and exit.
```

Following are the list of things done by this script.

1. Install software on the bastion node
    * Git
    * mysql-client
    * Maven
    * Java
2. Setup is performance artifacts.
    * Create the working directory `/home/ubuntu/workspace`
    * Clone the performance-is repository into the working directory.
    * Build performance artifacts using Maven and extract into the working directory.
3. Install JMeter and setup required files.
4. Copy Required files to IS nodes and install required software.
