trigger_owner=`whoami`
tar_ball="dse-6.0.tar.gz"
if [[ $trigger_owner == 'root' ]]

then
    read -p 'Enter the number of nodes you wish to create:- ' num_node
    if [[ "$num_node" =~ ^[0-9]+$ ]] && [[ $num_node > 0 ]]
    then
        echo "" 
        echo "stage#1 : Download Datastax Cassandra"
        cd /tmp && echo "Downloading Datastax Cassandra version 6.0.0"
        wget -q https://downloads.datastax.com/enterprise/$tar_ball && echo "Tar-Ball: Downloaded Successfully"
        sleep 5
        tar -xf $tar_ball && echo "Tar-Ball: Uncompressed successfully in `pwd`"
        rm -rf $tar_ball && echo "Tar-Ball: Deleted from `pwd`"

        sleep 5
        echo "stage#1 : Completed Successfully"
        echo "****************************************************"
        echo ""
        echo "stage#2 : Creating Home & Configuration Directories for $num_node Nodes"
        echo "-------------------------------------------------------------------------------------------------------------------------"
        for num in $(seq $num_node)
            do
                mkdir -p /opt/cassandra/node$num
                echo -e "\tProcessing Node Number :- node$num"
                echo -e "\t\tHome directory created in /opt/cassandra/node$num"
                mkdir -p /var/lib/cassandra/node$num/hints
                mkdir -p /var/lib/cassandra/node$num/data
                mkdir -p /var/lib/cassandra/node$num/commitlog
                mkdir -p /var/lib/cassandra/node$num/cdc_raw
                mkdir -p /var/lib/cassandra/node$num/saved_caches

                for sub_dir in hints data commitlog cdc_raw saved_caches
                do
                    echo -e "\t\tConfig Directory $sub_dir created in /var/lib/cassandra/node$num"
                done

                cp -pR /tmp/dse-6*/* /opt/cassandra/node$num/. && echo -e "\t\tFiles Copied successfully to /opt/cassandra/node$num"
                chown -R $USER:$USER /opt/cassandra
                echo "-------------------------------------------------------------------------------------------------------------------------"
                