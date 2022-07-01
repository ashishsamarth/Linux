#! /bin/bash

# Declare the function name
get_configured_partitioner()
{	
	# Positional Argument of node number is assiged to variable
	node_num=$1
	# Always make sure read is present
	# read allows to run and return the output of the command to the variable
	# final output is the configured-partitioner of the node number provided by user as cmd line argument
	conf_partitioner=read grep -i ^partitioner ~/node$node_num/resources/cassandra/conf/cassandra.yaml | rev | cut -d '.' -f1 | rev
	
	# Return value of the function is the configured partitioner for given node
	return $conf_partitioner
}

# Calling the function
# Provide the node number (numerical 1,2,3) as the positional argument
get_configured_partitioner $1