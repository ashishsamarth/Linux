#!/bin/bash

# Declare the function name
get_root_fs_hdd_avail_size()
{
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	avail_hhd_size=read df -h /|awk '{print $4}'| tail -1|xargs


	# Another way of executing the piped command in bash is by using command keyword
	# avail_hhd_size=command df -h /|awk '{print $4}'| tail -1|xargs

	# AWK Equivalent
	# avail_hhd_size=read df -h / | awk 'END {print $4}'

	# SED + AWK Equivalent
	# sed -n '$p' returns the end of line
	# avail_hhd_size=read df -h / | awk '{print $4}' | sed -n '$p'
	
	# return value of the function is used hard drive size in GBs
	return $used_hdd_size
}

# Calling the function
get_root_fs_hdd_avail_size