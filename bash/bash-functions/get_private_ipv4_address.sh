#!/bin/bash

# Declare the function name
get_private_ipv4_address()
{

	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	my_private_ipv4_address=read hostname -I|awk '{print $1}'
	
	# Another way of executing the piped command in bash is by using command keyword
	# my_private_ipv4_address=command hostname -I|awk '{print $1}'

	# return value of the function is private ip v4 address
	return $my_private_ipv4_address

}


# Calling the function
get_private_ipv4_address