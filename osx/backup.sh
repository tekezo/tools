#!/bin/sh

novirtualmachine=no
if [ "$1" == "novirtualmachine" ]; then
    echo "novirtualmachine=yes"
    novirtualmachine=yes
fi

output_error() {
    echo "\033[0;37;41m"
    echo "================================================================================"
    echo "ERROR: $1"
    echo "================================================================================"
    echo "\033[0m"
}

if [ $novirtualmachine == "no" ]; then
    echo "Checking virtual machine is not running..."
    if [ `/Applications/VirtualBox.app/Contents/MacOS/VBoxManage list runningvms | wc -l` -ne 0 ]; then
        output_error "Virtual machine is running. Please stop it."
        exit 1
    fi
fi

#------------------------------------------------------------
destdir=mini2016.local:/Backups/`hostname -s`

whoami=`whoami`

exclude=""
exclude="$exclude --exclude='/$whoami/.Trash/'"
exclude="$exclude --exclude='/$whoami/.cocoapods/'"
exclude="$exclude --exclude='/$whoami/Dropbox/'"
exclude="$exclude --exclude='/$whoami/Library/Android/sdk/'"
exclude="$exclude --exclude='/$whoami/Library/Application Support/MobileSync/Backup/'"
exclude="$exclude --exclude='/$whoami/Library/Caches/'"
exclude="$exclude --exclude='/$whoami/Library/Containers/'"
exclude="$exclude --exclude='/$whoami/Library/Developer/CoreSimulator/Devices/'"
exclude="$exclude --exclude='/$whoami/Library/Developer/Xcode/DerivedData/'"
exclude="$exclude --exclude='/$whoami/Library/Developer/Xcode/iOS DeviceSupport/'"
exclude="$exclude --exclude='/$whoami/Library/Logs/'"
exclude="$exclude --exclude='/$whoami/Library/Saved Application State/'"

if [ $novirtualmachine == "yes" ]; then
    exclude="$exclude --exclude '/$whoami/VirtualBox VMs/'"
fi

echo "Backup /Users"
sh -c "rsync -vv -ax --delete $exclude /Users/$whoami '$destdir/Users'"
