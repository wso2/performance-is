#!/bin/bash +x

# Scenario name is prefix added to the log files. So add something meaningful so that you can track the output easily. eg: saml_redirect_binding.
scenario=$1

# Location of the jmeter script.
script_location=$2

usage_msg="Usage: ./jmeter_run_all.sh <scenario_name> <jmeter_script_location>"
usage_sample="Sample: ./jmeter_run_all.sh saml_redirect_binding /home/ubuntu/scripts/is_540_scripts/saml/SAML2-SSO-RedirectBinding.jmx"

#### sanity check
if [ -z "$1" ]
  then
  	echo "Please add a scenario name for the current test like, eg: saml_redirect_binding"
	echo "$usage_msg"
	echo "$usage_sample"
	exit
fi

if [ -z "$2" ]
  then
        echo "Please provide a valid jmeter script location."
	echo "$usage_msg"
        echo "$usage_sample"
	exit
fi



is_540_host="idp.wso2.com"
is_540_host_username="ubuntu"

carbon_home="/home/ubuntu/is_540/wso2is-5.4.0-beta"
java_home="/home/ubuntu/software/jdk1.8.0_144"
jmeter_home="/home/ubuntu/software/apache-jmeter-3.3"
output_directory="/home/ubuntu/output"
private_key_path="/home/ubuntu/is540pf.pem"

identity_db_host="db2.wso2.com"
identity_db_username="root"
identity_db_password="root123"
identity_db_name="identity_db"

output_home="/home/ubuntu/output"
output_directory=$output_home/$scenario
mkdir -p $output_directory

#echo $scenario
#echo $script_location
echo "************************ Start Performance test for $scenario using script: $script_location ***************************************"
concurencies=(100 200 300 400 1000)  
for concurrency in "${concurencies[@]}"
do
	#echo $concurency
	echo "=========================== CONCURRENCY LEVEL: $concurrency started ============================"
	echo "Cleaning the database....."
	mysql -u $identity_db_username -p$identity_db_password -h $identity_db_host $identity_db_name < ./setup/clean-database.sql
	echo "Initial MySQLSlap"
	sudo mysqlslap --user=$identity_db_username --password=$identity_db_password --host=$identity_db_host --concurrency=50 --iterations=10 --auto-generate-sql --verbose >> $output_directory/mySQLSlap_$concurrency.log
	#carbon_home="/home/ubuntu/is_540/wso2is-5.4.0-beta"
	echo $carbon_home
	ssh -i $private_key_path $is_540_host_username@$is_540_host << ENDSSH
	# cleanup any prev session files
	rm -f $carbon_home/repository/logs/gc_log_$scenario$concurrency.log
	rm -f ~/sar_$scenario$concurrency.log

        echo "Killing All Carbon Servers......"
        killall java
		export JAVA_HOME=$java_home
		export PATH=$JAVA_HOME/bin:$PATH
		echo "********* restarting sysstat ***************"
		sudo service sysstat restart
		echo "************** starting identity server ***************"
		sh $carbon_home/bin/wso2server.sh restart
		sleep 200
		echo "************** finished starting identity server *******************"
		exit
ENDSSH
	echo "Ended SSH to IS node"
	echo "Going to start JMeter run"
	./$jmeter_home/bin/jmeter -Jconcurrency=$concurrency -n -t $script_location -l $output_directory/log_$concurrency.jtl
	#cd /home/ubuntu	
	echo "MySQLSlap at the end of the current concurrency run..."
	sudo mysqlslap --user=$identity_db_username --password=$identity_db_password --host=$identity_db_host --concurrency=50 --iterations=10 --auto-generate-sql --verbose >> $output_directory/mySQLSlap_$concurrency.log
	ssh -i $private_key_path $is_540_host_username@$is_540_host << ENDSSH2
	echo "************************"
	mv $carbon_home/repository/logs/gc.log $carbon_home/repository/logs/gc_log_$scenario$concurrency.log
	
	sar -q > sar_$scenario$concurrency.log
        echo Killing All Carbon Servers......
        killall java
	exit
ENDSSH2
	echo "Copying GC logs from Identity Server...."
	scp -i $private_key_path $is_540_host_username@$is_540_host:$carbon_home/repository/logs/gc_log_$scenario$concurrency.log $output_directory/gc_log_$concurrency.log
	echo "Copying SAR logs from Identity Server...."
	scp -i $private_key_path $is_540_host_username@$is_540_host:~/sar_$scenario$concurrency.log $output_directory/sar_log_$concurrency.log

	echo "Cleaning the database....."
	mysql -u $identity_db_username -p$identity_db_password -h $identity_db_host $identity_db_name < ./setup/clean-database.sql

	echo "=========================== CONCURRENCY LEVEL: $concurrency ended ============================"
done
echo "************************ End Performance test for $scenario using script: $script_location ***************************************"

