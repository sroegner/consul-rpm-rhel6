#!/bin/bash

cd -f $(dirname ${BASH_SOURCE})
PROJ_ROOT=$(pwd)
cd - &>/dev/null

function errmsg()
{
  echo -e "[$(date)] ERROR: ${1}" >&2
}

function err()
{
  errmsg $1
  exit 1
}

function info()
{
  echo -e "[$(date)] ${1}"
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
  curl --fail --silent -L -o $2 $1
}

cleanup()
{
  info "Cleaning up project root $PROJ_ROOT"
  rm -rf target downloads
}
