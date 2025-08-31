#!/bin/bash

# Declare the function name
get_current_date()
{
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	todays_date=read date +%D

	# Another way of executing the piped command in bash is by using command keyword
	# todays_date=command date +%D	

	# return value of the function is today's date
	return $todays_date
}

# Calling the function
get_current_date