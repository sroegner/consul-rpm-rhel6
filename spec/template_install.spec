#!/bin/bash

chmod +x /usr/local/bin/consul-template
chmod +x /etc/init.d/consul-template

mkdir -p /var/consul-template > /dev/null 2>&1

useradd -M consul-template > /dev/null 2>&1
chown consul:consul /var/consul-template/ > /dev/null 2>&1

chkconfig --add consul-template > /dev/null 2>&1
