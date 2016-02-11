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

CONSUL_VERSION=0.6.3

# make two rpms for upgrade testing
BUILD_NUMBER=20001 ./build-consul-rpm.sh $CONSUL_VERSION
BUILD_NUMBER=20002 ./build-consul-rpm.sh $CONSUL_VERSION
RPM1=rpms/consul-${CONSUL_VERSION}-20001.x86_64.rpm
RPM2=rpms/consul-${CONSUL_VERSION}-20002.x86_64.rpm

IP=$($DOCKER inspect --format='{{ .NetworkSettings.IPAddress }}' test-consul-rpm)
msg "Copy RPMs into the container"

$DOCKER cp $RPM1 test-consul-rpm:/tmp/
$DOCKER cp $RPM2 test-consul-rpm:/tmp/

msg "Install - the service should be added but not enabled or running"
$DOCKER exec test-consul-rpm rpm -ivh /tmp/$(basename $RPM1)
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
echo

msg "now upgrade the rpm"
$DOCKER exec test-consul-rpm rpm -Uvh /tmp/$(basename $RPM2)
$DOCKER exec test-consul-rpm service consul status
sleep 10
msg "Running?"
$DOCKER exec test-consul-rpm service consul status
msg "process?"
$DOCKER exec test-consul-rpm ps -fC consul
msg "consul service status check"
curl ${IP}:8500/v1/health/service/consul
echo

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
msg cleanup
rm -vf $RPM1 $RPM2
