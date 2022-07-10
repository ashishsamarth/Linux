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

	# AWK Equivalent of the above command
	# awk '$1=$1' : Gets rid of the leading space just like xargs
	# awk 'BEGIN {FS=": "}{print $2}	:- Modifies the default FieldSeparator (<space>) to ': '
	# Advantage of this approach is that it allows multi character delimiter, while cut allows only single character delimiter	
	# my_hostname=read hostnamectl | awk 'BEGIN {IGNORECASE=1} /hostname/ {print}' | awk '$1=$1' | awk 'BEGIN {FS=": "} {print $2}'

	# SED + AWK Equivalent
	# sed -n '/hostname/ Ip' : Performs a case insensitive search
	# sed s'/^[[:space:]]//' : Gets rid of the leading space just like xargs
	# my_hostname=read hostnamectl | sed -n '/hostname/ Ip' | sed 's/^[[:space:]]//' | awk 'BEGIN {FS=": "} {print $2}'
	
	# return value of the function is hostname
	return $my_hostname
}


#Calling the function
get_hostname
