#! /bin/bash

# Assumption: User is running dynamic firewall service: firewalld

# Declare the function name
# Following fuction will fetch the status of the firewall
# Potential values are (running) or (dead)

get_firewall_status()
{	
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	firewall_status=read systemctl status firewalld| head -3|tail -1|xargs|cut -d ';' -f1|cut -d ' ' -f3
	# Another method to get the firewall status
	# firewall_status=read firewall-cmd --state
	
	# return value of the function is the status "running or dead" of the firewall
	return $firewall_status
}

# Declare the function name
# Following function will fetch the last update time of the firewall

get_firewall_status_since()
{	
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	firewall_status_since=read systemctl status firewalld| head -3|tail -1|xargs|cut -d ';' -f1|cut -d ' ' -f4-8
	
	# return value of the function is the timestamp of the last update to firewall
	return $firewall_status_since
}

# Execute the function and store the results in the variable
function_result=$(get_firewall_status)
function_result_since=$(get_firewall_status_since)

# Output the concatenated result to stdout
echo -e "Firewall is $function_result $function_result_since"