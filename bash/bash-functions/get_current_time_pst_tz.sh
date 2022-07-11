#!/bin/bash

# Declare the function name
get_current_time_pst_tz()
{
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	time_now=read TZ='America/Los_Angeles' date +%T

	# Another way of executing the piped command in bash is by using command keyword
	# time_now=command TZ='America/Los_Angeles' date +%T

	# return value of the function is current time in PST
	return $time_now
}

# Calling the function
get_current_time_pst_tz