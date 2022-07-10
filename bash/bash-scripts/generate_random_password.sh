#! /bin/bash
# Read the character length from user input
read -p "Enter the character count for your random password :- " chr_cnt

# Assign the random text generated from following command to variable
# cat /dev/urandom generated the combination of printable and non-printable characters
# tr -dc 'a-zA-Z0-9' translates the characters into lower case, upper case and numbers
# fold -w $chr_cnt will limit the generated text to character count by user in one line (reverse of new line character)
# head -n 1 will pick the 1st generated random text
rdm_password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $chr_cnt |head -n 1`

# Display the text to std out
echo $rdm_password
