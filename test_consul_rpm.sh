#!/bin/bash

# this is not intended for CI testing so much as for a quick 
# manual regression check after changes to the rpm

msg ()
{
  echo "[$(date)] ${1}"
}

DOCKER=$(which docker)

$DOCKER rm -f test-consul-rpm &>/dev/null || :
msg "Starting a basic centos 6 container"
$DOCKER run -d --name=test-consul-rpm sroegner/centos-base-ssh:6 

rpm=$(ls -1tr rpms/consul-0*rpm|tail -1)
IP=$($DOCKER inspect --format='{{ .NetworkSettings.IPAddress }}' test-consul-rpm)
msg "Copy $rpm into the container"

$DOCKER cp $rpm test-consul-rpm:/tmp/

msg "Install - the service should be added but not enabled or running"
$DOCKER exec test-consul-rpm rpm -ivh /tmp/$(basename $rpm)
$DOCKER exec test-consul-rpm service consul status

msg "Start consul, wait 10 seconds"
$DOCKER exec test-consul-rpm service consul start
sleep 10
msg "Running?"
$DOCKER exec test-consul-rpm service consul status
msg "process?"
$DOCKER exec test-consul-rpm ps -fC consul
msg "consul service status check"
curl ${IP}:8500/v1/health/service/consul

msg "just uninstall the rpm now"
$DOCKER exec test-consul-rpm rpm -e consul

msg "post-cleanup checks"
msg "look for a consul process"
$DOCKER exec test-consul-rpm ps --no-header -fC consul || echo "no consul process"
msg "look for a consul user"
$DOCKER exec test-consul-rpm getent passwd consul || echo "no consul user"
msg "look for consul in /etc"
$DOCKER exec test-consul-rpm find /etc -name '*consul*'
msg "look for consul in /var/lib - there should be state files preserved after rpm uninstall"
$DOCKER exec test-consul-rpm find /var/lib/consul

msg "removing the test container"
$DOCKER rm -f test-consul-rpm
