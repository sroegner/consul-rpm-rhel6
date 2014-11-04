#!/bin/bash

chkconfig --del consul > /dev/null 2>&1

rm -rf /var/consul > /dev/null 2>&1
rm -rf /etc/consul.d > /dev/null 2>&1
rm -f /etc/init.d/consul > /dev/null 2>&1

userdel -r consul > /dev/null 2>&1
