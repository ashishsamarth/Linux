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

	# AWK Equivalent
	# awk '$1=$1' : Gets rid of the leading space just like xargs
	# awk 'BEGIN {FS=": "}{print $2}	:- Modifies the default FieldSeparator (<space>) to ': '
	# Advantage of this approach is that it allows multi character delimiter, while cut allows only single character delimiter	
	# my_kernel=read hostnamectl | awk 'BEGIN {IGNORECASE=1} /kernel/ {print}' | awk '$1=$1' | awk 'BEGIN {FS=": "} {print $2}'
	
	# SED + AWK Equivalent
	# sed -n '/hostname/ Ip' : Performs a case insensitive search
	# sed s'/^[[:space:]]//' : Gets rid of the leading space just like xargs	
	# my_kernel=read hostnamectl | sed -n '/kernel/ Ip' | sed 's/^[[:space:]]//' | awk 'BEGIN {FS=": "} {print $2}'

	# return value of the function is kernal details
	return $my_kernel_details
}

#Calling the function
get_kernel
