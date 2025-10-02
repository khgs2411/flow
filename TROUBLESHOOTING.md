# Flow Framework - Troubleshooting Guide

> **Version**: 1.0.11
> **Last Updated**: 2025-10-02
> **Purpose**: Diagnose and fix common Flow framework issues

---

## Table of Contents

1. [Command Issues](#1-command-issues)
2. [PLAN.md Issues](#2-planmd-issues)
3. [Build & Installation Issues](#3-build--installation-issues)
4. [Reference Issues](#4-reference-issues)
5. [Performance Issues](#5-performance-issues)

---

## 1. Command Issues

### Problem: Command Not Found

**Symptom**: `/flow-blueprint` shows "command not found" or doesn't execute

**Diagnosis**:
```bash
# Check if commands directory exists
ls -la .claude/commands/

# Check if specific command exists
ls -la .claude/commands/flow-blueprint.md
```

**Solutions**:

**A. Commands not installed**
```bash
# Run flow.sh to install
./flow.sh

# Or force reinstall
./flow.sh --force
```

**B. Wrong directory**
```bash
# Commands only work in project root (where .claude/ exists)
cd /path/to/your/project
/flow-blueprint "test"
```

**C. Claude Code not running**
- Slash commands require Claude Code
- For other AI tools, read `framework/SLASH_COMMANDS.md` manually
- Follow instructions step-by-step

---

### Problem: Command Executes in Wrong Context

**Symptom**: `/flow-implement_start` says "no iteration marked 🎨 READY"

**Diagnosis**:
```bash
# Check PLAN.md status markers
grep "🎨\|🚧\|⏳" .flow/PLAN.md

# Verify current iteration status
/flow-status
```

**Solutions**:

**A. Brainstorming not complete**
```bash
# Complete brainstorming first
/flow-brainstorm_complete

# Then start implementation
/flow-implement_start
```

**B. Wrong iteration marked**
```bash
# Manually fix PLAN.md
# Change: ##### Iteration 1: Name ⏳
# To:     ##### Iteration 1: Name 🎨
```

**C. Multiple iterations marked 🚧**
```bash
# Fix: Only ONE iteration should be 🚧 at a time
# Mark others as ⏳ (pending) or ✅ (complete)
```

---

### Problem: Command Updates Wrong Section

**Symptom**: `/flow-brainstorm_resolve` adds resolution to wrong subject

**Diagnosis**:
```bash
# Check subject numbering in PLAN.md
grep "^[0-9]\. ⏳" .flow/PLAN.md
```

**Solutions**:

**A. Subject number mismatch**
```markdown
<!-- WRONG: Gaps in numbering -->
1. ✅ Subject One
3. ⏳ Subject Three (should be #2!)

<!-- CORRECT: Sequential numbering -->
1. ✅ Subject One
2. ⏳ Subject Two
```

**B. Specify subject explicitly**
```bash
# Instead of: /flow-brainstorm_resolve
# Use: /flow-brainstorm_resolve "Subject Name"
```

---

### Problem: Permission Denied

**Symptom**: "Permission denied" when running `/flow-*` commands

**Diagnosis**:
```bash
# Check .claude/commands/ permissions
ls -la .claude/commands/

# Check if files are readable
test -r .claude/commands/flow-blueprint.md && echo "Readable" || echo "Not readable"
```

**Solutions**:

**A. Fix permissions**
```bash
chmod +r .claude/commands/*.md
```

**B. Reinstall commands**
```bash
./flow.sh --force
```

**C. Check ownership**
```bash
# Ensure you own the files
ls -la .claude/commands/ | grep $USER
```

---

## 2. PLAN.md Issues

### Problem: PLAN.md Corruption

**Symptom**: Malformed markdown, broken sections, missing markers

**Diagnosis**:
```bash
# Check for common corruption signs
grep -E "^#{1,6} [^#]" .flow/PLAN.md | head -20  # Verify heading levels
grep "✅\|⏳\|🚧\|🎨" .flow/PLAN.md | wc -l      # Count status markers
```

**Solutions**:

**A. Restore from backup**
```bash
# List backups (if any)
ls -la .flow/PLAN.md.backup-*

# Restore most recent
cp .flow/PLAN.md.backup-2025-10-02 .flow/PLAN.md
```

**B. Restore from git**
```bash
# Check git history
git log --oneline .flow/PLAN.md

# Restore from specific commit
git checkout <commit-hash> .flow/PLAN.md
```

**C. Fix manually**
```bash
# Open in editor
code .flow/PLAN.md

# Verify structure:
# - Headings: # → ## → ### → #### → #####
# - Status markers at every level
# - No orphan sections
```

---

### Problem: Status Marker Conflicts

**Symptom**: Multiple items marked 🚧, conflicting status indicators

**Diagnosis**:
```bash
# Find all IN PROGRESS markers
grep "🚧" .flow/PLAN.md

# Should only be ONE iteration/task/phase marked 🚧
```

**Solutions**:

**A. Fix multiple 🚧 markers**
```markdown
<!-- WRONG: Multiple items IN PROGRESS -->
##### Iteration 1: API Setup 🚧
##### Iteration 2: Webhooks 🚧

<!-- CORRECT: Only current item -->
##### Iteration 1: API Setup ✅
##### Iteration 2: Webhooks 🚧
```

**B. Verify with `/flow-status`**
```bash
/flow-status
# Shows current phase/task/iteration
# Detects conflicts
```

**C. Use smart verification**
```bash
# Flow skips ✅ items (verified & frozen)
# Only verifies active work (🚧 ⏳ 🎨 ❌ 🔮)
```

---

### Problem: Large File Performance

**Symptom**: PLAN.md exceeds 2000 lines, slow to navigate

**Diagnosis**:
```bash
# Check file size
wc -l .flow/PLAN.md
# If > 1000 lines, consider Progress Dashboard

# Check line count
ls -lh .flow/PLAN.md
# If > 100KB, definitely need optimization
```

**Solutions**:

**A. Add Progress Dashboard** (Recommended)
```markdown
## 📋 Progress Dashboard

**Current Work**:
- **Phase**: Phase 2 → [Jump](#phase-2-enhancement--polish-)
- **Task**: Task 3 → [Jump](#task-3-documentation--examples-)
- **Iteration**: Iteration 1 → [Jump](#iteration-1-testing-guide-)

**Progress Overview**:
- ✅ **Iteration 1-10**: [Grouped] (verified & frozen)
- 🚧 **Iteration 11**: Current ← **YOU ARE HERE**
```

**B. Use jump links**
```markdown
[Jump to current work](#iteration-11-current-work-)
```

**C. Group completed items**
```markdown
<!-- Instead of listing all: -->
✅ Iteration 1: Setup
✅ Iteration 2: API
✅ Iteration 3: Webhooks
...

<!-- Use grouped format: -->
✅ **Iteration 1-10**: Core features (verified & frozen)
```

---

### Problem: Lost Context Between Sessions

**Symptom**: New AI session doesn't know current state

**Diagnosis**:
```bash
# Verify PLAN.md status line
head -10 .flow/PLAN.md | grep "Status:"

# Check for stale status sections
grep -i "progress tracking" .flow/PLAN.md
```

**Solutions**:

**A. Always run `/flow-status` at session start**
```bash
# New session starts:
/flow-status
# Shows: Phase 2, Task 3, Iteration 5 - In Progress

# Explicitly tell AI:
"We're on Iteration 5, brainstorming complete, ready to implement"
```

**B. Use `/flow-verify-plan`**
```bash
/flow-verify-plan
# Checks PLAN.md matches actual codebase
# Reports discrepancies
```

**C. Clean up duplicate status sections**
```markdown
<!-- WRONG: Multiple status sections -->
**Status**: Phase 1 (line 10)
...
## Progress Tracking (line 3000)
Current Phase: Phase 2 ← STALE!

<!-- CORRECT: Single source of truth -->
**Status**: Phase 2 (line 10)
## Progress Dashboard (line 150)
[Up-to-date pointer to current work]
```

---

## 3. Build & Installation Issues

### Problem: Build Fails with Heredoc Errors

**Symptom**: `build-standalone.sh` fails, truncated output

**Diagnosis**:
```bash
# Run build and capture errors
./build-standalone.sh 2>&1 | tee build-error.log

# Check heredoc markers
grep -c "FRAMEWORK_DATA_EOF" flow.sh
# Should be exactly 2 (start + end)
```

**Solutions**:

**A. Fix malformed heredocs**
```bash
# Check for unterminated heredocs
grep -A 5 "<<'.*EOF'" build-standalone.sh

# Ensure EOF markers are on their own line:
cat <<'FRAMEWORK_DATA_EOF'
content here
FRAMEWORK_DATA_EOF    # ← Must be alone on line, no spaces!
```

**B. Verify source files**
```bash
# Ensure sources exist and are readable
test -f framework/DEVELOPMENT_FRAMEWORK.md && echo "✓" || echo "✗"
test -f framework/EXAMPLE_PLAN.md && echo "✓" || echo "✗"
test -f framework/SLASH_COMMANDS.md && echo "✓" || echo "✗"
```

**C. Check for special characters**
```bash
# Heredocs break with certain characters
# Ensure proper escaping in build-standalone.sh

# If source has backticks or $, use single quotes:
cat <<'EOF'    # ← Single quotes prevent expansion
content with `backticks` and $vars
EOF
```

---

### Problem: Installation Creates Wrong Files

**Symptom**: `flow.sh` installs to wrong locations or creates 0 commands

**Diagnosis**:
```bash
# Check what was created
find . -name "flow-*.md" -type f

# Verify command count
ls -1 .claude/commands/ | wc -l
# Should be 20
```

**Solutions**:

**A. Check extraction logic**
```bash
# Test extraction manually
mkdir -p /tmp/flow-test
cd /tmp/flow-test
~/flow/flow.sh

# Verify output:
ls -la .flow/           # 2 files
ls -la .claude/commands/  # 20 files
```

**B. Fix directory creation**
```bash
# Ensure directories exist first
mkdir -p .claude/commands
mkdir -p .flow
./flow.sh
```

**C. Check awk parsing**
```bash
# flow.sh uses awk to extract heredocs
# Verify awk is available:
which awk
# If missing, install: brew install gawk (macOS) or apt install gawk (Linux)
```

---

### Problem: Permission Denied During Install

**Symptom**: "Permission denied" when running `./flow.sh`

**Diagnosis**:
```bash
# Check if flow.sh is executable
ls -la flow.sh
# Should show: -rwxr-xr-x (executable)
```

**Solutions**:

**A. Make executable**
```bash
chmod +x flow.sh
./flow.sh
```

**B. Run with bash explicitly**
```bash
bash flow.sh
```

**C. Check directory permissions**
```bash
# Ensure you can write to current directory
touch test.txt && rm test.txt || echo "No write permission!"
```

---

## 4. Reference Issues

### Problem: Broken Jump Links

**Symptom**: `[Jump](#phase-2)` doesn't navigate to section

**Diagnosis**:
```bash
# Find all jump links
grep -E '\[Jump\]\(#.*\)' .flow/PLAN.md

# Verify anchors exist
grep "### Phase 2" .flow/PLAN.md
```

**Solutions**:

**A. Fix anchor format**
```markdown
<!-- WRONG: Anchor doesn't match heading -->
[Jump](#phase-2)
### Phase 2: Enhancement & Polish

<!-- CORRECT: Anchor matches (lowercase, hyphens) -->
[Jump](#phase-2-enhancement--polish-)
### Phase 2: Enhancement & Polish
```

**B. Markdown anchor rules**
```markdown
Heading: ### Phase 2: Enhancement & Polish!
Anchor:  #phase-2-enhancement--polish

Rules:
- Lowercase only
- Spaces → hyphens
- Special chars removed (! ? . ,)
- Multiple spaces → single hyphen
- Trailing punctuation → hyphen
```

**C. Test links in markdown preview**
```bash
# Use VS Code or similar
code .flow/PLAN.md
# Cmd+Click (Mac) or Ctrl+Click (Windows) on link
```

---

### Problem: Missing Cross-References

**Symptom**: Links to framework docs show "file not found"

**Diagnosis**:
```bash
# Check if referenced files exist
grep -E '\[.*\]\(.*\.md\)' .flow/PLAN.md | while read link; do
  file=$(echo $link | sed -E 's/.*\((.*)\.md\).*/\1.md/')
  test -f "$file" && echo "✓ $file" || echo "✗ $file (missing)"
done
```

**Solutions**:

**A. Install framework docs**
```bash
# Ensure .flow/ has docs
ls -la .flow/
# Should show:
# - DEVELOPMENT_FRAMEWORK.md
# - EXAMPLE_PLAN.md

# If missing, reinstall:
./flow.sh --force
```

**B. Fix relative paths**
```markdown
<!-- WRONG: Absolute path -->
[Framework](/Users/user/flow/DEVELOPMENT_FRAMEWORK.md)

<!-- CORRECT: Relative path -->
[Framework](DEVELOPMENT_FRAMEWORK.md)
```

**C. Use auto-locate pattern**
```bash
# Commands search for framework in order:
# 1. .flow/DEVELOPMENT_FRAMEWORK.md
# 2. .claude/DEVELOPMENT_FRAMEWORK.md
# 3. ./DEVELOPMENT_FRAMEWORK.md
# 4. ~/.claude/flow/DEVELOPMENT_FRAMEWORK.md
```

---

### Problem: Broken File Path References

**Symptom**: Mentioned files (`build-standalone.sh`) don't exist

**Diagnosis**:
```bash
# Find all file references
grep -E '`[^`]*\.(ts|js|md|sh)`' .flow/PLAN.md

# Verify each exists
test -f build-standalone.sh && echo "✓" || echo "✗ Missing"
```

**Solutions**:

**A. Use correct paths**
```markdown
<!-- In PLAN.md, paths are relative to project root -->
`src/services/Blue.ts` ← Correct if file exists at this path
```

**B. Verify before documenting**
```bash
# Before adding file reference to PLAN.md:
ls -la path/to/file.ts
# If exists, add to PLAN.md
```

**C. Use markdown-link-check**
```bash
# Install (one-time)
npm install -g markdown-link-check

# Check all links
markdown-link-check .flow/PLAN.md
```

---

## 5. Performance Issues

### Problem: Slow Command Execution

**Symptom**: `/flow-status` takes 5+ seconds to run

**Diagnosis**:
```bash
# Check PLAN.md size
wc -l .flow/PLAN.md
ls -lh .flow/PLAN.md

# If > 2000 lines or > 150KB, performance degrades
```

**Solutions**:

**A. Add Progress Dashboard** (See Pattern #5)
```markdown
## 📋 Progress Dashboard
[Pointer to current work with jump links]
```

**B. Group completed items**
```markdown
<!-- Token-heavy (slow): -->
✅ Iteration 1: Feature A
✅ Iteration 2: Feature B
...
✅ Iteration 50: Feature Z

<!-- Token-efficient (fast): -->
✅ **Iteration 1-50**: Core features (verified & frozen)
```

**C. Use smart verification**
```bash
# Commands skip ✅ COMPLETE items (already verified)
# Only verify active work: 🚧 ⏳ 🎨 ❌ 🔮
```

---

### Problem: High Memory Usage

**Symptom**: Claude Code/AI slows down with large PLAN.md

**Diagnosis**:
```bash
# Check context size
wc -w .flow/PLAN.md
# If > 50,000 words, context is huge

# Check active iterations
grep "🚧\|⏳\|🎨" .flow/PLAN.md | wc -l
# If > 20, too many active items
```

**Solutions**:

**A. Complete iterations before starting new ones**
```bash
# Instead of:
Iteration 1: 🚧 (50% done)
Iteration 2: 🚧 (30% done)  ← Bad!
Iteration 3: ⏳

# Do this:
Iteration 1: ✅ (complete)
Iteration 2: 🚧 (current)
Iteration 3: ⏳
```

**B. Mark iterations complete**
```bash
/flow-implement_complete
# Marks iteration ✅ (frozen)
# Future commands skip it (saves tokens)
```

**C. Use `/flow-compact` before new sessions**
```bash
# Generate context transfer report
/flow-compact

# Provides summary without full PLAN.md
# Use summary to start new session
```

---

### Problem: Git Merge Conflicts in PLAN.md

**Symptom**: Multiple developers/AI sessions create conflicts

**Diagnosis**:
```bash
# Check for conflict markers
grep -E '^<<<<<<|^======|^>>>>>>' .flow/PLAN.md
```

**Solutions**:

**A. Prevention: Use branches per iteration**
```bash
# Developer A:
git checkout -b iteration-5
/flow-iteration "Feature X"
# ... work ...
git commit -m "Complete Iteration 5"

# Developer B:
git checkout -b iteration-6
/flow-iteration "Feature Y"
# ... work ...
git commit -m "Complete Iteration 6"
```

**B. Resolution: Accept both changes**
```markdown
<!-- Conflict: -->
<<<<<<< HEAD
##### Iteration 5: Feature X ✅
=======
##### Iteration 6: Feature Y ✅
>>>>>>> branch-b

<!-- Resolution: Both complete, merge both -->
##### Iteration 5: Feature X ✅
##### Iteration 6: Feature Y ✅
```

**C. Use `/flow-verify-plan` after merge**
```bash
git merge iteration-6
# ... resolve conflicts ...
/flow-verify-plan
# Verifies structure is still valid
```

---

## Quick Diagnostic Commands

### Check Flow Health

```bash
# 1. Verify installation
ls -la .flow/ .claude/commands/

# 2. Check PLAN.md structure
grep -E "^#{1,6} " .flow/PLAN.md | head -20

# 3. Verify current status
/flow-status

# 4. Check for corruption
grep "✅\|⏳\|🚧\|🎨\|❌\|🔮" .flow/PLAN.md | head -10

# 5. Validate build
./build-standalone.sh && echo "✓ Build OK" || echo "✗ Build failed"
```

### Emergency Recovery

**If everything is broken**:

```bash
# 1. Backup current state
cp .flow/PLAN.md .flow/PLAN.md.emergency-backup

# 2. Restore from git (if available)
git checkout HEAD~1 .flow/PLAN.md

# 3. Or restore from backup
ls -la .flow/PLAN.md.backup-*
cp .flow/PLAN.md.backup-<timestamp> .flow/PLAN.md

# 4. Or reinstall framework and start over
./flow.sh --force
/flow-blueprint "Project Recovery"
```

---

## Getting Help

**Still stuck?**

1. **Check logs**: Look for error messages in terminal output
2. **Search issues**: [GitHub Issues](https://github.com/khgs2411/flow/issues)
3. **Open new issue**: Include:
   - Flow version (`grep "Version" framework/DEVELOPMENT_FRAMEWORK.md`)
   - Error message (full output)
   - Steps to reproduce
   - PLAN.md structure (if relevant)
4. **Join community**: Discussions for Q&A

---

**Maintainer**: Flow Framework Team
**Report Issues**: [GitHub Issues](https://github.com/khgs2411/flow/issues)
**More Help**: See [TESTING.md](TESTING.md) and [ADVANCED_PATTERNS.md](ADVANCED_PATTERNS.md)
