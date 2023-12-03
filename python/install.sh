#!/bin/sh
set -e

if ! sudo apt install python3.10 -y; then
	sudo apt install software-properties-common -y
	sudo add-apt-repository ppa:deadsnakes/ppa
fi

sudo apt install python3.10 python3.10-venv python3.10-dev python3-pip -y

python3 -m pip install pre-commit
