#!/bin/bash

# install 7z
sudo apt-get install p7zip-full

# names
DEB=pandoc-1.19.1-1-amd64.deb
PKG=pandoc-1.19.1-osx.pkg
MSI=pandoc-1.19.1-windows.msi

# Linux
ar x $DEB data.tar.gz && mv data.tar.gz ${DEB%.*}.tar.gz

# osx
7z x $PKG -oosx
cat osx/pandoc.pkg/Payload | gunzip -dc |cpio -i
zip -r ${PKG%.*}.zip usr/

# Windows
7z x $MSI -o${MSI%.*}
zip -r ${MSI%.*}.zip ${MSI%.*}
# 7z x $MSI -owindows && cd windows && 7z a ../${MSI%.*}.zip && cd ..
