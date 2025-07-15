#!/usr/bin/env python3
"""Fix long lines in YAML files by intelligently breaking them."""

import os
import re
import sys

def fix_long_lines_in_file(filepath):
    """Fix long lines in a single file."""
    if not os.path.exists(filepath):
        return
    
    with open(filepath, 'r') as f:
        lines = f.readlines()
    
    modified = False
    new_lines = []
    
    for line in lines:
        # Skip comment lines and empty lines
        if line.strip().startswith('#') or not line.strip():
            new_lines.append(line)
            continue
            
        # Check if line is too long
        if len(line.rstrip()) > 120:
            # Handle lines with long debug messages
            if 'msg:' in line and '>' not in line:
                # Convert to multiline YAML string
                indent = len(line) - len(line.lstrip())
                new_lines.append(line[:line.index('msg:')] + 'msg: >\n')
                # Wrap the message content
                msg_content = line[line.index('msg:') + 4:].strip()
                words = msg_content.split()
                current_line = ' ' * (indent + 2)
                for word in words:
                    if len(current_line) + len(word) + 1 > 118:
                        new_lines.append(current_line.rstrip() + '\n')
                        current_line = ' ' * (indent + 2) + word + ' '
                    else:
                        current_line += word + ' '
                if current_line.strip():
                    new_lines.append(current_line.rstrip() + '\n')
                modified = True
            elif 'when:' in line and 'and' in line:
                # Split long when conditions
                indent = len(line) - len(line.lstrip())
                parts = line.split(' and ')
                new_lines.append(parts[0] + '\n')
                for part in parts[1:]:
                    new_lines.append(' ' * (indent + 2) + 'and ' + part.strip() + '\n')
                modified = True
            else:
                # Keep the line as is if we can't safely split it
                new_lines.append(line)
        else:
            new_lines.append(line)
    
    if modified:
        with open(filepath, 'w') as f:
            f.writelines(new_lines)
        print(f"Fixed long lines in: {filepath}")

def main():
    """Main function."""
    # Find all YAML files
    for root, dirs, files in os.walk('.'):
        # Skip certain directories
        if any(skip in root for skip in ['.git', 'tmp', '.cache']):
            continue
            
        for file in files:
            if file.endswith(('.yml', '.yaml')):
                filepath = os.path.join(root, file)
                fix_long_lines_in_file(filepath)

if __name__ == "__main__":
    main()