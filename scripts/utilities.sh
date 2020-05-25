#!/bin/bash -eux

echo "==> Install various general utilities..."
apt-get -y install mc fonts-dejavu-core python3-pip default-jre
pip3 install --upgrade pip --quiet

#Update git to latest stable version and install gitflow module
add-apt-repository -y ppa:git-core/ppa
apt-get -y update
apt-get -y install git git-flow
