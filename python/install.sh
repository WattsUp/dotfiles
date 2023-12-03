#!/bin/sh
set -e

if ! sudo apt install python3.10 python3.10-venv python3.10-dev -y; then
	sudo apt install software-properties-common -y
	sudo add-apt-repository ppa:deadsnakes/ppa
	sudo apt install python3.10 python3.10-venv python3.10-dev -y
fi
