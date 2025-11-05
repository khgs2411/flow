---
description: Initialize Flow framework files in your project
---

You are executing the `/flow-init` command from the Flow framework.

**Purpose**: Download and install Flow framework reference files into your project.

**🟢 NO FRAMEWORK READING REQUIRED - This is the initialization command**

This command sets up the `.flow/framework/` directory with reference documentation that other Flow commands depend on.

**Instructions**:

1. **Check if framework already exists**:
   ```bash
   if [ -d ".flow/framework" ]; then
     echo "✅ Framework files already exist in .flow/framework/"
     echo ""
     echo "Contents:"
     ls -la .flow/framework/
     echo ""
     echo "If you want to update these files, delete .flow/framework/ and run /flow-init again."
     exit 0
   fi
   ```

2. **Ask user for permission**:
   ```
   📥 Flow Framework Installation

   This command will download framework reference files to .flow/framework/:
   - DEVELOPMENT_FRAMEWORK.md (methodology guide)
   - examples/ (template files for AI learning)

   These files are used by Flow commands for context and patterns.

   Download from: https://github.com/khgs2411/flow/tree/master/framework
   Size: ~100KB

   Proceed with download? (y/n)
   ```

3. **If user approves, download framework files**:

   Use the Bash tool to execute these commands:

   ```bash
   # Create directory structure
   mkdir -p .flow/framework/examples

   # Download DEVELOPMENT_FRAMEWORK.md
   curl -o .flow/framework/DEVELOPMENT_FRAMEWORK.md \
     https://raw.githubusercontent.com/khgs2411/flow/master/framework/DEVELOPMENT_FRAMEWORK.md

   # Download example files
   curl -o .flow/framework/examples/DASHBOARD.md \
     https://raw.githubusercontent.com/khgs2411/flow/master/framework/examples/DASHBOARD.md

   curl -o .flow/framework/examples/PLAN.md \
     https://raw.githubusercontent.com/khgs2411/flow/master/framework/examples/PLAN.md

   # Download phase examples
   mkdir -p .flow/framework/examples/phase-1
   mkdir -p .flow/framework/examples/phase-2

   curl -o .flow/framework/examples/phase-1/task-1.md \
     https://raw.githubusercontent.com/khgs2411/flow/master/framework/examples/phase-1/task-1.md

   curl -o .flow/framework/examples/phase-2/task-3.md \
     https://raw.githubusercontent.com/khgs2411/flow/master/framework/examples/phase-2/task-3.md
   ```

4. **Verify downloads**:
   ```bash
   # Check if files were downloaded successfully
   if [ -f ".flow/framework/DEVELOPMENT_FRAMEWORK.md" ]; then
     echo "✅ Downloaded DEVELOPMENT_FRAMEWORK.md"
   else
     echo "❌ Failed to download DEVELOPMENT_FRAMEWORK.md"
     exit 1
   fi

   if [ -d ".flow/framework/examples" ]; then
     echo "✅ Downloaded examples directory"
   else
     echo "❌ Failed to download examples"
     exit 1
   fi
   ```

5. **Confirm to user**:
   ```
   ✅ Flow framework initialized successfully!

   📂 Created:
   - .flow/framework/DEVELOPMENT_FRAMEWORK.md (methodology guide)
   - .flow/framework/examples/ (reference templates)

   🎯 Next Steps:

   **For new projects**:
   - Run `/flow-blueprint "Your Project Description"` to create a new Flow project

   **For existing projects**:
   - Run `/flow-migrate` to convert existing documentation to Flow format

   **Check status anytime**:
   - Run `/flow-status` to see your current progress

   All Flow commands are now ready to use! 🚀
   ```

6. **Handle errors**:
   - If curl fails: "❌ Download failed. Check your internet connection or download manually from: https://github.com/khgs2411/flow/tree/master/framework"
   - If user declines: "⚠️ Framework installation cancelled. Run `/flow-init` again when ready."
   - If directory creation fails: "❌ Could not create .flow/framework/ directory. Check permissions."
