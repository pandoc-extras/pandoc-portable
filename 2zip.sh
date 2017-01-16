#!/bin/bash

# usage: VERSION=1.19.1 ./2zip.sh

# Notes on installing 7z
# Linux: `sudo apt-get install p7zip-full`
# macOS: `brew install p7zip`

# url to pandoc version
url="https://github.com/jgm/pandoc/releases/tag/$VERSION"

# get url to pandoc binaries
debUrlPartial=$(curl -L $url | grep -o '/jgm/pandoc/releases/download/.*\.deb')
pkgUrlPartial=$(curl -L $url | grep -o '/jgm/pandoc/releases/download/.*\.pkg')
msiUrlPartial=$(curl -L $url | grep -o '/jgm/pandoc/releases/download/.*\.msi')

# download and extract
## Linux
if [[ ! -z "$debUrlPartial" ]]; then
  debUrl="https://github.com$debUrlPartial"
  DEB=${debUrl##*/}
  wget $debUrl
  # unpack
  ar x $DEB data.tar.gz && mv data.tar.gz ${DEB%.*}.tar.gz
fi
## macOS
if [[ ! -z "$pkgUrlPartial" ]]; then
  pkgUrl="https://github.com$pkgUrlPartial"
  PKG=${pkgUrl##*/}
  wget $pkgUrl
  # unpack
  7z x $PKG -oosx
  cat osx/pandoc.pkg/Payload | gunzip -dc |cpio -i
  zip -r ${PKG%.*}.zip usr/
fi
## Windows
if [[ ! -z "$msiUrlPartial" ]]; then
  msiUrl="https://github.com$msiUrlPartial"
  MSI=${msiUrl##*/}
  wget $msiUrl
  # unpack
  7z x $MSI -o${MSI%.*}
  zip -r ${MSI%.*}.zip ${MSI%.*}
fi

# debug
# echo $msiUrl
# echo $pkgUrl
# echo $msiUrl

