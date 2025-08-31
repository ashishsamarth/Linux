#!/bin/bash

# Validate if git is installed on the host
# And git configuration file exists in the user home
# Output of $(rpm -q git) provides the version number if git is installed

if [[ -n $(rpm -q git) ]] && [[ -f ~/.gitconfig ]]
then
	# Fetch the name from the git configuration file into variable
	# And suppress the output from stdout
	uname=`grep -iF "name" ~/.gitconfig | xargs | cut -d '=' -f2 | xargs`
	
	# Fetch the email from the git configuration file into variable
	# And suppress the output from stdout
	uemail=`grep -iF "email" ~/.gitconfig | xargs | cut -d '=' -f2 | xargs`
	
	# If the username variable value is not empty
	if [[ -n $uname ]]
		# Then echo the username that is configured
		then echo "Git-Configuration: Configured username is $uname"
	 	
		# If the email variable value is not empty
		if [[ -n $uemail ]]
			# Then echo the user meila that is configured
			then echo "Git-Configuration: Configured email is $uemail"
		else
			echo "Git-Configuration: Email is not configured"
		fi
	else
		echo "Git-Configuration: Username is not configured"
	fi

else
	# Get the Git-Username from User Input
	# Get the Git-Email from User Input
	
	read -p "Git-Configuration: Enter the username" git_username
	read -p "Git-Configuration: Enter the email" get_email
	
	# Configure the username and email based on provided input
	git config --global user.name $git_username
	git config --global user.email $git_email
	
	echo "Git Configuration: Username and Email configured successfully"
fi
