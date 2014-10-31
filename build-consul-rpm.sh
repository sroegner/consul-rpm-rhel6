#!/bin/bash
#

if [[ -z "$1" ]]; then
  echo "Usage: $0 <VERSION>"
  exit 1
fi

VERSION=$1
URL="https://dl.bintray.com/mitchellh/consul/${VERSION}_linux_amd64.zip"
echo "Creating consul RPM build file version ${VERSION}"

# fetching consul
wget --no-check-certificate -q $URL  || {
    echo "URL or version not found!" >&2
    exit 1
}

# create target structure
rm -rf target
mkdir -p target/usr/local/bin
mkdir -p target/etc/init.d
cp -r sources/etc/ target/

# unzip
unzip -qq ${VERSION}_linux_amd64.zip -d target/usr/local/bin/
rm ${VERSION}_linux_amd64.zip

# create rpm
fpm -s dir -t rpm \
       -C target -n consul \
       -v ${VERSION} \
       -p target \
       --after-install spec/service_install.spec \
       --after-remove spec/service_uninstall.spec \
       --description "Consul RPM package for RedHat Enterprise Linux 6" \
       --url "https://github.com/hypoport/consul-rpm-rhel6" \
       usr/ etc/

rm -rf target/etc target/usr
