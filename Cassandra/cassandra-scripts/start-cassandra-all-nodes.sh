#! /bin/bash

# Total Number of nodes in the cluster
num_node=5

# $(seq $num_node) : seq in bash is range in python
for num in $(seq $num_node)
do
        # Start Datastax Cassandra with the following command
        bash /opt/cassandra/node$num/bin/dse cassandra
        # Wait for 60 seconds
        sleep 1m
        # std.out - Following Message
        echo "-------------------------------------------------------------------------------------------------------------------------"
        echo -e "\t\t\t node$num started successfully"
        echo "-------------------------------------------------------------------------------------------------------------------------"
done

# std.out following message once all nodes are started successfully
echo "-------------------------------------------------------------------------------------------------------------------------"
echo -e "\t\t All($num_node) nodes started successfully"
echo "-------------------------------------------------------------------------------------------------------------------------"
echo ""
echo "To check status run: bash /opt/cassandra/node1/bin/nodetool status"
echo ""