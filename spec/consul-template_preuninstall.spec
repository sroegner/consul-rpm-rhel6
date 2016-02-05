#!/bin/bash

service consul-template stop &>/dev/null || :
chkconfig --del consul-template &>/dev/null || :
userdel -r consul-template &>/dev/null || :

