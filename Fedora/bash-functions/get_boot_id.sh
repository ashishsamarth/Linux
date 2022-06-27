#!/bin/bash

# Declare the function name
get_boot_id()
{
	
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	my_machine_boot_id=read hostnamectl|grep -i boot|cut -d ':' -f2|xargs
	# return value of the function is machine boot id
	return $my_machine_boot_id
}

#Calling the function
get_boot_id
