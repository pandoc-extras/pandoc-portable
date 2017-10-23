#!/usr/bin/env bash

# usage: VERSION=1.19.1 DEBUG=true source ./pandocDownload2zip.sh # source for running it in the current shell such that the variables can be obtained

# Notes:
# installing dependencies
## Linux: `sudo apt-get install p7zip-full msitools`, msitools requires ubuntu>=16.04
## macOS: `brew install msitools`

# debug msg
if [[ "$DEBUG" == "true" ]]; then
  echo "Processing pandoc version $VERSION"
fi

# url to pandoc version
url="https://github.com/jgm/pandoc/releases/tag/$VERSION"
# debug msg
if [[ "$DEBUG" == "true" ]]; then
  echo "Obtaining binaries from $url"
fi

# get url to pandoc binaries
html=$(curl -L --fail "$url")
if [[ $? != 0 ]]; then
  echo "Cannot retrieve $url. Check if version $VERSION is valid."
  exit 1
fi

debUrlPartial=$(printf '%s' "$html" | grep -o '/jgm/pandoc/releases/download/.*\.deb')
pkgUrlPartial=$(printf '%s' "$html" | grep -o '/jgm/pandoc/releases/download/.*\.pkg')
msiUrlPartial=$(printf '%s' "$html" | grep -o '/jgm/pandoc/releases/download/.*\.msi')
zipUrlPartial=$(printf '%s' "$html" | grep -o '/jgm/pandoc/archive/.*\.zip')
tarUrlPartial=$(printf '%s' "$html" | grep -o '/jgm/pandoc/archive/.*\.tar\.gz')
# debug msg
if [[ "$DEBUG" == "true" ]]; then
  echo "URL to deb: $debUrlPartial"
  echo "URL to pkg: $pkgUrlPartial"
  echo "URL to msi: $msiUrlPartial"
  echo "URL to source code in zip: $zipUrlPartial"
  echo "URL to source code in tar.gz: $tarUrlPartial"
fi

# prepare dist folder
mkdir -p dist

# download and extract
## Linux
if [[ ! -z "$debUrlPartial" ]]; then
  # variables
  debUrl="https://github.com$debUrlPartial"
  DEB="${debUrl##*/}"
  debWoExt="${DEB%.*}"
  debZip="$debWoExt.zip"
  # download
  wget "$debUrl"
  # unpack
  ar x "$DEB" data.tar.gz && mv data.tar.gz "$debWoExt.tar.gz"
  tar -zxvf "$debWoExt.tar.gz" && mv usr "$debWoExt"
  # zip
  zip -r "$debZip" "$debWoExt"
  # to dist/
  mv "$DEB" dist/
  mv "$debZip" dist/
  mv "$debWoExt.tar.gz" dist/
else
  echo "deb package not found"
fi
## macOS
if [[ ! -z "$pkgUrlPartial" ]]; then
  # variables
  pkgUrl="https://github.com$pkgUrlPartial"
  PKG="${pkgUrl##*/}"
  pkgWoExt="${PKG%.*}"
  pkgZip="$pkgWoExt.zip"
  # download
  wget "$pkgUrl"
  # unpack
  if [[ `uname` == "Darwin" ]]; then
    mkdir "$pkgWoExt-pkg" && xar -xf "$PKG" -C "$pkgWoExt-pkg"
  else
    7z x "$PKG" -o"$pkgWoExt-pkg"
  fi
  cat "$pkgWoExt-pkg/pandoc.pkg/Payload" | gunzip -dc |cpio -i && mv usr "$pkgWoExt"
  # zip
  zip -r "$pkgZip" "$pkgWoExt"
  # to dist/
  mv "$PKG" dist/
  mv "$pkgZip" dist/
else
  echo "pkg package not found"
fi
## Windows
if [[ ! -z "$msiUrlPartial" ]]; then
  # variables
  msiUrl="https://github.com$msiUrlPartial"
  MSI="${msiUrl##*/}"
  msiWoExt="${MSI%.*}"
  msiZip="$msiWoExt.zip"
  # download
  wget "$msiUrl"
  # unpack
  msiextract "$MSI" && mv "Program Files/Pandoc" "$msiWoExt" && rm -rf "Program Files"
  # zip
  zip -r "$msiZip" "$msiWoExt"
  # to dist/
  mv "$MSI" dist/
  mv "$msiZip" dist/
else
  echo "msi package not found"
fi
## Source Code
### .zip
if [[ ! -z "$zipUrlPartial" ]]; then
  # variables
  zipUrl="https://github.com$zipUrlPartial"
  ZIP="${zipUrl##*/}"
  # download
  wget "$zipUrl"
  # rename & to dist/
  mv "$ZIP" "dist/pandoc-source-code-$ZIP"
else
  echo "source code not found in zip"
fi
### .tar.gz
if [[ ! -z "$tarUrlPartial" ]]; then
  # variables
  tarUrl="https://github.com$tarUrlPartial"
  TAR="${tarUrl##*/}"
  # download
  wget "$tarUrl"
  # rename & to dist/
  mv "$TAR" "dist/pandoc-source-code-$TAR"
else
  echo "source code not found in tag.gz"
fi
