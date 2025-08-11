#!/bin/sh
set -e

sudo apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub org.gnome.Weather -y
flatpak install flathub com.plexamp.Plexamp -y
