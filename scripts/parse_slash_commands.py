#!/usr/bin/env python3
"""
Parse SLASH_COMMANDS.md and extract MCP metadata for all commands.

This script reads framework/SLASH_COMMANDS.md and extracts the HTML comment
metadata blocks to generate MCP tool definitions.
"""

import re
import yaml
from pathlib import Path
from typing import Any


def parse_metadata_block(content: str) -> dict[str, Any] | None:
    """
    Extract MCP metadata from HTML comment block.

    Args:
        content: Content containing metadata block

    Returns:
        Parsed metadata dictionary or None if not found
    """
    # Find metadata block
    pattern = r"<!-- MCP_METADATA\n(.*?)\nMCP_METADATA_END -->"
    match = re.search(pattern, content, re.DOTALL)

    if not match:
        return None

    metadata_text = match.group(1)

    # Parse using PyYAML
    try:
        metadata = yaml.safe_load(metadata_text)
        return metadata
    except yaml.YAMLError as e:
        print(f"Error parsing metadata: {e}")
        return None


def extract_command_description(content: str) -> str:
    """
    Extract description from YAML frontmatter in command content.

    Args:
        content: Command markdown content

    Returns:
        Description string
    """
    # Find description in YAML frontmatter
    pattern = r"---\ndescription: (.+?)\n---"
    match = re.search(pattern, content, re.DOTALL)

    if match:
        return match.group(1).strip()

    return "No description available"


def extract_all_commands(slash_commands_file: Path) -> list[dict[str, Any]]:
    """
    Extract all commands with their metadata from SLASH_COMMANDS.md.

    Args:
        slash_commands_file: Path to SLASH_COMMANDS.md

    Returns:
        List of command metadata dictionaries
    """
    content = slash_commands_file.read_text()

    # Find all command sections (## /flow-...)
    command_pattern = r"## (/flow-[\w-]+)\s*\n(.*?)(?=\n## /flow-|\n## |\Z)"
    matches = re.findall(command_pattern, content, re.DOTALL)

    commands = []

    for command_name, command_content in matches:
        # Extract metadata
        metadata = parse_metadata_block(command_content)

        if not metadata:
            print(f"⚠️  No metadata found for {command_name}")
            continue

        # Extract description
        description = extract_command_description(command_content)

        # Combine
        command_data = {
            "command_name": command_name,
            "description": description,
            **metadata
        }

        commands.append(command_data)

    return commands


def main():
    """Main entry point"""
    # Find SLASH_COMMANDS.md
    framework_dir = Path(__file__).parent.parent / "framework"
    slash_commands_file = framework_dir / "SLASH_COMMANDS.md"

    if not slash_commands_file.exists():
        print(f"❌ Could not find {slash_commands_file}")
        return 1

    # Extract commands
    print(f"📖 Parsing {slash_commands_file}...")
    commands = extract_all_commands(slash_commands_file)

    print(f"\n✅ Found {len(commands)} commands with metadata:\n")

    for cmd in commands:
        params = cmd.get("parameters", [])
        params_count = len(params) if isinstance(params, list) else 0
        category = cmd.get("category", "unknown")
        print(f"  • {cmd['command_name']:<30} [{category:<20}] {params_count} params")

        # Debug: print parameters for task-add
        if 'task-add' in cmd['command_name']:
            print(f"     Parameters: {params}")

    print(f"\n📊 Summary:")
    print(f"   Total commands: {len(commands)}")

    # Group by category
    by_category = {}
    for cmd in commands:
        cat = cmd.get("category", "unknown")
        by_category[cat] = by_category.get(cat, 0) + 1

    print(f"\n   By category:")
    for cat, count in sorted(by_category.items()):
        print(f"     {cat}: {count}")

    return 0


if __name__ == "__main__":
    exit(main())
