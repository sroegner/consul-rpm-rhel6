#!/bin/bash

source $(dirname $BASH_SOURCE)/functions.sh

[[ -z "$1" ]] && usage

PKG=$(echo $(basename $0)|sed 's/\(build-\)\(.*\)\(-rpm.sh$\)/\2/g')
VERSION=$1
ARCH=${2:-$(uname -m)}

main $PKG $VERSION $ARCH
