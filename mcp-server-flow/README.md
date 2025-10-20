# MCP Server for Flow Framework

A Model Context Protocol (MCP) server that brings the Flow development methodology to any Claude session.

## What is Flow?

Flow is a spec-driven iterative development methodology combining Domain-Driven Design principles with Agile philosophy. It helps developers build complex features with minimal refactoring through structured planning and iterative implementation.

## Features

- **`flow_init()`** - Initialize Flow framework in your project
- **`flow_status()`** - View current development position
- More tools coming soon...

## Installation

Install via uvx (no setup needed):

```bash
uvx mcp-server-flow
```

## Configuration

Add to your Claude Desktop config file:

**Location:**
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%/Claude/claude_desktop_config.json`

**Config:**
```json
{
  "mcpServers": {
    "flow": {
      "command": "uvx",
      "args": ["mcp-server-flow"]
    }
  }
}
```

## Usage

After configuration, restart Claude Desktop and try:

1. **Initialize Flow in your project:**
   ```
   "Initialize Flow framework in this project"
   ```
   This creates `.flow/` directory with framework docs and optionally `.claude/commands/` with slash commands.

2. **Check your status:**
   ```
   "Show me my Flow development status"
   ```

## Available Tools

- **`flow_init(create_slash_commands=True)`** - Initialize Flow framework
  - Creates `.flow/` directory with framework documentation
  - Optionally creates `.claude/commands/` slash commands (for Claude Code users)

- **`flow_status()`** - Show current development position
  - Returns dashboard with active phase, task, and iteration
  - Suggests next steps

## Development

```bash
# Clone the repo
git clone https://github.com/khgs2411/flow
cd flow/mcp-server-flow

# Install dependencies
uv add fastmcp

# Run locally
uv run mcp_server.py
```

## Roadmap

This is an early release with basic functionality. Future updates will add:

- All 28 Flow commands as MCP tools
- Automated generation from slash command definitions
- Full integration with Flow methodology

## License

MIT

## Links

- **Flow Framework**: https://github.com/khgs2411/flow
- **Documentation**: See `.flow/DEVELOPMENT_FRAMEWORK.md` after running `flow_init()`
- **Example Plan**: See `.flow/EXAMPLE_PLAN.md` for reference implementation
