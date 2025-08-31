#!/bin/bash

# Declare the function name
# This function fetches the username from configuration
get_git_username()
{
	# Validate
	# if git is installed
	# and gitconfig file exists
	if [[ -n $(rpm -q git) ]] && [[ -f ~/.gitconfig ]]
		# fetch the username from the git configuration file
		then uname=read grep -iF "name" ~/.gitconfig | xargs | cut -d '=' -f2 | xargs

		# AWK equivalent
		# awk '$1=$1' : Gets rid of the leading space just like xargs
		# uname=read awk 'BEGIN {IGNORECASE=1} /name/ {print}' ~/.gitconfig | awk '$1=$1' |awk 'BEGIN {FS=" = "} {print $2}'
		
		# SED + AWK equivalent
		# sed 's/^[[:space:]]//' :- Gets rid of leading space characters using the character classes
		# uname=read sed -n '/name/Ip' ~/.gitconfig | sed 's/^[[:space:]]//' | awk 'BEGIN {FS=" = "}{print $2}'

		# If the username value is not empty
		if [[ -n $uname ]]
		then	
			# Return value of this function is :- Git Username
			return $uname
		else
			# Return value of this function is :- Static text
			return "Git-Configuration: username is not configured"
		fi
	fi
}

# Calling the function
get_git_username