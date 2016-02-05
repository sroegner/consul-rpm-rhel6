#!/bin/bash

cd -P $(dirname ${BASH_SOURCE})
PROJ_ROOT=$(pwd)
cd - &>/dev/null

function errmsg()
{
  info "${1}" ERROR
}

function usage()
{
  echo "Usage: $(basename $0) <VERSION> [ARCH]"
  exit 1
}

function err()
{
  errmsg "$1"
  exit 1
}

function info()
{
  echo -e "[$(date)] ${2:-"INFO:"} ${1}"
}

function get_zipfile_name()
{
  local  __resultvar=$1
  local PREFIX=${2}
  local ARCH=${3}

  echo $RED
  case "${ARCH}" in
    i386)
      ZIP=${PREFIX}_386.zip
      ;;
    x86_64)
      ZIP=${PREFIX}_amd64.zip
      ;;
    *)
      err "Unknown architecture ${ARCH}"
      ;;
  esac
  eval $__resultvar="'$ZIP'"
}

function get_url()
{
  local  __resultvar=$1
  local ZIP=$2
  local VERSION=$3
  local BIN=$4

  URL="https://releases.hashicorp.com/${BIN}/${VERSION}/${ZIP}"
  eval $__resultvar="'$URL'"
}

http_get()
{
  [ "$1" = "" ] && err "Need a source url"
  [ "$2" = "" ] && err "Need a target file path"
  [ ! -d $(dirname $2) ] && err "target directory $(dirname $2) does not exist"
  info "Downloading $1"
  curl --fail --silent -L -o $2 $1 || err "Downloading $ZIP failed"
}

cleanup()
{
  info "Cleaning up project root $PROJ_ROOT"
  rm -rf target downloads
}

main()
{
  PKG=${1}
  VERSION=${2}
  ARCH=${3}
  BUILDROOT=$PROJ_ROOT/target/buildroot_$PKG
  get_zipfile_name ZIP ${PKG}_${VERSION}_linux $ARCH
  ZIP_PATH=$PROJ_ROOT/downloads/$ZIP

  get_url URL $ZIP $VERSION $PKG

  cleanup
  info "Make directory structure"
  mkdir -p downloads $BUILDROOT/usr/sbin $BUILDROOT/etc/init.d rpms
  http_get $URL $ZIP_PATH

  info "Creating consul ${ARCH} RPM build file version ${VERSION}"

  info "Add config templates to build root"
  cp -r sources/$PKG/etc $BUILDROOT
  info "Add binaries to build root"
  unzip -qq ${ZIP_PATH} -d ${BUILDROOT}/usr/sbin/

  if [ "${PKG}" = "consul" ]
  then
    UIZIP=consul_${VERSION}_web_ui.zip
    UIZIP_PATH=$PROJ_ROOT/downloads/$UIZIP
    get_url UIURL $UIZIP $VERSION $PKG
    http_get $UIURL $UIZIP_PATH
    info "Add UI code to $PKG build root"
    mkdir -p ${BUILDROOT}/var/lib/consul/ui
    unzip -qq ${UIZIP_PATH} -d ${BUILDROOT}/var/lib/consul/ui/
    info "Add UI configuration to $PKG build root"
    cp -r sources/consul-ui/etc $BUILDROOT
  fi

  
  # create rpm
  fpm -s dir -t rpm -f \
       -C ${BUILDROOT} \
       -n ${PKG} \
       -v ${VERSION} \
       -p rpms \
       -d "consul" \
       --rpm-os "linux" \
       --after-install spec/${PKG}_postinstall.spec \
       --before-remove spec/${PKG}_preuninstall.spec \
       --rpm-ignore-iteration-in-dependencies \
       --description "${PKG} for RedHat Enterprise Linux 6" \
       $(ls $BUILDROOT)
}
