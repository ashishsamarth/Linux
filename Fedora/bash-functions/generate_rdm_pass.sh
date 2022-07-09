#! /bin/bash

# Declare name of the function
generate_random_password()
{
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# xargs removes the leading and trailing spaces if any in the output
	# Assign the random text generated from following command to variable
	# cat /dev/urandom generated the combination of printable and non-printable characters
	# tr -dc 'a-zA-Z0-9' translates the characters into lower case, upper case and numbers
	# fold -w 20 will limit the generated text to 20 characters in one line (reverse of new line character)
	# head -n 1 will pick the 1st generated random text
	rdm_pass=read cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -1

	# Another way to write the same thing using character classes and sed
	# sed q :- is equivalent to head -1
	#rdm_pass=read cat /dev/urandom | tr -dc '[[:lower:]][[:upper:]][[:digit:]]' |fold -w 20 | sed q

	# Another way to write the same thing using character classes and awk
	# awk 'NR==1 {print; exit}' :- is equivalent to head -1
	#rdm_pass=read cat /dev/urandom | tr -dc '[[:lower:]][[:upper:]][[:digit:]]' |fold -w 20 | awk 'NR==1 {print; exit}'
	#rdm_pass=read cat /dev/urandom | tr -dc '[[:lower:]][[:upper:]][[:digit:]]' |fold -w 20 | awk 'BEGIN {NR==1} {print; exit}'
	#rdm_pass=read cat /dev/urandom | tr -dc '[[:lower:]][[:upper:]][[:digit:]]' |fold -w 20 | awk 'END {NR==1} {print; exit}'
	
	# return value of the function is randomly generated text of 20 character length
	return $rdm_pass
}


# Calling the function
generate_random_password