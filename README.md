Consul-rpm-rhel6
================

Building a consul RPM package for RedHat Enterprise Linux 6


Requirements
-------------------

* fpm
* rpmbuild

To see how to install and use fmp have a look at: <https://github.com/jordansissel/fpm>

How it works?
-------------------

* build-consul-rpm.sh creates a consul rpm
* build-consul-ui-rpm.sh creates a consul-ui rpm

An example to create a consul and consul-ui rpm version 0.4.1:

 ```
 ./build-consul-rpm.sh 0.4.1 `uname -m`
 ./build-consul-ui-rpm.sh 0.4.1 `uname -m`
```
