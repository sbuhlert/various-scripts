#!/bin/bash
#	Clone current running system in other volume
#	
#	Copy files, not raw volume data, so can omit user data
#	or redundant cache and log
#
#	Andrea Tassotti
#
#	Tested cloning 10.6 instance

# Ask for the administrator password upfront
sudo -v

#
PROG="macOSCloner"
SRC="/"
BCK_DST="/Volumes/SSD1000"	# "/Volumes/macOS10.6_A"

if [ -z "$BCK_DST" ]; then
    logger -t $PROG "Missing destination"
    echo "Missing destination" >&2
    exit 1
fi

if ! mount | grep -q "$BCK_DST"; then
    logger -t $PROG "Source '$BCK_DST' not writable - No such mounted volume"
    echo "Source '$BCK_DST' not writable - No such mounted volume" >&2
    exit 1
fi

if [ ! -r "$SRC" ]; then
    logger -t $PROG "Source '$SRC' not readable - Cannot start the sync process"
    echo "Source '$SRC' not readable - Cannot start the sync process" >&1
    exit 1
fi

if [ ! -w "$BCK_DST" ]; then
    logger -t $PROG "Destination '$DST' not writeable - Cannot start the sync process"
    echo "Destination '$DST' not writeable - Cannot start the sync process" >&2
    exit 1
fi


# Percorsi da svuotare
#Users/andrea/Library/Application Support/MobileSync/Backup
#Users/andrea/Library/Application Support/DigiArty/MacX YouTube Downloader/download-cache
#Users/andrea//Library/Application Support/LibreOffice/4/user/temp/

sudo diskutil enableOwnership $BCK_DST

cat >/tmp/lista.excl << EOT
.fseventsd
Applications/XAMPP
Users/Shared*
Users/$USER/Downloads*
Users/$USER/Documents*
Users/$USER/Movies*
Users/$USER/Music*
Users/$USER/Pictures*
Users/$USER/VirtualBox*
Users/$USER/Library/Mail
Users/$USER/Library/Logs
Users/$USER/Library/Caches
Users/$USER/Library/Application Support/MobileSync/Backup
.thumbnails
.Spotlight-V100/
.DS_Store
EOT

# Permission, ACL and extended attributes
sudo tar -cl --one-file-system --preserv  -X /tmp/lista.excl -f - "$SRC" | sudo tar -xvp  -C "$BCK_DST" -f -

# Clone Finder extended attributes -- OBSOLETED BY tar
#sudo xattr -wx com.apple.FinderInfo "$(xattr -px com.apple.FinderInfo /Volumes)" $BCK_DST/Volumes
#sudo chflags hidden $BCK_DST/Volumes

#sudo mkdir $BCK_DST/tmp
#sudo chown root:wheel $BCK_DST/tmp
#sudo chmod 1777 $BCK_DST/tmp

# Make the backup bootable
sudo bless -folder "$BCK_DST"/System/Library/CoreServices

# Update the backup's cache
sudo update_dyld_shared_cache -force -root "$BCK_DST"
