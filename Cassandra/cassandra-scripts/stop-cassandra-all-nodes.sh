#! /bin/bash

# Declare function name
get_cassandra_ps_id_by_node_num()
{
        # Positional Argument of node number is assiged to variable
        node_num=$1
        # Always make sure read is present
        # read allows to run and return the output of the command to the variable
        # $2 gets the pid for the node
        # $50 helps identifies the node number
        # final output is the process id of the node number provided by user as cmd line argument
        my_pid=read ps -aux | grep Ddse.server_process| grep -v grep | awk '{print $2, $50}'|grep -i "node$node_num"|awk '{print $1 $2}'|awk '{print $1}'|cut -d '-' -f1

        # Return value of the function is process id
        return $my_pid
}


# Calling the function
# Execution of the scripts calls the function with the command line argument
# 1> /dev/null :- Suppresses the output from std_out

# Total Number of Nodes in Cluster
num_node=5

# $(seq $num_node) : seq in bash is range in python
# following loop will run in LIFO
for num in $(seq $num_node | sort -nr)

do
        # Fetch the Process Id for each node in the cluster using a for loop
        ret_code=$(get_cassandra_ps_id_by_node_num $num) 1> /dev/null
        bash /opt/cassandra/node$num/bin/dse cassandra-stop -p $ret_code
        echo "Process id $ret_code for node$num is now stopped"
done

# Note: Script does not need any arguments
