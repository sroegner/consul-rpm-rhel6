#!/bin/bash

echo '{
  "data_dir": "/var/consul",
  "bootstrap_expect": 1,
  "server": true,
  "ui_dir": "/opt/consul-ui",
  "client_addr": "0.0.0.0"
}' > /etc/consul.conf

service consul restart