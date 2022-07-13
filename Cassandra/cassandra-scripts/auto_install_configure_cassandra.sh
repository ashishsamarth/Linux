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
