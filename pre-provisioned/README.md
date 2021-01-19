# WSO2 Pre Provisioned Performance

These scripts can be used to run IS performance tests against a pre-provisioned environment.

These performance test scripts make use of the Apache JMeter to run the tests with different concurrent users.
 
## About the deployment

Deployment should be already there you need the following information of the deployment to use this performance
artifacts. 

1. Host name
2. DB Hostname
3. DB Username
4. DB Password
5. Identity Server Super Admin Username
6. Identity Server Super Admi Password

JMeter version 3.3 is installed in a separate node which is used to run the test scripts and gather results from the setup.

## Run Performance Tests

You can run IS Performance Tests from the source using the following instructions.

### Prerequisites

* [Maven 3.5.0 or later](https://maven.apache.org/download.cgi)
* [AWS CLI](https://aws.amazon.com/cli/) - Please make sure to [configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) and set the output format to `json`.
* [Apache JMeter 3.3](https://jmeter.apache.org/) Setup tarball.
* WSO2 IS server zip file.
* Python 3.5
    * [Jinja2 2.11.1](https://pypi.org/project/Jinja2/)
    * numpy

### Steps to run performance tests.

1. Clone this repository.

```console
git clone https://github.com/wso2/performance-is
```
2. Navigate to `pre-provisioned` directory.
3. Run the `start-performance.sh` script. It will take around 15 hours to complete the test round with default settings. Therefore, you might want to use `nohup`. Following is the basic command.
```console
./start-performance.sh  -j /home/ubuntu/jmeter/apache-jmeter-3.3.tgz -u rdsadmin -p rdspass -n perf-db-instance.us-east-1.rds.amazonaws.com -d is.demo.com -k /home/ubuntu/iam-key.pem -- -d 10 -w 2 -u admin -k admin -q true -b mysql -f IDENTITY_DB
```
```console
./start-performance.sh  -j <jmeter setup path> -u <RDS Username> -p <RDS Password> -n <DB instance DNS> -d <Enviroment Host Name> -k <key file> -- -d 10 -w 2 -u <IS super admin user name> -k <IS super admin password> -q <Populate Test Data>
-b <database type default:mysql> -f <database name default: IDENTITY_DB>
```

See usage:

```console
./start-performance.sh -k <key_file> -a <aws_access_key> -s <aws_access_secret>
   -c <certificate_name> -j <jmeter_setup_path>
   [-n <IS_zip_file_path>]
   [-u <db_username>] [-p <db_password>]
   [-i <wso2_is_instance_type>] [-b <bastion_instance_type>]
   [-w <minimum_stack_creation_wait_time>] [-h]

-k: The Amazon EC2 key file to be used to access the instances.
-a: The AWS access key.
-s: The AWS access secret.
-j: The path to JMeter setup.
-c: The name of the IAM certificate.
-n: The is server zip
-u: The database username. Default: wso2carbon.
-p: The database password. Default: wso2carbon.
-d: The pre provisioned enviroment Hostname.
-q: Populate test data. Default true.
-i: The instance type used for IS nodes. Default: c5.xlarge.
-b: The instance type used for the bastion node. Default: c5.xlarge.
-w: The minimum time to wait in minutes before polling for cloudformation stack's CREATE_COMPLETE status.
    Default: 10 minutes.
-h: Display this help and exit.
```

