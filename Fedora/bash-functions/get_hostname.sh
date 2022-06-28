#!/bin/bash

# Declare the function name
get_hostname()
{
    # Always make sure that read is present
    # read allows to run and return the output of the command to the variable
    # xargs removes the leading the trailing spaces if any in the output
	my_hostname=read hostnamectl|grep -i hostname|cut -d ':' -f2|xargs
    	
	# Another way of executing the piped command in bash is by using command keyword
	# my_hostname=command hostnamectl|grep -i hostname|cut -d ':' -f2|xargs
	
	# return value of the function is hostname
	return $my_hostname
}


#Calling the function
get_hostname
