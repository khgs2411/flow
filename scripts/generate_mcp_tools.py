#!/usr/bin/env python3
"""
Generate MCP tool functions from parsed slash command metadata.

This script generates Python function code for all MCP tools based on
the metadata in SLASH_COMMANDS.md.
"""

import sys
from pathlib import Path

# Add parent directory to path to import parse_slash_commands
sys.path.insert(0, str(Path(__file__).parent))

from parse_slash_commands import extract_all_commands


def generate_function_signature(cmd: dict) -> str:
    """Generate Python function signature from command metadata"""
    func_name = cmd['function_name']
    params = cmd.get('parameters', [])

    # Build parameter list
    param_parts = []
    for param in params:
        param_name = param['name']
        param_type = param.get('type', 'str')
        required = param.get('required', True)
        default = param.get('default', '')

        if required:
            param_parts.append(f"{param_name}: {param_type}")
        else:
            # Optional parameter with default
            if param_type == 'str':
                param_parts.append(f'{param_name}: {param_type} = "{default}"')
            else:
                param_parts.append(f"{param_name}: {param_type} = {default}")

    param_str = ", ".join(param_parts) if param_parts else ""

    returns = cmd.get('returns', 'dict[str, Any]')

    return f"def {func_name}({param_str}) -> {returns}:"


def generate_docstring(cmd: dict) -> str:
    """Generate function docstring from command metadata"""
    description = cmd.get('description', 'No description available')
    params = cmd.get('parameters', [])

    lines = [
        '    """',
        f'    {description}',
    ]

    if params:
        lines.append('')
        lines.append('    Args:')
        for param in params:
            param_name = param['name']
            param_desc = param.get('description', '')
            lines.append(f'        {param_name}: {param_desc}')

    lines.append('')
    lines.append('    Returns:')
    lines.append('        Status response with operation result')
    lines.append('    """')

    return '\n'.join(lines)


def generate_function_body(cmd: dict) -> str:
    """Generate function body (stub implementation)"""
    func_name = cmd['function_name']
    command_name = cmd['command_name']
    category = cmd.get('category', 'unknown')
    plan_ops = cmd.get('plan_operations', [])

    lines = []
    lines.append('    try:')

    # Add plan file finding if needed
    if 'READ' in plan_ops or 'WRITE' in plan_ops:
        lines.append('        # Find and read PLAN.md')
        lines.append('        plan_path = find_plan_file()')
        if 'READ' in plan_ops:
            lines.append('        plan_content = read_plan(plan_path)')

    lines.append('')
    lines.append(f'        # TODO: Implement {command_name} logic')
    lines.append(f'        # Category: {category}')
    lines.append(f'        # Operations: {", ".join(plan_ops) if plan_ops else "None"}')
    lines.append('')

    # Return stub response
    lines.append('        output = f"""# {command_name} Result')
    lines.append('')
    lines.append('        TODO: Implement command logic')
    lines.append('        """')
    lines.append('')
    lines.append('        return format_success_response(')
    lines.append(f'            "{command_name}",')
    lines.append(f'            "{func_name} executed",')
    lines.append('            output,')
    lines.append(f'            "Next steps for {command_name}"')
    lines.append('        )')
    lines.append('')
    lines.append('    except PlanNotFoundError:')
    lines.append('        return format_error_response(')
    lines.append(f'            "{command_name}",')
    lines.append('            "PLAN.md not found",')
    lines.append('            "Run flow_init() first, then flow_blueprint() to create a plan"')
    lines.append('        )')
    lines.append('    except Exception as e:')
    lines.append('        return format_error_response(')
    lines.append(f'            "{command_name}",')
    lines.append(f'            "Failed to execute {command_name}",')
    lines.append('            str(e)')
    lines.append('        )')

    return '\n'.join(lines)


def generate_mcp_tool(cmd: dict) -> str:
    """Generate complete MCP tool function"""
    signature = generate_function_signature(cmd)
    docstring = generate_docstring(cmd)
    body = generate_function_body(cmd)

    return f"""
@mcp.tool()
{signature}
{docstring}
{body}
"""


def generate_mcp_server(commands: list[dict], output_file: Path) -> None:
    """Generate complete mcp_server.py file"""

    # Header
    header = '''#!/usr/bin/env python3
"""
MCP Server for Flow Framework

Model Context Protocol server that provides Flow development methodology tools.

AUTO-GENERATED - DO NOT EDIT DIRECTLY
Generated from framework/SLASH_COMMANDS.md metadata
"""

import os
import shutil
from pathlib import Path
from typing import Any, cast
from fastmcp import FastMCP

from flow_core import (
    find_plan_file,
    read_plan,
    write_plan,
    extract_dashboard,
    update_dashboard_timestamp,
    find_current_phase,
    find_current_task,
    find_current_iteration,
    format_success_response,
    format_error_response,
    PlanNotFoundError,
    FlowError,
)

# ============== INITIALIZATION ==============

mcp = FastMCP("Flow")

# ============== SPECIAL MCP TOOL: flow_init ==============

@mcp.tool()
def flow_init(create_slash_commands: bool = True) -> dict[str, Any]:
    """
    Initialize Flow framework in current project.

    Creates .flow/ directory with framework documentation and optionally
    .claude/commands/ with slash commands for Claude Code users.

    Args:
        create_slash_commands: Create .claude/commands/ slash commands (default: True).
                              Set to False if not using Claude Code.

    Returns:
        Initialization status and next steps
    """
    try:
        # Get framework files from package installation
        package_dir = Path(__file__).parent
        framework_source = package_dir / "framework"

        # Verify framework files exist
        if not framework_source.exists():
            return format_error_response(
                "flow-init",
                "Framework files not found in package",
                f"Expected framework files at: {framework_source}"
            )

        # Create .flow/ directory
        flow_dir = Path(".flow")
        flow_dir.mkdir(exist_ok=True)

        # Copy framework documentation
        docs_copied = []
        for doc in ["DEVELOPMENT_FRAMEWORK.md", "EXAMPLE_PLAN.md"]:
            src = framework_source / doc
            dest = flow_dir / doc
            if src.exists():
                shutil.copy(src, dest)
                docs_copied.append(doc)

        # Optionally create slash commands
        commands_created = 0
        if create_slash_commands:
            commands_dir = Path(".claude/commands")
            commands_dir.mkdir(parents=True, exist_ok=True)

            # Extract commands from SLASH_COMMANDS.md
            slash_commands_file = framework_source / "SLASH_COMMANDS.md"
            if slash_commands_file.exists():
                commands_created = extract_slash_commands(
                    slash_commands_file,
                    commands_dir
                )

        # Generate output report
        output = f"""# Flow Framework Initialized ✅

## What was created:

### .flow/ Directory
"""
        for doc in docs_copied:
            output += f"- ✅ {doc}\\n"

        if create_slash_commands:
            output += f"\\n### .claude/commands/ Directory\\n"
            output += f"- ✅ {commands_created} slash commands extracted\\n"
        else:
            output += "\\n### Slash Commands\\n"
            output += "- ⏭️  Skipped (create_slash_commands=False)\\n"

        output += """

## Next Steps

1. **Create your first plan**: Run `flow_blueprint()` to create .flow/PLAN.md
2. **Or migrate existing docs**: Run `flow_migrate()` if you have existing planning docs

## Available Tools

Run `flow_status()` anytime to see where you are in the development process.
"""

        return format_success_response(
            "flow-init",
            f"Flow framework initialized (.flow/ + {commands_created if create_slash_commands else 0} commands)",
            output,
            "Run flow_blueprint() to create your first development plan"
        )

    except Exception as e:
        return format_error_response(
            "flow-init",
            "Failed to initialize Flow framework",
            str(e)
        )


def extract_slash_commands(slash_commands_file: Path, output_dir: Path) -> int:
    """
    Extract slash commands from SLASH_COMMANDS.md to .claude/commands/

    Args:
        slash_commands_file: Path to SLASH_COMMANDS.md
        output_dir: Directory to write command files

    Returns:
        Number of commands extracted
    """
    content = slash_commands_file.read_text()

    # Find all command sections (## /flow-...)
    import re
    command_pattern = r"## (/flow-[\\w-]+)\\s*\\n.*?\\*\\*File\\*\\*: `([\\w-]+\\.md)`\\s*\\n```markdown\\n(.*?)```"
    matches = re.findall(command_pattern, content, re.DOTALL)

    count = 0
    for command_name, filename, command_content in matches:
        command_file = output_dir / filename
        command_file.write_text(command_content)
        count += 1

    return count


# ============== AUTO-GENERATED MCP TOOLS ==============
'''

    # Generate all tools
    tools_code = []
    for cmd in commands:
        tool_code = generate_mcp_tool(cmd)
        tools_code.append(tool_code)

    # Footer
    footer = '''

# ============== ENTRY POINT ==============

def main():
    """Entry point for the MCP server"""
    mcp.run()


if __name__ == "__main__":
    main()
'''

    # Write to file
    full_code = header + '\n'.join(tools_code) + footer
    output_file.write_text(full_code)

    print(f"✅ Generated {output_file} with {len(commands)} MCP tools")


def main():
    """Main entry point"""
    # Find SLASH_COMMANDS.md
    framework_dir = Path(__file__).parent.parent / "framework"
    slash_commands_file = framework_dir / "SLASH_COMMANDS.md"

    if not slash_commands_file.exists():
        print(f"❌ Could not find {slash_commands_file}")
        return 1

    # Sync framework files to MCP package (always get latest versions)
    print("📋 Syncing framework files to MCP package...")
    mcp_framework_dir = Path(__file__).parent.parent / "mcp-server-flow" / "framework"
    mcp_framework_dir.mkdir(exist_ok=True)

    import shutil
    for framework_file in ["DEVELOPMENT_FRAMEWORK.md", "EXAMPLE_PLAN.md", "SLASH_COMMANDS.md"]:
        src = framework_dir / framework_file
        dest = mcp_framework_dir / framework_file
        if src.exists():
            shutil.copy(src, dest)
            print(f"   ✅ Synced {framework_file}")
        else:
            print(f"   ⚠️  Missing {framework_file}")

    # Extract commands
    print(f"\n📖 Parsing {slash_commands_file}...")
    commands = extract_all_commands(slash_commands_file)

    print(f"✅ Found {len(commands)} commands with metadata")

    # Generate MCP server
    output_file = Path(__file__).parent.parent / "mcp-server-flow" / "mcp_server.py"
    print(f"\n🔨 Generating {output_file}...")

    generate_mcp_server(commands, output_file)

    print(f"\n✨ Done! MCP server generated successfully")
    print(f"   Location: {output_file}")
    print(f"   Tools: {len(commands) + 1} (28 commands + flow_init)")

    return 0


if __name__ == "__main__":
    exit(main())
