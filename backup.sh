#/bin/bash
now=$(date +"%m_%d_%Y")
backupname=/WD/Backup/backup_$now
rclone mkdir WD:$backupname
rclone sync -P /Users/steffenbuhlert/Documents/privat WD:$backupname --exclude ".DS_Store"
echo "Backup privat finished at" $backupname
rclone sync -P /Users/steffenbuhlert/Documents/current WD:$backupname --exclude ".DS_Store"
echo "Backup current finished at" $backupname
