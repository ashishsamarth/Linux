#! /bin/bash

# This script performs the following
    # Downloads DSE Cassandra version 6.0.0
    # Creates required directory structures based on the number of nodes to be created
    # Updates the configuration files per node
    # --> Creates a minimum of 1 and maximum of 9 nodes on same local host
    # Enables the configuration file for use

# Verify the URL before use, just to be sure its working fine

# Identify the current logged in user
trigger_owner=`whoami`

# Store the tar ball name in a variable
# This will help control the version of cassandra you wish to install
tar_ball="dse-6.0.tar.gz"
# Manage the download url via a variable
download_url="https://downloads.datastax.com/enterprise/'$tar_ball"

# Proceed only if the the current user is root
# Installation is done as root, since we need to create directories under /opt
if [[ $trigger_owner == 'root' ]]
then
    echo " "
    # Fetch the number of nodes the user wishes to create in to a variable
    read -p 'Enter the number of nodes you wish to create:- ' num_node

    # The user input must be an integer between 1 and 9
    if [[ "$num_node" =~ ^[1-9]+$ ]]
    # If you wish to create up to 99 nodes, use the following
    # if [[ "$num_node" =~ ^[1-9][0-9]+$ ]]
    then
        echo ""
        echo "-------------------------------------------------------------------------------------------------------------------------" 
        echo "stage#1 : Download Datastax Cassandra"
        # Navigate to /tmp and perform a silent download of DSE Cassandra version 6.0.0
        cd /tmp && echo "Downloading Datastax Cassandra version 6.0.0"
        # -q flag of wget performs a silent download from the url
        # && followed by echo is to validate if the wget was successful
        wget -q $download_url && echo "Tar-Ball: Downloaded Successfully"

        # Uncompress the tar-ball
        # && followed by echo is to validate if the tar -xf was successful
        tar -xf $tar_ball && echo "Tar-Ball: Uncompressed successfully in `pwd`"

        # Delete the tar-ball; since its no longer needed
        rm -rf $tar_ball && echo "Tar-Ball: Deleted from `pwd`"

        echo "stage#1 : Completed Successfully"
        echo "****************************************************"
        echo ""
        echo "stage#2 : Create Home & Configuration Directories for $num_node Nodes"
        echo "-------------------------------------------------------------------------------------------------------------------------"
        # $(seq $num_node) : It behaves as a range
        # Run a for loop
        for num in $(seq $num_node)
            do
                # Create home directories for Nodes
                mkdir -p /opt/cassandra/node$num
                echo -e "\tProcessing Node Number :- node$num"
                echo -e "\t\tHome directory created in /opt/cassandra/node$num"
                
                # Create configuration directories for each node
                # hints, data, commitlog, cdc_raw, saved_caches are the sub directories to be created
                # echo back directory creation messages to stdout 
                for sub_dir in hints data commitlog cdc_raw saved_caches
                do
                    mkdir -p /var/lib/cassandra/node$num/$sub_dir
                    echo -e "\t\tConfig Directory $sub_dir created in /var/lib/cassandra/node$num"
                done

                # Perform a protected recurssive copy from uncompressed tar-ball to node home for iterated node number
                cp -pR /tmp/dse-6*/* /opt/cassandra/node$num/. && echo -e "\t\tFiles Copied successfully to /opt/cassandra/node$num"
                # Since the script is executed as root
                # Perform change ownership recursively to non-root user
                chown -R $USER:$USER /opt/cassandra
                echo "-------------------------------------------------------------------------------------------------------------------------"
            done
            echo "stage#2 : Completed Successfully"
            echo "****************************************************"
            echo " "
            echo "stage#3 : Updating Node Configuration"
            # Create an empty variable to hold the seed ip values
            # At the end of for loop, result will be an appended list of ip addresses separated by comma
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

            # Run a For loop
            for num in $(seq $num_node)
                do
                    echo -e "\tProcessing Node Number :- node$num"
                    # Make a copy of cassandra.yaml
                    cp -p /opt/cassandra/node$num/resources/cassandra/conf/cassandra.yaml /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml
                    # Make a copy of cassandra-env.sh
                    cp -p /opt/cassandra/node$num/resources/cassandra/conf/cassandra-env.sh /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num-env.sh
                    # Make a copu of cqlsh.py
                    cp -p /opt/cassandra/node$num/resources/cassandra/bin/cqlsh.py /opt/cassandra/node$num/resources/cassandra/bin/cqlsh_mod_node$num.py

                    # Identify if parameter: initial_token is defined
                    get_initial_token_val=`grep -nF '^initial_token:' /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml`
                    # Identify if parameter: num_tokens is defined
                    get_num_tokens_val=`grep -nF '^num_tokens:' /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml`

                    # These parameters needs to be checked since only one of them should be defined
                    # Defining both of them will interfere with Cassandra Start up
                    # In this case, I am defining num_tokens
                    echo -e "\t\tUpdating Configuration for cassandra.yaml"
                    # Add Parameter num_tokens with value of 1 only when 
                    # $get_initial_token_val does not have any value and $get_num_tokens_val does not have any value

                    # Start update: cassandra.yaml
                    if [[ -z $get_initial_token_val ]] && [[ -z $get_num_tokens_val ]]
                    then
                        # Find num_tokens
                        # Insert an empty line below the line number where pattern was found
                        # Add paramter with value
                        # num_tokens: 1
                        # In the cassandra.yaml file per node
                        sed -i '/num_tokens:/{n;s/$/num_tokens: 1/}' /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml
                    fi

                    # Modify the directory paths created per node in cassandra.yaml file per node
                    sed -i "s/\/var\/lib\/cassandra\//\/var\/lib\/cassandra\/node$num\//g" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml

                    # Modify Seed Provider List per node in cassandra.yaml file per node
                    sed -i "/seeds:/ s/127.0.0.1/$seed_ip_list/" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml

                    # Modify Param: listen_address per node in cassandra.yaml file per node
                    sed -i "/^listen_address/ s/localhost/127.0.0.$num/" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml

                    # Modify Param: native_transport_port per node in cassandra.yaml file per node
                    sed -i "/^native_transport_port/ s/9042/904$num/" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml

                    # Modify Param: native_transport_address (old name: rpc_address) per node
                    sed -i "/^native_transport_address/ s/localhost/127.0.0.$num/" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml

                    # Rename default cassandra.yaml to cassandra.yaml_orig
                    mv /opt/cassandra/node$num/resources/cassandra/conf/cassandra.yaml /opt/cassandra/node$num/resources/cassandra/conf/cassandra.yaml_orig
                    # Rename modified cassandra_mod_node.yaml to cassandra.yaml
                    mv /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num.yaml /opt/cassandra/node$num/resources/cassandra/conf/cassandra.yaml

                    # echo back modified parameters to stdout
                    for param in num_tokens config_dirs seed_provider listen_address native_transport_port native_transport_address
                    do
                        echo -e "\t\t\t$param updated for node$num"
                    done
                    echo -e "\n"
                    # End update: cassandra.yaml

                    # Start update: cassandra-env.sh
                    echo -e "\t\tUpdating Configuration for cassandra-env.sh"
                    # Update value fo param: MAX_HEAP_SIZE to 512M
                    sed -i '/\t*MAX_HEAP_SIZE="/ s/${max_heap_size_in_mb}M/512M/' /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num-env.sh
                    
                    # Define Ending port number to be used with stream editor: In place editing
                    port_end=99
                    # Update value for param: JMX_PORT to node specific port #
                    sed -i "/JMX_PORT=/ s/7199/7$num$port_end/" /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num-env.sh

                    echo -e "\t\t\tMAX_HEAP_SIZE & JMX_PORT updated in Cassandra-env.sh for node$num"

                    # Rename default cassandra-env.sh to cassandra-env.sh_orig
                    mv /opt/cassandra/node$num/resources/cassandra/conf/cassandra-env.sh /opt/cassandra/node$num/resources/cassandra/conf/cassandra-env.sh_orig
                    # Rename default cassandra_mod_node-env.sh to cassandra-env.sh
                    mv /opt/cassandra/node$num/resources/cassandra/conf/cassandra_mod_node$num-env.sh /opt/cassandra/node$num/resources/cassandra/conf/cassandra-env.sh

                    # End update: cassandra-env.sh

                    # Start update: cqlsh.py
                    echo -e "\n"
                    echo -e "\t\tUpdating Configuration for cqlsh.py"
                    # Update value fo param: DEFAULT_HOST to Node specific ip address
                    sed -i "/^DEFAULT_HOST/ s/127.0.0.1/127.0.0.$num/" /opt/cassandra/node$num/resources/cassandra/bin/cqlsh_mod_node$num.py
                    # Update value fo param: DEFAULT_POR to Node specific port number
                    sed -i "/^DEFAULT_PORT/ s/9042/904$num/" /opt/cassandra/node$num/resources/cassandra/bin/cqlsh_mod_node$num.py
                    # echo back modified parameters to stdout
                    echo -e "\t\t\tDEFAULT HOST & PORT updated in cqlsh.py for node$num"

                    # Rename default cqlsh.py to cqlsh.py_orig
                    mv /opt/cassandra/node$num/resources/cassandra/bin/cqlsh.py /opt/cassandra/node$num/resources/cassandra/bin/cqlsh.py_orig
                    # Rename default cqlsh_mod_node.py to cqlsh.py
                    mv /opt/cassandra/node$num/resources/cassandra/bin/cqlsh_mod_node$num.py /opt/cassandra/node$num/resources/cassandra/bin/cqlsh.py
                    
                    # End update: cqlsh.py
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