#!/bin/bash

# Declare the function name
get_os()
{	
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	my_os=read hostnamectl|grep -i operating|cut -d ':' -f2|xargs

	# Another way of executing the piped command in bash is by using command keyword
	# my_os=command hostnamectl|grep -i operating|cut -d ':' -f2|xargs

	# return value of the function is operating system name
	return $my_os
}

#Calling the function
get_os

