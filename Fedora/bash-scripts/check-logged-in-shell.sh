#! /bin/bash

# Assign the value of current shell to variable logged_shell
logged_shell=$SHELL

# Reference values for different types of shell
bourne=/bin/sh
bash=/bin/bash
cshell=/bin/csh
korn=/bin/ksh
zshell=/bin/zsh


# Case statement to compare reference values with variable value
case $logged_shell in
	$bourne)
		echo "You are working with BOURNE shell"
		;;
	$bash)
		echo "You are working with BASH shell"
		;;
	$cshell)
		echo "You are working with C-Shell"
		;;
	$korn)
		echo "You are working with Korn Shell"
		;;
	$zshell)
		echo "You are working with Z-shell"
		;;
esac


# How to execute: ./check-logged-in-shell.sh
