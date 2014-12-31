#!/usr/bin/env bash

#sudo apt-get update 2> /dev/null

sudo apt-get install --fix-missing -y language-pack-en
update-locale LANG=en_US.UTF-8

sudo apt-get --fix-missing -y update
sudo apt-get --fix-missing -y dist-upgrade

wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | sudo apt-key add -

echo "deb http://ubuntu.bigbluebutton.org/trusty-090/ bigbluebutton-trusty main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list

sudo apt-get --fix-missing -y update

sudo apt-get install --fix-missing -y build-essential git-core checkinstall yasm texi2html libvorbis-dev libx11-dev libvpx-dev libxfixes-dev zlib1g-dev pkg-config netcat

FFMPEG_VERSION=2.3.3

cd /usr/local/src
if [ ! -d "/usr/local/src/ffmpeg-${FFMPEG_VERSION}" ]; then
  sudo wget "http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2"
  sudo tar -xjf "ffmpeg-${FFMPEG_VERSION}.tar.bz2"
fi

cd "ffmpeg-${FFMPEG_VERSION}"
sudo ./configure --enable-version3 --enable-postproc --enable-libvorbis --enable-libvpx
sudo make
sudo checkinstall --pkgname=ffmpeg --pkgversion="5:${FFMPEG_VERSION}" --backup=no --deldoc=yes --default

sudo apt-get update
sudo apt-get install --fix-missing -y -q --force-yes bigbluebutton
sudo apt-get install --fix-missing -y -q --force-yes bigbluebutton

current_ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

sudo apt-get install --fix-missing -y -q bbb-demo

sudo bbb-conf --setip ${current_ip}

sudo rm /etc/nginx/sites-enabled/default
sudo /etc/init.d/nginx restart

sudo bbb-conf --clean
sudo bbb-conf --check
