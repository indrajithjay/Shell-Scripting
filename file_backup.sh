#!/bin/bash

# Set source and backup directories
source_back="/usr/user/recon" #Replace with the source directory
dest_back="admin@10.0.0.16:/usr/administrator/backuptest" #Replace with destination user@server:destination directory

# Get size of source directory before compression
ini_size=$(du -sh "$source_back" | awk '{print $1}')

# Find and compress files older than 10 days
find "$source_back" -type f -mtime +10 -exec gzip {} \;

# Transfer compressed files to backup server using SSH
rsync -avz --progress --remove-source-files -e "ssh -i /path/to/your/private_key" "$source_back"/*.gz "$dest-back"

# Check if transfer was successful
if [ $? -eq 0 ]; then
    echo "Files transferred successfully. Deleting original files..."
    
    # Delete original files
    find "$source_back" -type f -name "*.gz" -exec rm {} \;

    # Get size of source directory after deletion
    final_size=$(du -sh "$source_back" | awk '{print $1}')

    # Calculate freed up space
    freed_space=$((ini_size - final_size))

    echo "Original files deleted. $freed_space KB of space freed up."
else
    echo "Error: Files transfer failed. Backup not completed."
fi
