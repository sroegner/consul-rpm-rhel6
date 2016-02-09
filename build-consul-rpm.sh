#!/bin/bash

source $(dirname $BASH_SOURCE)/functions.sh

[[ -z "$1" ]] && usage

PKG=$(echo $(basename $0)|sed 's/\(build-\)\(.*\)\(-rpm.sh$\)/\2/g')
BUILDROOT=$PROJ_ROOT/target/buildroot_$PKG
VERSION=$1
ARCH=${2:-$(uname -m)}

main $PKG $VERSION $ARCH

cd $BUILDROOT
CFG_FILES=$(find etc -type f | grep -v 'init.d' | grep -v example | sed 's/^/--config-files=/g')
cd - &>/dev/null

  # create rpm
fpm -s dir -t rpm -f \
    -C ${BUILDROOT} \
    -n ${PKG} \
    -v ${VERSION} \
    -p rpms \
    -d "consul" \
    --rpm-os "linux" \
    --iteration ${BUILD_NUMBER:-1} \
    --after-install spec/${PKG}_postinstall.spec \
    --before-remove spec/${PKG}_preuninstall.spec \
    --rpm-ignore-iteration-in-dependencies \
    --description "${PKG} for RedHat Enterprise Linux 6" \
    --directories var/lib/consul \
    --directories etc/consul.d \
    $CFG_FILES \
    $(ls $BUILDROOT)
