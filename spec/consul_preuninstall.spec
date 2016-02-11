#!/bin/bash

# only stop/erase if we're not updating
if [ $1 -eq 0 ]
then
  service consul stop &>/dev/null || :
  chkconfig --del consul &>/dev/null || :
  userdel consul &>/dev/null || :
fi
