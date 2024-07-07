#!/bin/sh
set -e

sudo apt install curl -y
cd /var/tmp
curl -L https://dl.google.com/go/go1.12.1.linux-amd64.tar.gz -o go.tar.gz
sudo tar -xvf go.tar.gz -C /usr/local
