#!/bin/bash

getent passwd consul-template &>/dev/null || useradd -M consul-template &>/dev/null || :

chmod +x /usr/sbin/consul-template  &>/dev/null || :
chmod +x /etc/init.d/consul-template &>/dev/null || :

mkdir -p /var/lib/consul-template &>/dev/null || :

chown consul-template:consul-template /var/lib/consul-template &>/dev/null || :

chkconfig --add consul-template &>/dev/null || :
