#! /bin/bash

# Declare the function name
get_listener_status()
{	
	# Identify who is calling the function
	trigger_owner=`whoami`
	# Read the listener name from user input and convert it to upper case
	listener_name=`echo $1 | tr '[:lower:]' '[:upper:]'`
	# Check if the given listener name exists in the listener.ora file and convert the output to upper case
	listener_exists=`grep -iF $listener_name $TNS_ADMIN/listener.ora | grep -v ^# | cut -d '=' -f1 | xargs | tr '[:lower:]' '[:upper:]'`
	
	# Only proceed if
	# Script is executed by 'oracle' user
	# And output of listener_exists is not null
	# And value of listener_exists is exactly matching provided provided listener name
	if [[ $trigger_owner == 'oracle' ]] && [[ -n $listener_exists ]] && [[ $listener_exists == $listener_name ]]
	then	
		# Get the status of the provided listener name 
		listener_status=`lsnrctl status $listener_name | xargs` 1> /dev/null
		
		# If listener is up echo corresponding message
		if [[ $listener_status == *"STATUS of the LISTENER"* ]]
		then
			echo "$listener_name is UP and Running !!! "
		else
			echo "$listener_name is not listening for connections !!! "
		fi
	else
		# echo following message if provided listener name does not exist in listener.ora
		echo "$listener_name is probably not defined in $TNS_ADMIN/listener.ora"
	fi
}

# If script is executed without postional argument
# i.e argument count is zero
if [[ $# == 0 ]]
then
	echo "Execution Message: Call the function with Listener Name as Argument"
else
	# Calling the function
	get_listener_status $1
fi