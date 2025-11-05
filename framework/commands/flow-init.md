---
description: Install/update complete Flow framework (commands, skills, framework files)
---

You are executing the `/flow-init` command from the Flow framework.

**Purpose**: Guide the user to download the Flow framework standalone installer.

**🟢 NO FRAMEWORK READING REQUIRED - This is the installation command**

**Instructions**:

1. **Check if Flow is already partially installed**:
   - Look for `.claude/commands/flow-*.md` files
   - If found: This is an UPDATE
   - If not found: This is a new INSTALL

2. **Present installation guide to the user**:

   Show this message:

   ```
   📥 Flow Framework Installation

   To install Flow framework, please run the standalone installer:

   **Step 1**: Download the installer
   ```bash
   curl -O https://raw.githubusercontent.com/khgs2411/flow/master/flow.sh
   ```

   **Step 2**: Run the installer
   ```bash
   bash flow.sh
   ```

   This will install:
   ✓ 29 slash commands → .claude/commands/
   ✓ 8 agent skills → .claude/skills/
   ✓ Framework docs → .flow/framework/
   ✓ Example files → .flow/framework/examples/

   Total size: ~550KB

   **Alternative**: If you prefer to update only (keeping your existing setup):
   ```bash
   bash flow.sh --force
   ```

   ---

   **After installation, restart Claude Code** and you'll have access to all Flow commands!

   **Next steps**:
   - New project: `/flow-blueprint "Your Project Description"`
   - Migrate existing docs: `/flow-migrate`
   - Check status: `/flow-status`

   **Documentation**: https://github.com/khgs2411/flow
   ```

3. **If user already has Flow installed** (found `.claude/commands/flow-*.md`):

   Show this message instead:

   ```
   🔄 Flow Framework Update

   You already have Flow installed. To update to the latest version:

   **Step 1**: Download the latest installer
   ```bash
   curl -O https://raw.githubusercontent.com/khgs2411/flow/master/flow.sh
   ```

   **Step 2**: Run with --force to overwrite existing files
   ```bash
   bash flow.sh --force
   ```

   This will update all commands, skills, and framework files to the latest version.

   **After update, restart Claude Code** to load the new commands!
   ```
