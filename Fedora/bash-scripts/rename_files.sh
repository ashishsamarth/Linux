#! /bin/bash

# basename get rids of the path associated with the file name
# However I have useed basename $BASH_SOURCE specifically to idenfity the filename of the executed bash script
# So, am running an ls in the current directory and only leaving the currently executed script from ls output
# Hence the output will have all the files except the currently executed script

read -p "Enter the character to be replaced :- " src_chr
read -p "Enter the character to be replaced with :- " tgt_chr

for rec in `ls|grep -v $(basename $BASH_SOURCE)`
# For all the files in the above piped command, perform the following
do
	# Assign the iterated filename to a variable
	filename=`basename $rec`

	# If the file is a regular file
	if [ -f $filename ]
		# Then rename the file and replace src_char with tgt_char in the name
		then mv -- $filename ${filename//$src_chr/$tgt_chr}
	fi

done
echo "All required files renamed successfully !"

# Executing the script
# ./rename_files.sh

# Parameters for the file are src_chr and tgt_chr