#!/bin/sh
sudo apt-get install -y devscripts gnupg dput dh-autoreconf

openssl aes-256-cbc -K $encrypted_d53479e3bcc6_key -iv $encrypted_d53479e3bcc6_iv -in autopackage.gpg.enc -out autopackage.gpg -d
gpg --import autopackage.gpg

export NAME="Travis Autopackage"
export EMAIL="raphink+travisautopackage@gmail.com"
echo -e "\n" | dch -v 1.4.0+$(date +'%Y%m%d')+${TRAVIS_BUILD_NUMBER} -D trusty "Autobuild for ${TRAVIS_COMMIT}"

debuild -S -sa

cd .. && dput ppa:raphink/augeas-dev *_source.changes
