#!/bin/bash

service consul stop &>/dev/null || :
chkconfig --del consul &>/dev/null || :
userdel consul &>/dev/null || :
