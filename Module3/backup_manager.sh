#!/bin/bash


dir_path="$1"
backup_path="$2"
file_ext="$3"

# Check if arguments are provided
if [[ -z "$dir_path" || -z "$backup_path" || -z "$file_ext" ]]; then
    echo "Usage: $0 <source_dir> <backup_dir> <file_extension>"
    exit 1
fi

# Change to source directory
cd "$dir_path" || { echo "Cannot access source directory"; exit 1; }


files=(*."$file_ext")

# Check if any files found
if [[ ${#files[@]} -eq 0 ]]; then
    echo "No files with extension .$file_ext found in $dir_path"
    exit 1
fi

# Create backup directory if it does not exist
if [[ ! -d "$backup_path" ]]; then
    mkdir -p "$backup_path" || { echo "Cannot create backup directory"; exit 1; }
fi

# Initialize backup count and total size
export BACKUP_COUNT=0
total_size=0

# Print files and sizes before backup
echo "Files to be backed up:"
for file in "${files[@]}"; do
    size=$(stat -c %s "$file")
    echo "$file ($size bytes)"
done

# Backup files
for file in "${files[@]}"; do
    src_file="$dir_path/$file"
    dest_file="$backup_path/$file"

    # If file exists in backup, check timestamp
    if [[ -f "$dest_file" ]]; then
        src_time=$(stat -c %Y "$src_file")
        dest_time=$(stat -c %Y "$dest_file")
        if [[ "$src_time" -le "$dest_time" ]]; then
            continue
        fi
    fi

    # Copy file and update counters
    cp "$src_file" "$dest_file" && {
        BACKUP_COUNT=$((BACKUP_COUNT + 1))
        total_size=$((total_size + $(stat -c %s "$src_file")))
    }
done

# Generate simplified report
report_file="$backup_path/backup_report.log"
{
    echo "Total files backed up: $BACKUP_COUNT"
    echo "Total size of files backed up: $total_size bytes"
    echo "Backup directory: $backup_path"
} > "$report_file"

echo "Backup completed. Report saved to $report_file"
