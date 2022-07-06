#! /bin/bash

# Navigate to the home dir for node 1
# So that nodetool script can be executed
cd $CASSANDRA_HOME_NODE1

# Declare the function name

# Function to get the total number of counts in the cluster
get_total_node_count()
{
        # Execute the nodetool status script and get the total count of nodes in the cluster
        total_node_count=read ./nodetool status | awk '{print $1}'|egrep -c 'UN|DN'
        # Return value of the function is total number of nodes in the cluster
        return $total_node_count
}

# Function to get the count of online nodes in the cluster
get_online_node_count()
{
        # Execute the nodetool status script and get the count of online nodes in the cluster
        online_node_count=read ./nodetool status | awk '{print $1}'|egrep -c 'UN'
        # Return value of the function is count of online nodes in the cluster
        return $online_node_count
}

# Function to get the count of offline nodes in the cluster
get_offline_node_count()
{
        # Execute the nodetool status script and get the count of offline nodes in the cluster
        offline_node_count=read ./nodetool status | awk '{print $1}'|egrep -c 'DN'
        # Return value of the function is count of offline nodes in the cluster
        return $offline_node_count
}


# Calling the function
total_num_of_nodes=$(get_total_node_count)
online_node_count=$(get_online_node_count)
offline_node_count=$(get_offline_node_count)

if [[ -n $total_num_of_nodes ]]
then
        echo "Total Number of nodes in the cluster :- $total_num_of_nodes"
else
        echo "Cassandra is Not running"
fi

if [[ -n $online_node_count ]]
then
        echo "Number of online nodes :- $online_node_count"
else
        echo "Cassandra is Not running"
fi

if [[ -n $offline_node_count ]]
then
        echo "Number of offline nodes :- $offline_node_count"
else
        echo "All nodes in the cluster are online"
fi
