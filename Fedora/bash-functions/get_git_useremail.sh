#!/bin/bash

# Declare the function name
# This function fetches the configured email from git configuration file
get_git_useremail()
{
	# Validate
	# If git is installed
	# and gitconfig file exists
	if [[ -n $(rpm -q git) ]] && [[ -f ~/.gitconfig ]]
		# Fetch the user email from git configuration file
		then uemail=read grep -iF "email" ~/.gitconfig | xargs | cut -d '=' -f2 | xargs

		# AWK equivalent
		# uemail=read awk 'BEGIN {IGNORECASE=1} /email/ {print}' ~/.gitconfig | awk '$1=$1' |awk 'BEGIN {FS=" = "} {print $2}'

		# SED + AWK equivalent
		# uemail=read sed -n '/email/Ip' ~/.gitconfig | sed s'/^[[:space:]]//' | awk 'BEGIN {FS=" = "} {print $2}'
		
		# If the user email is not empty
		if [[ -n $uemail ]]
		then
			# Return value of this function is :- Git User Email
			return $uemail
		else
			# Return value of this function is :- Static text
			return "Git-Configuration: User Email is not configured"
		fi
	fi
}

# Calling the function
get_git_useremail
