#!/bin/zsh

# Check if a directory is provided as an argument, default to the current directory
directory=${1:-.}

# Use find to locate all files in the specified directory and its subdirectories
# -type f: Only find regular files
# -exec du -h {} +: Calculate the disk usage of each file and display it in human-readable format
# sort -rh: Sort the output in reverse order (largest to smallest) by size
find "$directory" -type f -exec du -h {} + | sort -rh
