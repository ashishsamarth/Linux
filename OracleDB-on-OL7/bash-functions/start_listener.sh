#! /bin/bash

# Declare the name of the function
start_listener()
{	
	# Identify the logged in user
	trigger_owner=`whoami`
	# Check if the listener is defined in listener.ora file
	listener_file=`grep -iA6 LISTENER $TNS_ADMIN/listener.ora | grep -v '#' | xargs` 1> /dev/null
	# Get the name of the configured listener
	listener_name=`grep -iA6 LISTENER $TNS_ADMIN/listener.ora | grep -v '#' | xargs | cut -d '=' -f1 | xargs` 1> /dev/null
	
	# If the logged in user is = oracle and listener name is not empty
	if [[ $trigger_owner == 'oracle' ]] && [[ -n $listener_name ]]
	then
		# Get the current status of the listener
		# If the listener is already up, exit the if condition
		listener_status=`lsnrctl status LISTENER | xargs` 1> /dev/null
		if [[ $listener_status == *"STATUS of the LISTENER"* ]]
		then 
			echo "$listener_name is already up and running !!!"
		else
			# If the listener is not up, run the following command to start it again
			# Redirect the output from stdout to null
			lsnrctl start $listener_name 1> /dev/null
			# Wait for 5 seconds
			sleep 5
			# Check the listener status after the restart
			# Redirect the output from stdout to null
			restart_listener_status=`lsnrctl status LISTENER | xargs` 1> /dev/null
			
			# If the listener is already up, echo the message
			if [[ $restart_listener_status == *"STATUS of the LISTENER"* ]]
			then 
				echo "$listener_name is restarted"
			else 
				echo "Could Not restart $listener_name"
			fi
		fi
	fi
}

# Calling the function
start_listener