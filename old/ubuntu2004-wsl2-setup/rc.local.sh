#!/bin/sh -e

touch /etc/set-dns.$(date -Ins)
/usr/local/bin/set-dns

exit 0
