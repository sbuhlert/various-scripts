#!/bin/zsh
rclone sync -P -L ~/Documents GDrive:/Sync --filter-from ~/Desktop/filter.txt

