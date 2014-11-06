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
* build-consul-template-rpm.sh creates a consul-template rpm

An example to create a consul and consul-ui rpm version 0.4.1:

 ```
 ./build-consul-rpm.sh 0.4.1 x86_64
 ./build-consul-ui-rpm.sh 0.4.1 x86_64
 ./build-consul-template.sh 0.2.0 x86_64
```

The new RPM file is located in the target folder. The target folder will be overridden
when the next build starts.
