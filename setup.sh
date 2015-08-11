#!/bin/bash

echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null

# Common tools
sudo apt-get update
sudo apt-get install git curl wget -y

# Python
sudo apt-get install -y gcc-multilib g++-multilib libffi-dev libffi6 libffi6-dbg python-crypto python-mox3 python-pil python-ply libssl-dev zlib1g-dev libbz2-dev libexpat1-dev libbluetooth-dev libgdbm-dev dpkg-dev quilt autotools-dev libreadline-dev libtinfo-dev libncursesw5-dev tk-dev blt-dev libssl-dev zlib1g-dev libbz2-dev libexpat1-dev libbluetooth-dev libsqlite3-dev libgpm2 mime-support netbase net-tools bzip2 -y
wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz
tar xfz Python-2.7.9.tgz
cd Python-2.7.9/
./configure --prefix /usr/local/lib/python2.7.9 --enable-ipv6
make
sudo make install

# For pip
sudo curl -o /tmp/ez_setup.py https://bootstrap.pypa.io/ez_setup.py
sudo /usr/local/lib/python2.7.9/bin/python /tmp/ez_setup.py
sudo /usr/local/lib/python2.7.9/bin/easy_install-2.7 pip
sudo apt-get install build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev
sudo /usr/local/lib/python2.7.9/bin/easy_install-2.7 green let
sudo /usr/local/lib/python2.7.9/bin/easy_install-2.7 gevent

# AWS
sudo /usr/local/lib/python2.7.9/bin/pip install awsebcli
sudo /usr/local/lib/python2.7.9/bin/pip install --upgrade awsebcli

# Docker
wget -qO- https://get.docker.com/ | sh
sudo /usr/local/lib/python2.7.9/bin/pip install -U docker-compose
sudo /usr/local/lib/python2.7.9/bin/pip install --upgrade awsebcli

# For Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update
sudo apt-get install google-chrome-stable -y

# Path Setting
sudo ln -nfs /usr/local/lib/python2.7.9/bin/python /usr/bin/python
sudo ln -nfs /usr/local/lib/python2.7.9/bin/pip /usr/bin/pip
sudo ln -nfs /usr/local/lib/python2.7.9/bin/eb /usr/bin/eb