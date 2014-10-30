#!/bin/bash

useradd -d consul -M consul
mkdir -p /var/consul
chkconfig --add consul
