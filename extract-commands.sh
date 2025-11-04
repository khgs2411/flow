#!/bin/bash

# Extract all commands from framework/SLASH_COMMANDS.md to flow-plugin/commands/

INPUT_FILE="framework/SLASH_COMMANDS.md"
OUTPUT_DIR="flow-plugin/commands"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Extract command names
COMMANDS=$(grep "^## /" "$INPUT_FILE" | sed 's/^## //')

echo "Extracting 28 commands to $OUTPUT_DIR..."
echo ""

count=0
for cmd in $COMMANDS; do
    cmd_name="${cmd#/}"  # Remove leading slash
    output_file="$OUTPUT_DIR/${cmd_name}.md"

    # Extract content between COMMAND_START and COMMAND_END for this command
    # Use awk to find the section starting with the command header
    awk -v cmd="$cmd" '
        /^## \// { in_section = ($0 == "## " cmd) }
        in_section && /<!-- COMMAND_START -->/ { capture = 1; next }
        in_section && /<!-- COMMAND_END -->/ { capture = 0; in_section = 0 }
        capture { print }
    ' "$INPUT_FILE" > "$output_file"

    count=$((count + 1))
    echo "[$count/28] Extracted: $cmd_name.md"
done

echo ""
echo "✅ Extraction complete! Created $count command files in $OUTPUT_DIR/"
