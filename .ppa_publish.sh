#!/bin/sh
openssl aes-256-cbc -K $encrypted_d53479e3bcc6_key -iv $encrypted_d53479e3bcc6_iv -in autopackage.gpg.enc -out autopackage.gpg -d
gpg --import autopackage.gpg

cd .. && dput ppa:raphink/augeas-dev *_source.changes
