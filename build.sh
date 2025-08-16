#!/bin/bash
set -e
# -*- mode: sh; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: et sts=4 sw=4
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root, exiting"
    exit -1
fi
export IMG_NAME="steamdeck-repair-${iso_version}.img"
echo "Clearing cache"
rm -rf /tmp/.steamos_work/
echo "Cache cleared, building SteamOS"
./mksteamos -v -w /tmp/.steamos_work/ -o output/ $(pwd)/releng/
tar -cjf ${IMG_NAME}.bz2 output/*
rm -rf output/
echo "Compiled image."
exit -1
