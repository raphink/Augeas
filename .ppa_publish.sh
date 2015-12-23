#!/bin/sh
openssl aes-256-cbc -K $encrypted_d53479e3bcc6_key -iv $encrypted_d53479e3bcc6_iv -in autopackage.gpg.enc -out autopackage.gpg -d
gpg --import autopackage.gpg

dget https://launchpad.net/~raphink/+archive/ubuntu/augeas/+files/augeas_1.4.0-0ubuntu1~augeas2.dsc
dpkg-source -x augeas_1.4.0-0ubuntu1~augeas2.dsc
mv augeas-1.4.0/debian .
rm -rf augeas-1.4.0

export NAME="Travis Autopackage"
export EMAIL="raphink+travisautopackage@gmail.com"
echo -e "\n" | dch -v 1.4.0+$(date --iso)+${TRAVIS_BUILD_NUMBER} -D trusty "Autobuild for ${TRAVIS_COMMIT}"

debuild -S -sa

cd .. && dput ppa:raphink/augeas-dev *_source.changes
