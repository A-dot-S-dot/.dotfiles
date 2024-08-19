#!/bin/sh

if ! updates_arch=$(checkupdates | wc -l ); then
    updates_arch=0
fi

if ! updates_aur=$(trizen -Su --aur --quiet | wc -l); then
    updates_aur=0
fi

updates=$(("$updates_arch" + "$updates_aur"))

if [ $updates -gt 0 ]; then
    echo "$updates"
    echo "󰣇: $updates_arch  AUR: $updates_aur"
else
    echo "0"
    echo "󰣇: 0 AUR: 0"
fi
