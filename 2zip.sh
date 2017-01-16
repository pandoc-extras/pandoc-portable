#!/bin/bash

# usage: VERSION=1.19.1 source ./2zip.sh # source for running it in the current shell such that the variables can be obtained

# Notes:
# installing 7z
## Linux: `sudo apt-get install p7zip-full`
## macOS: `brew install p7zip`
# script below does not work on macOS host, pkg unpack

# url to pandoc version
url="https://github.com/jgm/pandoc/releases/tag/$VERSION"

# get url to pandoc binaries
debUrlPartial=$(curl -L $url | grep -o '/jgm/pandoc/releases/download/.*\.deb')
pkgUrlPartial=$(curl -L $url | grep -o '/jgm/pandoc/releases/download/.*\.pkg')
msiUrlPartial=$(curl -L $url | grep -o '/jgm/pandoc/releases/download/.*\.msi')

# download and extract
## Linux
if [[ ! -z "$debUrlPartial" ]]; then
  # variables
  debUrl="https://github.com$debUrlPartial"
  DEB=${debUrl##*/}
  debWoExt=${DEB%.*}
  debZip=$debWoExt.zip
  # download
  wget $debUrl
  # unpack
  ar x $DEB data.tar.gz && mv data.tar.gz $debWoExt.tar.gz
  tar -zxvf $debWoExt.tar.gz && mv usr $debWoExt
  # zip
  zip -r $debZip $debWoExt
fi
## macOS
if [[ ! -z "$pkgUrlPartial" ]]; then
  # variables
  pkgUrl="https://github.com$pkgUrlPartial"
  PKG=${pkgUrl##*/}
  pkgWoExt=${PKG%.*}
  pkgZip=$pkgWoExt.zip
  # download
  wget $pkgUrl
  # unpack
  7z x $PKG -o"$pkgWoExt"
  cat $pkgWoExt/pandoc.pkg/Payload | gunzip -dc |cpio -i && mv usr $pkgWoExt
  # zip
  zip -r $pkgZip $pkgWoExt
fi
## Windows
if [[ ! -z "$msiUrlPartial" ]]; then
  # variables
  msiUrl="https://github.com$msiUrlPartial"
  MSI=${msiUrl##*/}
  msiWoExt=${MSI%.*}
  msiZip=$msiWoExt.zip
  # download
  wget $msiUrl
  # unpack
  7z x $MSI -o"$msiWoExt"
  # zip
  zip -r $msiZip $msiWoExt
fi
