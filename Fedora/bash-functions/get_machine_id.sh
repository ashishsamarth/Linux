#!/bin/bash

# Declare the function name
get_machine_id()
{
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	my_machine_id=read hostnamectl|grep -i machine|cut -d ':' -f2|xargs

	# Another way of executing the piped command in bash is by using command keyword
	#my_machine_id=command hostnamectl|grep -i machine|cut -d ':' -f2|xargs

	# return value of the function is machine id
	return $my_machine_id
}

# Calling the function
get_machine_id
