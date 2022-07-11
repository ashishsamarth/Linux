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

	# AWK Equivalent
	# awk '$1=$1' : Gets rid of the leading space just like xargs
	# awk 'BEGIN {FS=": "}{print $2}	:- Modifies the default FieldSeparator (<space>) to ': '
	# Advantage of this approach is that it allows multi character delimiter, while cut allows only single character delimiter		
	# my_machine=read hostnamectl | awk 'BEGIN {IGNORECASE=1} /machine/ {print}' | awk '$1=$1' | awk 'BEGIN {FS=": "} {print $2}'

	# SED + AWK Equivalent
	# sed -n '/kernel/ Ip' : Performs a case insensitive search
	# sed s'/^[[:space:]]//' : Gets rid of the leading space just like xargs		
	# my_machine=read hostnamectl | sed -n '/machine/ Ip' | sed 's/^[[:space:]]//' | awk 'BEGIN {FS=": "} {print $2}'

	# return value of the function is machine id
	return $my_machine_id
}

# Calling the function
get_machine_id