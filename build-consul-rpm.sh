#!/bin/bash
#

if [[ -z "$1" ]]; then
  echo $"Usage: $0 <VERSION> [ARCH]"
  exit 1
fi

VERSION=$1

if [[ -z "$2" ]]; then
  ARCH=`uname -m`
else
  ARCH=$2
fi

ZIP=${VERSION}_linux_amd64.zip

case "${ARCH}" in
    i386)
        ZIP=${VERSION}_linux_386.zip
        ;;
    x86_64)
       ZIP=${VERSION}_linux_amd64.zip
        ;;
    *)
        echo $"Unknown architecture ${ARCH}" >&2
        exit 1
        ;;
esac

URL="https://dl.bintray.com/mitchellh/consul/${ZIP}"
echo $"Creating consul ${ARCH} RPM build file version ${VERSION}"

# fetching consul
wget --no-check-certificate -q $URL  || {
    echo $"URL or version not found!" >&2
    exit 1
}

# create target structure
rm -rf target/usr target/etc
mkdir -p target/usr/local/bin
mkdir -p target/etc/init.d
cp -r sources/etc/ target/

# unzip
unzip -qq ${VERSION}_linux_amd64.zip -d target/usr/local/bin/
rm ${ZIP}

# create rpm
fpm -s dir -t rpm \
       -C target -n consul \
       -v ${VERSION} \
       -p target \
       -a ${ARCH} \
       --after-install spec/service_install.spec \
       --after-remove spec/service_uninstall.spec \
       --description "Consul RPM package for RedHat Enterprise Linux 6" \
       --url "https://github.com/hypoport/consul-rpm-rhel6" \
       usr/ etc/

rm -rf target/etc target/usr
