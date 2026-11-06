#!/bin/bash

mkdir -v /home/builduser/repo
cp -vr . /home/builduser/repo
chown -vR builduser:builduser /home/builduser/repo
runuser -l -w PKGDEST,PACKAGER builduser <<EOF
cd repo
gpg --import keys/pgp/*.asc
makepkg --clean
ls -alF
EOF
pacman --noconfirm -U /home/builduser/packages/*
pacman -Qi bubblewrap-restricted
