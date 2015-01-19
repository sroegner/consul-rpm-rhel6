Consul-rpm-rhel6
================

Building the 'consul' and 'consul-template' RPM packages for RedHat Enterprise Linux 6.


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
 ./build-consul-template-rpm.sh 0.5.1 x86_64
```

The new RPM file is located in the target folder. The target folder will be overridden
when the next build starts.

Using Vagrant
--------------------

In case you are using a system where installing rpmbuild is not easy, you can use 
[Vagrant](http://www.vagrantup.com).

This directory contains a Vagrantfile which can be used to start a virtual machine based on Linux. In order to generate the rpms you first need to start the vm using:

```
host$ vagrant up
```

(__host$__ is the prompt on your machine, __box$__ is inside the vagrantbox)

This can take a few minutes as it will probably download the centos box. it will also install fpm inside the box. Once this is done log onto the box:

```
host$ vagrant ssh
```

In the box cd into the shared folder and generate the rpms:

```
box$ cd /vagrant
box$ ./build-consul-rpm.sh 0.4.1 x86_64
...
```


