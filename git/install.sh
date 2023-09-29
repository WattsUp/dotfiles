#!/bin/sh
curl -L https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.3.2/gcm-linux_amd64.2.3.2.deb -o /var/tmp/gcm-linux.deb
sudo dpkg -i /var/tmp/gcm-linux.deb
