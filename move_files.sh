#!/bin/bash

# Initialize error counter
errors=0

# Find all files in subdirectories and force copy to current directory
find . -mindepth 2 -type f | while read -r file; do
    if ! cp -f "$file" .; then
        echo "Error copying: $file"
        ((errors++))
    fi
done

echo "Operation complete. Errors: $errors"