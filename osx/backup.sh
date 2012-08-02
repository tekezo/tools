#!/bin/sh

output_error() {
    echo "\033[0;37m""\033[1;41m"
    echo "================================================================================"
    echo "ERROR: $1"
    echo "================================================================================"
    echo "\033[0m"
}

echo "Checking virtual machine is not running..."
if [ `/Applications/VirtualBox.app/Contents/MacOS/VBoxManage list runningvms | wc -l` -ne 0 ]; then
    output_error "Virtual machine is running. Please stop it."
    exit 1
fi

#------------------------------------------------------------
destdir=/Volumes/Data/Backups/`hostname -s`
echo "Checking destdir..."

if [ ! -d $destdir ]; then
    output_error "Destdir is not exists. Please mkdir $destdir"
    exit 1
fi

#------------------------------------------------------------
echo "Checking privilege..."

if [ `whoami` != "root" ]; then
    output_error "Please run this command by root (sudo)."
    exit 1
fi

#------------------------------------------------------------
echo "Backup /Users"
rsync -a --delete /Users $destdir

echo "Backup /private"
rsync -a --delete /private --exclude /private/var/vm $destdir

echo "Backup /Applications"
rsync -a --delete /Applications $destdir
