#!/bin/bash

# Declare the function name
# This function updates the hostname for Oracle DB configuration in listener.ora and tnsnames.ora
# The parameter that gets updates with the value is: HOST

update_oracle_listener_tns_conf_with_hostname()
{

    # Using the following sed command, update the listener.ora and tnsnames.ora with updated hostname
    ORCL_CONFIG_PATH=/u01/app/oracle/product/db/21.0.0/dbhome/network/admin
	cd $ORCL_CONFIG_PATH
	
	# Fetch the existing hostname in Listener.ora
	get_hostname_in_listener=$(grep -i '(HOST' listener.ora|xargs | awk -F ' = ' '{print $4}'|awk -F ')' '{print $1}')
	
	# If the current host in Listener.ora does not match Machine hostname, then replace it with current hostname in both listener.ora and tnsnames.ora
	if [ "$get_hostname_in_listener" != "$HOSTNAME" ]
	then
		sed -i "s/$get_hostname_in_listener/$HOSTNAME/g" listener.ora
		sed -i "s/$get_hostname_in_listener/$HOSTNAME/g" tnsnames.ora

	fi
}

# Calling the function
update_oracle_listener_tns_conf_with_hostname