#!/bin/bash -eux

echo "==> Update package info and upgrade packages..."

apt-get update -y
apt-get upgrade -y
