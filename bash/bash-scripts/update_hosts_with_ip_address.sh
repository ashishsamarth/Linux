#!/bin/bash

#get the server hostname
ova_hostname=$hostname

#search and remove current line with hostname at end of line in /etc/hosts
sed -i '/'$ova_hostname'$/ d' /etc/hosts 

#get current ip address of the host
ova_ip=$(/sbin/ifconfig | grep 'inet'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $2}')

#add current ip address and hostname to hosts file
echo "$ova_ip $ova_hostname" >>/etc/hosts