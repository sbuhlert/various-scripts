#!/bin/bash

SRC=/Users/steffenbuhlert/Documents/Notes
DEST=HiDrive:/users/sbuhlert/Notes
BWLIMIT="08:00,512 00:00,off"
MINAGE=15m
TRANSFERS=32

rclone sync $SRC $DEST --transfers $TRANSFERS --bwlimit "$BWLIMIT" --min-age $MINAGE

echo $(date -u)' | completed rclone sync on '$SRC

exit

