#!/bin/bash

# Assumption: Firewalld package is installed
# Iterate over the output of `firewall-cmd --list--ports`
for rec in `firewall-cmd --list-ports`

# For each iterated value, perform an echo
do
	echo "$rec is currently opened"
done

# One-liner-execution-style
# for rec in `firewall-cmd --list-ports`; do echo "$rec is currently opened"; done;
