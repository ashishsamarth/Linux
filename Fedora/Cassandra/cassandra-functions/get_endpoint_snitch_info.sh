#! /bin/bash

# Declare the function name
get_snitch_info()
{	
	# Positional Argument of node number is assiged to variable
	node_num=$1
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# final output is the snitch-info of the node number provided by user as cmd line argument
	snitch_info=read grep -i ^endpoint_snitch ~/node$node_num/resources/cassandra/conf/cassandra.yaml | rev | cut -d '.' -f1 | rev
	
	# Return value of the function is the configured partitioner for given node
	return $snitch_info
}

# Calling the function
get_snitch_info $1