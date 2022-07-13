#! /bin/bash

# Identify the current logged in user
trigger_owner=`whoami`

# Get the tar ball name
tar_ball="dse-6.0.tar.gz"

# Proceed only if the the current user is root
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

                    # Modify the directory paths created per node
                    sed -i "s/\/var\/lib\/cassandra\//\/var\/lib\/cassandra\/node$num\//g" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml

                    # Modify Seed Provider List per node
                    sed -i "/seeds:/ s/127.0.0.1/$seed_ip_list/" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml

                    # Modify Param: listen_address per node
                    sed -i "/^listen_address/ s/localhost/127.0.0.$num/" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml

                    # Modify Param: native_transport_port per node
                    sed -i "/^native_transport_port/ s/9042/904$num/" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml

                    # Modify Param: native_transport_address (old name: rpc_address) per node
                    sed -i "/^native_transport_address/ s/localhost/127.0.0.$num/" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml

                    mv /opt/cassandra/node$num/resources/cassandra/conf/cassandra.yaml /opt/cassandra/node$num/resources/cassandra/conf/cassandra.yaml_orig
                    mv /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml /opt/cassandra/node$num/resources/cassandra/conf/cassandra.yaml

                    for param in num_tokens config_dirs seed_provider listen_address native_transport_port native_transport_address
                    do
                        echo -e "\t\t\t$param updated for node$num"
                    done
                    echo -e "\n"
                    echo -e "\t\tUpdating Configuration for cassandra-env.sh"
                    sed -i '/\t*MAX_HEAP_SIZE="/ s/${max_heap_size_in_mb}M/512M/' /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num-env.sh
                    port_end=99
                    sed -i "/JMX_PORT=/ s/7199/7$num$port_end/" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num-env.sh

                    echo -e "\t\t\tMAX_HEAP_SIZE & JMX_PORT updated in Cassandra-env.sh for node$num"

                    mv /opt/cassandra/node$num/resources/cassandra/conf/cassandra-env.sh /opt/cassandra/node$num/resources/cassandra/conf/cassandra-env.sh_orig
                    mv /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num-env.sh /opt/cassandra/node$num/resources/cassandra/conf/cassandra-env.sh

                    echo -e "\n"
                    echo -e "\t\tUpdating Configuration for cqlsh.py"
                    sed -i "/^DEFAULT_HOST/ s/127.0.0.1/127.0.0.$num/" /opt/cassandra/node$num/resources/cassandra/bin/cqlsh_mod_node$num.py
                    sed -i "/^DEFAULT_PORT/ s/9042/904$num/" /opt/cassandra/node$num/resources/cassandra/bin/cqlsh_mod_node$num.py
                    echo -e "\t\t\tDEFAULT HOST & PORT updated in cqlsh.py for node$num"

                    mv /opt/cassandra/node$num/resources/cassandra/bin/cqlsh.py /opt/cassandra/node$num/resources/cassandra/bin/cqlsh.py_orig
                    mv /opt/cassandra/node$num/resources/cassandra/bin/cqlsh_mod_node$num.py /opt/cassandra/node$num/resources/cassandra/bin/cqlsh.py

                    echo "-------------------------------------------------------------------------------------------------------------------------"

                done
                echo -e "stage#3 : Completed Successfully"
                echo "****************************************************"


        else
                echo "User did not provide Number of Nodes in Valid Format"
        fi

else
        echo "Please run this script as a root user"
fi