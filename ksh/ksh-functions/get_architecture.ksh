#!/bin/ksh

# Declare the function name
get_architecture()
{	

	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	my_architecture=read hostnamectl|grep -i architecture|cut -d ':' -f2|xargs

	# Another way of executing the piped command in bash is by using command keyword
	# my_architecture=command hostnamectl|grep -i architecture|cut -d ':' -f2|xargs

	# Another way of writing the same thing using sed and awk
	# sed -n '/pattern/Ip' 	:- Performs case insensitive search
	# awk '$1=$1 {print}'	:- Gets rid of the leading whitespaces
	# awk 'BEGIN {FS=": "}{print $2}	:- Modifies the default FieldSeparator (<space>) to ': '
	# Advantage of this approach is that it allows multi character delimiter, while cut allows only single character delimiter
	#my_architecture=read hostnamectl | sed -n '/Architecture/Ip' |  awk '$1=$1 {print}' | awk 'BEGIN {FS=": "}{print $2}'
	
	# return value of the function is chip architecture
	return $my_architecture
}

#Calling the function
get_architecture