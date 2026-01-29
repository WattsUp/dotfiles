#!/bin/sh
set -e

sudo apt-get install python3.12-venv -y
curl -fsSL -o /tmp/get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
python3 /tmp/get-platformio.py

sudo ln -fs $HOME/.platformio/penv/bin/platformio /usr/local/bin/platformio
