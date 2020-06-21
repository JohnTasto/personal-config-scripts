#!/bin/bash

[[ ! -d /run/resolvconf/ ]] && mkdir /run/resolvconf

exec 3>&1
exec > /run/resolvconf/resolv.conf
echo "nameserver 8.8.8.8"
exec 1>&3
