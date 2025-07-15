#!/bin/bash
# Script to fix common linting issues

echo "Fixing lint issues..."

# Fix trailing spaces in all YAML files
echo "Removing trailing spaces..."
find . -name "*.yml" -o -name "*.yaml" | grep -v -E "(tmp/|\.cache/|\.git/)" | while read -r file; do
    sed -i 's/[[:space:]]*$//' "$file"
done

# Add newline at end of files if missing
echo "Adding missing newlines at end of files..."
find . -name "*.yml" -o -name "*.yaml" | grep -v -E "(tmp/|\.cache/|\.git/)" | while read -r file; do
    if [ -n "$(tail -c 1 "$file")" ]; then
        echo >> "$file"
    fi
done

# Fix truthy values (yes -> true, no -> false)
echo "Fixing truthy values..."
find . -name "*.yml" -o -name "*.yaml" | grep -v -E "(tmp/|\.cache/|\.git/)" | while read -r file; do
    sed -i 's/gather_facts: yes/gather_facts: true/g' "$file"
    sed -i 's/gather_facts: no/gather_facts: false/g' "$file"
    sed -i 's/validate_certs: yes/validate_certs: true/g' "$file"
    sed -i 's/validate_certs: no/validate_certs: false/g' "$file"
    sed -i 's/return_content: yes/return_content: true/g' "$file"
    sed -i 's/return_content: no/return_content: false/g' "$file"
done

# Fix comment spacing
echo "Fixing comment spacing..."
find . -name "*.yml" -o -name "*.yaml" | grep -v -E "(tmp/|\.cache/|\.git/)" | while read -r file; do
    # Fix missing space after # in comments
    sed -i 's/#\([^ #]\)/# \1/g' "$file"
    # Fix double spaces in comments
    sed -i 's/#  /# /g' "$file"
done

echo "Lint fixes applied!"