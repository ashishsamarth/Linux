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

            done
            echo "stage#2 : Completed Successfully"
            sleep 2
            echo "****************************************************"
            echo "stage#3 : Updating Node Configuration"
            sleep 3
            seed_ip_list=''
            for num in $(seq $num_node)
            do
                if [[ $num < $num_node ]]
                then
                    seed_ip_list+="127.0.0.$num, "
                else
                    seed_ip_list+="127.0.0.$num"
                fi
            done
            echo "-------------------------------------------------------------------------------------------------------------------------"

            for num in $(seq $num_node)
                do
                    echo -e "\tProcessing Node Number :- node$num"
                    cp -p /opt/cassandra/node$num/resources/cassandra/conf/cassandra.yaml /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml
                    cp -p /opt/cassandra/node$num/resources/cassandra/conf/cassandra-env.sh /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num-env.sh
                    cp -p /opt/cassandra/node$num/resources/cassandra/bin/cqlsh.py /opt/cassandra/node$num/resources/cassandra/bin/cqlsh_mod_node$num.py

                    get_initial_token_val=`grep -nF '^initial_token:' /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml`
                    get_num_tokens_val=`grep -nF '^num_tokens:' /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml`
                    echo -e "\t\tUpdating Configuration for cassandra.yaml"
                    # Add Parameter num_tokens with value of 1
                    if [[ -z $get_initial_token_val ]] && [[ -z $get_num_tokens_val ]]
                    then
                        sed -i '/num_tokens:/{n;s/$/num_tokens: 1/}' /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml
                    fi
