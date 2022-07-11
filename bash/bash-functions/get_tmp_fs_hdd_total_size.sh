#!/bin/bash

# Declare the function name
get_tmp_fs_hdd_total_size()
{
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	hhd_size=read df -h /tmp|awk '{print $2}'| tail -1|xargs


	# Another way of executing the piped command in bash is by using command keyword
	# hhd_size=command df -h /tmp|awk '{print $2}'| tail -1|xargs
	
	# return value of the function is total hard drive size in GBs
	return $hdd_size
}

# Calling the function
get_tmp_fs_hdd_total_size 