#!/bin/bash

source $(dirname $BASH_SOURCE)/functions.sh

if [[ -z "$1" ]]; then
  echo $"Usage: $0 <VERSION> [ARCH]"
  exit 1
fi

VERSION=$1
ARCH=${2:-$(uname -m)}
PKG=consul
BUILDROOT=$PROJ_ROOT/target/buildroot_$PKG
get_zipfile_name ZIP consul_${VERSION}_linux $ARCH
ZIP_PATH=$PROJ_ROOT/downloads/$ZIP

get_url URL $ZIP $VERSION $PKG

cleanup
info "Make directory structure"
mkdir -p downloads $BUILDROOT/usr/local/bin $BUILDROOT/etc/init.d rpms
http_get $URL $ZIP_PATH

info "Creating consul ${ARCH} RPM build file version ${VERSION}"
info "Add config templates to build root"
cp -r sources/$PKG/etc/ $BUILDROOT
info "Add binaries to build root"
unzip -qq ${ZIP_PATH} -d ${BUILDROOT}/usr/local/bin/

# create rpm
fpm -s dir -t rpm -f \
       -C $BUILDROOT \
       -n $PKG \
       -v ${VERSION} \
       -p rpms \
       -a ${ARCH} \
       --iteration ${BUILD_NUMBER:-1} \
       --rpm-ignore-iteration-in-dependencies \
       --after-install spec/service_install.spec \
       --after-remove spec/service_uninstall.spec \
       --description "Consul RPM package for RedHat Enterprise Linux 6" \
       --url "https://github.com/hypoport/consul-rpm-rhel6" \
       usr/ etc/

