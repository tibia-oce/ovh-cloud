#!/bin/bash

# Define the source directory
SRC_DIR="src/ansible"

# Check if the source directory exists
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Directory $SRC_DIR does not exist."
    exit 1
fi

# Create output file
OUTPUT_FILE="ansible_files.txt"
> "$OUTPUT_FILE"  # Clear file if it exists

# Find all files in src/ansible directory, including inventory directory
# but excluding .gitignore, hosts.yml, readme.md, and .pub files
find "$SRC_DIR" -type f | grep -v -i "\.gitignore$\|hosts\.yml$\|readme\.md$\|\.pub$" | sort | while read -r file; do
    # Add file path as header
    echo "=== File: $file ===" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # Add file contents
    cat "$file" >> "$OUTPUT_FILE"
    
    # Add separator between files
    echo -e "\n\n" >> "$OUTPUT_FILE"
    
    echo "Added $file to $OUTPUT_FILE"
done

echo "Complete! All files have been exported to $OUTPUT_FILE"