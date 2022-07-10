#! /bin/bash

# Declare name of the function
get_total_num_of_lines()
{
	# Store the user provided filename argument to the variable
	file_name=$1
	# Assign line number to each line using cat -n, then go to last line of the file and get the first column value
	num_of_lines=`cat -n $file_name | awk 'END {print $1}'`
	# Echo the message to std_out
	echo "Total number of line in $file_name is :- $num_of_lines"
}

# If script is executed without postional argument
# i.e argument count is zero
if [[ $# != 1 ]]
then
	echo "Please provide the file name as argument to the function"
else
	# Calling the function
	get_total_num_of_lines $1
fi
