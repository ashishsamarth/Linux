#!/bin/bash

# Declare the function name
get_public_ipv4_address()
{	
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	my_public_ipv4_address=read curl -4 icanhazip.com
	
	# Another way of executing the piped command in bash is by using command keyword
	# my_public_ipv4_address=command curl -4 icanhazip.com

	# return value of the function is public ip v4 address
	return $my_public_ipv4_address
}

#Calling the function
get_public_ipv4_address