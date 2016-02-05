#!/bin/bash

getent passwd consul &>/dev/null || useradd -M --comment "consul daemon user" consul &>/dev/null || :
getent passwd consul &>/dev/null && {
  mkdir -p /var/lib/consul &>/dev/null || :
  chown consul:consul /var/lib/consul &>/dev/null || :
  chkconfig --add consul &>/dev/null || :
}

chmod +x /usr/sbin/consul &>/dev/null || :
