#!/bin/bash
set -e

# RClone Config file
RCLONE_CONFIG=/home/linux/.config/rclone/rclone.conf; export RCLONE_CONFIG

# Local Drive - This must be a local mount point on your server that is used for the source of files
# WARNING: If you make this your rclone Google Drive mount, it will create a move loop
# and DELETE YOUR FILES!
# Make sure to set this to the local path you are moving from!!
LOCAL=/home/linux/local

# Exit if running
if [[ $(pidof -x "$(basename "$0")" -o %PPID) ]]; then
echo "Already running, exiting..."; exit 1; fi

# Is $LOCAL actually a local disk?
if /bin/findmnt $LOCAL -o FSTYPE -n | grep fuse; then
echo "FUSE file system found, exiting..."; exit 1; fi

# Rather than use excludes, I wanted to simplify and just have two move commands to move to Movies and TV Shows
# Adjust a few settings to stay within the Dropbox API limits

# Move to Movies Folder
/usr/bin/rclone move $LOCAL/Movies eplex:Movies --log-file /home/linux/rclone/logs/upload.log --delete-empty-src-dirs --fast-list --transfers 6 --stats-one-line -v --min-age 1h

# Move to TV Folder
/usr/bin/rclone move $LOCAL/TV eplex:TV --log-file /home/linux/logs/upload.log --delete-empty-src-dirs --fast-list --transfers 6 --stats-one-line -v --min-age 1h
