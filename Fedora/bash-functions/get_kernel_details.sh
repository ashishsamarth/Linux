#!/bin/bash

# Declare the function name
get_kernel()
{
	
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	my_kernel_details=read hostnamectl|grep -i kernel|cut -d ':' -f2|xargs

	# Another way of executing the piped command in bash is by using command keyword
	#my_kernel_details=command hostnamectl|grep -i kernel|cut -d ':' -f2|xargs
	
	# return value of the function is kernal details
	return $my_kernel_details
}

#Calling the function
get_kernel
