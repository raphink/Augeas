#!/bin/sh
sudo apt-get install -y devscripts gnupg dput dh-autoreconf

export NAME="Travis Autopackage"
export EMAIL="raphink+travisautopackage@gmail.com"
PKG_VERSION="1.4.0+$(date +'%Y%m%d')+${TRAVIS_BUILD_NUMBER}"
tar --exclude debian --exclude-vcs -czf  "../augeas_${PKG_VERSION}.orig.tar.gz" .

echo -e "\n" | dch -v "${PKG_VERSION}" -D trusty "Autobuild for ${TRAVIS_COMMIT}"

debuild -S -sa
