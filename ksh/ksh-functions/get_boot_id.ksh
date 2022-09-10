#!/bin/ksh

# Declare the function name
get_boot_id()
{
	
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	my_machine_boot_id=read hostnamectl|grep -i boot|cut -d ':' -f2|xargs

	# Another way of executing the piped command in bash is by using command keyword
	# my_machine_boot_id=command hostnamectl|grep -i boot|cut -d ':' -f2|xargs

	# AWK equivalent
	# $1=$1 gets rid of the lead whitespaces
	# awk 'BEGIN {FS=": "}{print $2}	:- Modifies the default FieldSeparator (<space>) to ': '
	# Advantage of this approach is that it allows multi character delimiter, while cut allows only single character delimiter
	# my_machine_boot_id=read hostnamectl |awk 'BEGIN {IGNORECASE=1} /boot/ {$1=$1; print}' | awk 'BEGIN {FS=": "}{print $2}'

	# return value of the function is machine boot id
	return $my_machine_boot_id
}

#Calling the function
get_boot_id