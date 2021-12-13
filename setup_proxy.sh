#!/usr/bin/env bash
# ==============================
# Setup the proxy server
# Date:         26.08.2019
# Version:      1.0
# Author:       damiancypcar@gmail.com
# inspired by Michael Wahler work
# ==============================

PROXYURL=<proxy address>
BAKDIR="~/.proxy_bak"

echo This script sets up Ubuntu/Debian installation to the ABB environment.
echo Backups of configuration files will be made to ~/.proxy_bak/
echo

if [ "$EUID" -ne 0 ]
	then echo "Some actions require super user privileges, so please run as root. Exiting..."
	exit 1
fi

read -p "Press any key to continue or Ctrl-C to exit..." -n1 -s

echo -e "\n"
echo "Starting..."

# create backup directory, -p eliminates warning if directory exists
mkdir -p $BAKDIR

echo "Adding proxy to apt"
touch /etc/apt/apt.conf
cp -v /etc/apt/apt.conf $BAKDIR/apt.conf
echo "Acquire::http::Proxy \"$PROXYURL\";" >> /etc/apt/apt.conf
echo "Acquire::https::Proxy \"$PROXYURL\";" >> /etc/apt/apt.conf

echo 'Adding script to set proxy to /etc/profile.d'
PSCRIPT=/etc/profile.d/proxies.sh
touch $PSCRIPT
chmod +x $PSCRIPT
echo '#!/bin/bash' > $PSCRIPT
echo export http_proxy="$PROXYURL" >> $PSCRIPT
echo export https_proxy="$PROXYURL" >> $PSCRIPT
echo export no_proxy="localhost,127.0.0.1" >> $PSCRIPT

echo "Updating the package directory"
apt-get update

# echo "Installing bonjour for broadcasting this device's hostname"
# apt-get install libnss-mdns libnss-winbind winbind
