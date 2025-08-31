#!/bin/bash

# Total Number of nodes in the cluster
num_node=$(find /opt/cassandra/ -type d -name 'node*' -print|wc -l)

# Initiate node1 first
bash /opt/cassandra/node1/bin/dse cassandra  1> /dev/null
echo "-------------------------------------------------------------------------------------------------------------------------"
echo -e "\t\t\t node1 start triggered successfully"
sleep 30s


# $(seq $num_node) : seq in bash is range in python
for num in $(seq 2 $num_node)
do
        # Start Datastax Cassandra with the following command
        bash /opt/cassandra/node$num/bin/dse cassandra  1> /dev/null
        # Wait for 5 seconds
        sleep 5s
        # std.out - Following Message
        echo "-------------------------------------------------------------------------------------------------------------------------"
        echo -e "\t\t\t node$num start triggered successfully"
done
echo "-------------------------------------------------------------------------------------------------------------------------"

# Once all the nodes are triggered, add a delay of 30 seconds, and check the status again
sleep 30s

# std.out following message once all nodes are started successfully
node_run_cnt=$(bash /opt/cassandra/node1/bin/nodetool status|grep -c 'UN')

# Add new line character
echo -e "\n"

# Execute the Until loop, till all the nodes are up and running
until [[ $node_run_cnt -eq $num_node ]]
do
        # Fetch the latest count of running which are up and running
        node_run_cnt=$(bash /opt/cassandra/node1/bin/nodetool status|grep -c 'UN')
        echo -e "\t\t\t Few of the nodes in the cluster are still coming up...Please Wait"
        echo -e "\n"
        sleep 10s
done
echo "-------------------------------------------------------------------------------------------------------------------------"
echo -e "\t\t All($num_node) nodes started successfully"
echo "-------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "To check status run: bash /opt/cassandra/node1/bin/nodetool status"
echo ""