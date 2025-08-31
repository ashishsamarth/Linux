# Declare the name of function
get_path_of_bash_shell()
{	
	# get the path of your shell for addition to shebang
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	bash_path=read which bash|xargs

	# Another way of executing the piped command in bash is by using command keyword
	# bash_path=command which bash|xargs
	
	# return value of the function is path of the bash shell
	return $bash_path
}

# Calling the function
get_path_of_bash_shell