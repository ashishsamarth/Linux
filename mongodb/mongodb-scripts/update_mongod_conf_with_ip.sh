#!/bin/bash

# Declare the function name
# This function updates the IP address of local host to /etc/mongod.conf
# The parameter that gets updates with the value is: bindIp

update_mongo_conf_with_ip()
{
        # Get the IP of the local vm using the ifconfig utility
        get_vm_ip=$(/sbin/ifconfig | grep inet | grep broadcast|awk '{print $2}')

        # Using the following sed command, update the loopback ip with the local host ip
        # in /etc/mongod.conf so that mongodb is accessible both on local host and local network
        sed -i "/bindIp/ s/127.0.0.1$/127.0.0.1, $get_vm_ip/" /etc/mongod.conf
}

# Calling the function
update_mongo_conf_with_ip
