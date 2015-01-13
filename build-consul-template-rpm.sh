#!/bin/bash
#

if [[ -z "$1" ]]; then
  echo $"Usage: $0 <VERSION> [ARCH]"
  exit 1
fi

NAME=consul-template
VERSION=$1

if [[ -z "$2" ]]; then
  ARCH=`uname -m`
else
  ARCH=$2
fi
#https://github.com/hashicorp/consul-template/releases/download/v0.2.0/consul-template_0.2.0_linux_amd64.tar.gz
case "${ARCH}" in
    i386)
        ZIP=${NAME}_${VERSION}_linux_386.tar.gz
        ;;
    x86_64)
       ZIP=${NAME}_${VERSION}_linux_amd64.tar.gz
        ;;
    *)
        echo $"Unknown architecture ${ARCH}" >&2
        exit 1
        ;;
esac

URL="https://github.com/hashicorp/${NAME}/releases/download/v${VERSION}/${ZIP}"
echo $"Creating ${NAME} RPM build file version ${VERSION}"

# fetching consul
curl -k -L -o $ZIP $URL || {
    echo $"URL or version not found!" >&2
    exit 1
}

# clear target foler
rm -rf target/*

# create target structure
mkdir -p target/usr/local/bin/
cp -r sources/${NAME}/etc/ target/

# unzip
tar -xf ${ZIP} -O > target/usr/local/bin/${NAME}
rm ${ZIP}

# create rpm
fpm -s dir -t rpm -f \
       -C target -n ${NAME} \
       -v ${VERSION} \
       -p target \
       -d "consul" \
       --after-install spec/template_install.spec \
       --after-remove spec/template_uninstall.spec \
       --rpm-ignore-iteration-in-dependencies \
       --description "Consul-template RPM package for RedHat Enterprise Linux 6" \
       --url "https://github.com/hypoport/consul-rpm-rhel6" \
       usr/ etc/

rm -rf target/etc target/usr
