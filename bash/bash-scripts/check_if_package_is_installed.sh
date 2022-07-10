#!/bin/bash

# read the user input and store it in variable pkg_name
read -p "Enter the package name you wish to validate:- " pkg_name

# If the package is installed rpm -q package name will provide the version of package installed
# The default response of command is suppressed from stdout
if rpm -q $pkg_name 1> /dev/null
then
	# If the package is installed, following message will be echoed to std out
	echo "Response:- $pkg_name is installed on this host"
else
	# If the package is not installed, following message will be echoed to std out
	echo "Response:- $pkg_name is NOT installed on this host"
fi

# How to execute: ./check-if-package-is-installed.sh
# Package name to be provided after script execution, not as a positional parameter 