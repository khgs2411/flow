# Flow Framework - Testing Guide

> **Version**: 1.0.11
> **Last Updated**: 2025-10-02
> **Purpose**: Comprehensive guide for testing Flow framework changes

---

## Table of Contents

1. [Build System Testing](#1-build-system-testing)
2. [Installation Testing](#2-installation-testing)
3. [Command Testing](#3-command-testing)
4. [Cross-Reference Validation](#4-cross-reference-validation)
5. [Version Consistency](#5-version-consistency)
6. [Dogfooding Pattern: Meta-Flow](#6-dogfooding-pattern-meta-flow)

---

## 1. Build System Testing

### Overview

The build system (`build-standalone.sh`) generates `flow.sh` from source files in `framework/`. Testing ensures the generated distribution file is valid and contains all embedded content correctly.

### 3-Level Verification Approach

#### Level 1: Pre-Build Checks

Verify source files exist before running the build:

```bash
# Check all source files exist
test -f framework/DEVELOPMENT_FRAMEWORK.md || echo "ERROR: Framework doc missing"
test -f framework/EXAMPLE_PLAN.md || echo "ERROR: Example missing"
test -f framework/SLASH_COMMANDS.md || echo "ERROR: Commands missing"

# Verify files are readable
test -r framework/DEVELOPMENT_FRAMEWORK.md && echo "✓ Framework readable"
test -r framework/EXAMPLE_PLAN.md && echo "✓ Example readable"
test -r framework/SLASH_COMMANDS.md && echo "✓ Commands readable"
```

**Expected Output**: All files exist and are readable

#### Level 2: Build Validation

Run the build and verify `flow.sh` structure:

```bash
# Run build
./build-standalone.sh

# Check file size (should be ~63KB)
ls -lh flow.sh
# Expected: -rwxr-xr-x  1 user  staff   63K Oct  2 14:00 flow.sh

# Check line count (should be ~2200+ lines)
wc -l flow.sh
# Expected: 2200+ flow.sh

# Verify heredoc integrity - each should appear twice (start + end)
grep -c "FRAMEWORK_DATA_EOF" flow.sh  # Should be 2
grep -c "EXAMPLE_DATA_EOF" flow.sh    # Should be 2
grep -c "COMMANDS_DATA_EOF" flow.sh   # Should be 2
```

**Expected Results**:
- File size: ~63KB (±5KB acceptable)
- Line count: 2200+ lines
- Each heredoc marker appears exactly 2 times

#### Level 3: Post-Build Smoke Test

Verify extraction logic works correctly:

```bash
# Create clean test directory
mkdir -p /tmp/flow-build-test
cd /tmp/flow-build-test

# Run flow.sh
~/path/to/flow-repo/flow.sh

# Verify directories created
ls -la .flow/ .claude/commands/
# Expected: .flow/ has 2 files, .claude/commands/ has 20 files

# Verify content matches sources
diff .flow/DEVELOPMENT_FRAMEWORK.md ~/path/to/flow-repo/framework/DEVELOPMENT_FRAMEWORK.md
diff .flow/EXAMPLE_PLAN.md ~/path/to/flow-repo/framework/EXAMPLE_PLAN.md

# Count extracted commands
ls -1 .claude/commands/ | wc -l
# Expected: 20
```

**Expected Results**:
- `.flow/` contains 2 files (DEVELOPMENT_FRAMEWORK.md, EXAMPLE_PLAN.md)
- `.claude/commands/` contains 20 command files
- `diff` shows no differences (exit code 0)

### Troubleshooting Common Build Failures

| Issue | Cause | Solution |
|-------|-------|----------|
| **Truncated heredoc** | Missing EOF marker | Check for unterminated `<<'EOF'` blocks |
| **Wrong line count** | Source file modified without rebuild | Run `./build-standalone.sh` again |
| **Heredoc count ≠ 2** | Malformed heredoc syntax | Verify EOF markers are on their own line |
| **Extraction fails** | Incorrect awk parsing | Check heredoc delimiters match exactly |
| **Permission denied** | flow.sh not executable | Run `chmod +x flow.sh` |

---

## 2. Installation Testing

### Overview

Test `flow.sh` installation in different scenarios to ensure reliability across fresh installs, upgrades, and error recovery.

### 4 Installation Scenarios

#### Scenario 1: Fresh Install (New Project)

**Setup**: New project with no existing `.flow/` or `.claude/` directories

```bash
# Create clean test project
mkdir -p /tmp/test-fresh-install
cd /tmp/test-fresh-install

# Run installation
~/path/to/flow-repo/flow.sh
```

**Expected Output**:
```
✓ Created .flow/ directory
✓ Installed DEVELOPMENT_FRAMEWORK.md
✓ Installed EXAMPLE_PLAN.md
✓ Created .claude/commands/ directory
✓ Installed 20 slash commands
✨ Flow framework installed successfully!
```

**Validation Checklist**:
- [ ] `.flow/` directory created
- [ ] `.flow/DEVELOPMENT_FRAMEWORK.md` exists and matches source
- [ ] `.flow/EXAMPLE_PLAN.md` exists and matches source
- [ ] `.claude/commands/` directory created
- [ ] 20 command files created (flow-blueprint.md, flow-phase.md, etc.)
- [ ] All command files are valid markdown
- [ ] No errors in output

#### Scenario 2: Force Reinstall (Update Existing)

**Setup**: Existing Flow installation

```bash
# Run in directory with existing .flow/
./flow.sh --force
```

**Expected Output**:
```
⚠️  --force flag detected
✓ Overwriting existing .flow/ files
✓ Updated DEVELOPMENT_FRAMEWORK.md
✓ Updated EXAMPLE_PLAN.md
✓ Overwriting existing .claude/commands/ files
✓ Updated 20 slash commands
✨ Flow framework reinstalled successfully!
```

**Validation Checklist**:
- [ ] Existing files overwritten (no errors)
- [ ] Updated content matches latest sources
- [ ] No backup files created (intentional overwrite)
- [ ] All 20 commands updated

#### Scenario 3: Upgrade from Old Version

**Setup**: Simulate old version with outdated content

```bash
# Simulate old version
echo "# Old Framework Version 0.9" > .flow/DEVELOPMENT_FRAMEWORK.md
echo "# Old Example" > .flow/EXAMPLE_PLAN.md

# Force upgrade
./flow.sh --force
```

**Expected Output**:
```
⚠️  --force flag detected
✓ Replacing old framework files
✓ Updated DEVELOPMENT_FRAMEWORK.md (v1.0.9 → v1.0.11)
✓ Updated EXAMPLE_PLAN.md
✨ Framework upgraded successfully!
```

**Validation Checklist**:
- [ ] Old content completely replaced
- [ ] New version installed correctly
- [ ] No remnants of old version
- [ ] Version numbers updated in all files

#### Scenario 4: Partial Installation Recovery

**Setup**: Missing `.claude/commands/` but `.flow/` exists

```bash
# Simulate partial installation
rm -rf .claude/commands/

# Run installation (without --force)
./flow.sh
```

**Expected Output**:
```
✓ .flow/ directory exists (skipping)
✓ Created .claude/commands/ directory
✓ Installed 20 slash commands
✨ Flow framework installation repaired!
```

**Validation Checklist**:
- [ ] Existing `.flow/` files untouched
- [ ] `.claude/commands/` recreated
- [ ] All 20 commands installed
- [ ] No duplicate or conflicting files

### Rollback Procedure

If installation fails:

```bash
# 1. Check what was created
ls -la .flow/ .claude/

# 2. Remove partial installation
rm -rf .flow/ .claude/

# 3. Re-run with clean state
./flow.sh

# 4. If still failing, check prerequisites
which bash  # Ensure bash is available
test -r flow.sh && echo "flow.sh is readable"
```

---

## 3. Command Testing

### Overview

Test all 20 slash commands using dual approach: automated (with Claude Code) and manual (without Claude Code).

### Dual Testing Approach

#### Approach A: With Claude Code (Automated)

**Workflow**:
1. Run command directly: `/flow-blueprint "test feature"`
2. Verify `.flow/PLAN.md` created with correct structure
3. Check status markers, sections, cross-references
4. Compare output against expected results

**Example Test**:
```
# Run command
/flow-blueprint "User Authentication System"

# Verify PLAN.md structure
✓ Overview section exists
✓ Architecture section exists
✓ Testing Strategy section exists
✓ Development Plan section exists
✓ Status markers present (⏳)
```

#### Approach B: Without Claude Code (Manual)

**Workflow**:
1. Read `framework/SLASH_COMMANDS.md` section for command
2. Execute steps 1-N manually
3. Compare result with automated test output
4. Verify both produce identical PLAN.md structure

**Example Test**:
```bash
# 1. Read command definition
cat framework/SLASH_COMMANDS.md | grep -A 50 "## /flow-blueprint"

# 2. Execute instructions manually
# - Read DEVELOPMENT_FRAMEWORK.md
# - Gather feature requirements
# - Generate PLAN.md with template

# 3. Compare results
diff automated-PLAN.md manual-PLAN.md
```

### Test Case Matrix (20 Commands)

#### Planning Commands (3)

| Command | Expected Behavior | Verification |
|---------|-------------------|--------------|
| `/flow-blueprint <name>` | Creates `.flow/PLAN.md` with Testing Strategy section | File exists, sections valid |
| `/flow-migrate [file]` | Converts existing docs to Flow format | Backup created, structure matches |
| `/flow-update-plan-version` | Updates PLAN.md to latest framework structure | Preserves content, enhances structure |

#### Structure Commands (3)

| Command | Expected Behavior | Verification |
|---------|-------------------|--------------|
| `/flow-phase <name>` | Adds new phase to PLAN.md | Phase added, status ⏳ |
| `/flow-task <name>` | Adds task under current phase | Task added under correct phase |
| `/flow-iteration <name>` | Adds iteration under current task | Iteration added, nested correctly |

#### Brainstorming Commands (4)

| Command | Expected Behavior | Verification |
|---------|-------------------|--------------|
| `/flow-brainstorm_start <topic>` | Marks iteration 🚧, creates brainstorm section | Status updated, subjects list created |
| `/flow-brainstorm_subject <name>` | Adds subject to discussion list | Subject added with ⏳ status |
| `/flow-brainstorm_resolve <subject>` | Resolves subject, documents decision | Subject ✅, resolution documented |
| `/flow-brainstorm_complete` | Marks iteration 🎨 READY | All subjects ✅, pre-tasks done |

#### Implementation Commands (2)

| Command | Expected Behavior | Verification |
|---------|-------------------|--------------|
| `/flow-implement_start` | Creates implementation section, copies action items | Status 🚧, action items present |
| `/flow-implement_complete` | Marks iteration ✅ COMPLETE | All items checked, verification noted |

#### Navigation Commands (8)

| Command | Expected Behavior | Verification |
|---------|-------------------|--------------|
| `/flow-status` | Shows current phase/task/iteration | Displays correct position |
| `/flow-summarize` | Shows full project structure | All phases/tasks/iterations listed |
| `/flow-next` | Suggests next command based on context | Correct suggestion given |
| `/flow-next-subject` | Shows next unresolved subject | First ⏳ subject displayed |
| `/flow-next-iteration` | Shows next pending iteration | First ⏳ iteration displayed |
| `/flow-rollback` | Undoes last PLAN.md change | Previous state restored |
| `/flow-verify-plan` | Verifies PLAN.md matches codebase | Discrepancies reported |
| `/flow-compact` | Generates context transfer report | Comprehensive summary created |

### Manual Testing Checklist (Non-Claude Users)

For users without Claude Code, follow these steps for each command:

1. **Read command definition** in `framework/SLASH_COMMANDS.md`
2. **Follow instructions** step-by-step (usually 5-10 steps)
3. **Update PLAN.md** manually according to patterns
4. **Verify structure** matches framework examples
5. **Compare with automated output** (if available)

**Example for /flow-blueprint**:
- [ ] Read framework guide (DEVELOPMENT_FRAMEWORK.md)
- [ ] Gather feature requirements from user
- [ ] Ask about testing methodology
- [ ] Generate PLAN.md using template
- [ ] Include: Overview, Architecture, Testing Strategy, Development Plan
- [ ] Verify all sections present and formatted correctly

---

## 4. Cross-Reference Validation

### Overview

Validate 3 types of references to ensure documentation integrity and prevent broken links.

### Type 1: Internal Links (Markdown Anchors)

**Purpose**: Jump links in Progress Dashboard must work in large PLAN.md files

**Validation**:
```bash
# Find all internal links
grep -E '\[.*\]\(#.*\)' .flow/PLAN.md

# Example output:
# [Jump](#phase-2-enhancement--polish-)
# [Jump](#task-3-documentation--examples-)

# Manually verify anchors exist
grep "### Phase 2: Enhancement & Polish" .flow/PLAN.md
grep "#### Task 3: Documentation & Examples" .flow/PLAN.md
```

**Expected Results**:
- Each `[Jump](#anchor)` link has corresponding `### Anchor` section
- Anchor text matches (accounting for markdown anchor rules: lowercase, hyphens)

### Type 2: Inter-Document Links

**Purpose**: Framework docs must reference each other correctly

**Validation**:
```bash
# Find all markdown file references
grep -E '\[.*\]\(.*\.md\)' framework/*.md .flow/*.md

# Example output:
# [DEVELOPMENT_FRAMEWORK.md](DEVELOPMENT_FRAMEWORK.md)
# [EXAMPLE_PLAN.md](EXAMPLE_PLAN.md)

# Verify referenced files exist
test -f .flow/DEVELOPMENT_FRAMEWORK.md && echo "✓ Framework exists"
test -f .flow/EXAMPLE_PLAN.md && echo "✓ Example exists"
```

**Cross-Reference Matrix**:

| From | To | Reference Type | Valid? |
|------|-----|----------------|--------|
| PLAN.md | DEVELOPMENT_FRAMEWORK.md | Relative path | ✓ |
| PLAN.md | EXAMPLE_PLAN.md | Relative path | ✓ |
| DEVELOPMENT_FRAMEWORK.md | EXAMPLE_PLAN.md | Relative path | ✓ |
| SLASH_COMMANDS.md | DEVELOPMENT_FRAMEWORK.md | Auto-locate | ✓ |

### Type 3: File Path References

**Purpose**: Code examples and file mentions must point to real files

**Validation**:
```bash
# Find all file path references in backticks
grep -E '`[^`]*\.(ts|js|md|sh)`' framework/*.md

# Example output:
# `build-standalone.sh`
# `flow.sh`
# `framework/DEVELOPMENT_FRAMEWORK.md`

# Check if mentioned files exist
test -f build-standalone.sh && echo "✓ Build script exists"
test -f flow.sh && echo "✓ Distribution exists"
```

**Expected Results**:
- All referenced files exist in repo
- Paths are correct (relative or absolute as appropriate)
- No references to non-existent examples

### Automated Link Checking (Recommended)

**Using markdown-link-check**:
```bash
# Install (one-time)
npm install -g markdown-link-check

# Check all markdown files
find . -name "*.md" -exec markdown-link-check {} \;

# Check specific file
markdown-link-check .flow/PLAN.md
```

**Expected Output**:
```
FILE: .flow/PLAN.md
✓ [DEVELOPMENT_FRAMEWORK.md](DEVELOPMENT_FRAMEWORK.md)
✓ [EXAMPLE_PLAN.md](EXAMPLE_PLAN.md)
✓ [Phase 2](#phase-2-enhancement--polish-)
```

---

## 5. Version Consistency

### Overview

Ensure version numbers are consistent across all files before releasing.

### Version Locations

Flow framework version appears in:
1. `CHANGELOG.md` (top of file)
2. `framework/DEVELOPMENT_FRAMEWORK.md` (header and footer)
3. `README.md` ("What's New" section)
4. Git tags (e.g., `v1.0.11`)

### Version Check Commands

```bash
# 1. Check CHANGELOG.md version
head -20 CHANGELOG.md | grep "^##.*v[0-9]"
# Expected: ## Current Version
#           **v1.0.11** - Description

# 2. Check framework version
head -1 framework/DEVELOPMENT_FRAMEWORK.md | grep "Version"
# Expected: **Version**: 1.0.11

tail -5 framework/DEVELOPMENT_FRAMEWORK.md | grep "Version"
# Expected: **Version**: 1.0.11

# 3. Check README.md version
grep "Latest version" README.md
# Expected: **Latest version**: [v1.0.11](...)

# 4. Check git tags
git tag --sort=-v:refname | head -1
# Expected: v1.0.11
```

### Pre-Release Checklist

Before creating a new release:

- [ ] Update version in `CHANGELOG.md`
- [ ] Update version in `framework/DEVELOPMENT_FRAMEWORK.md` (header)
- [ ] Update version in `framework/DEVELOPMENT_FRAMEWORK.md` (footer)
- [ ] Update version in `README.md` ("What's New" section)
- [ ] Run `./build-standalone.sh` to regenerate `flow.sh`
- [ ] Create git tag: `git tag -a v1.0.11 -m "Release v1.0.11: Description"`
- [ ] Push tag: `git push origin v1.0.11`
- [ ] Create GitHub Release with changelog

### Version Numbering

Flow follows semantic versioning: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes to framework structure or commands
- **MINOR**: New features, new commands, significant enhancements
- **PATCH**: Bug fixes, documentation updates, minor improvements

**Examples**:
- `v1.0.11` → `v1.0.12`: Documentation update (PATCH)
- `v1.0.11` → `v1.1.0`: New command added (MINOR)
- `v1.0.11` → `v2.0.0`: Framework restructure (MAJOR)

---

## 6. Dogfooding Pattern: Meta-Flow

### Overview

**Dogfooding** (eating your own dog food) is Flow's most effective testing strategy: using Flow to manage Flow's own development.

### Definition

**Meta-Flow Pattern**: Using the Flow framework to plan, develop, and enhance the Flow framework itself.

### This PLAN.md is the Proof

The `.flow/PLAN.md` in this repo demonstrates Flow managing Flow:

```
Phase 1: Core Implementation ✅
├── Task 1: Framework Foundation ✅
├── Task 2: Command System ✅
├── Task 3: Build & Distribution ✅
└── Task 4: Documentation ✅

Phase 2: Enhancement & Polish 🚧
├── Task 1: Progress Tracking System ✅
├── Task 2: Migration & Version Management ✅
├── Task 3: Documentation & Examples 🚧
│   └── Iteration 1: Testing Guide (this file!) 🚧
├── Task 4: Developer Experience ⏳
└── Task 5: Command Flow Redesign ⏳

Phase 3: Community & Ecosystem ⏳
```

### Benefits

1. **Self-Validation**: Proves methodology works at scale
   - Flow has managed 10+ versions, 5+ tasks, 20+ iterations
   - Complex features (Progress Dashboard, Migration system) built using Flow

2. **Early UX Detection**: We experience issues before users do
   - Command flow confusion discovered during dogfooding → Task 5 created
   - Testing Strategy pattern emerged from real testing needs
   - Progress Dashboard invented for managing large PLAN.md files

3. **Real-World Examples**: This PLAN.md is a living reference
   - Users can see Flow in action on a real project
   - Demonstrates brainstorming, iterations, pre-tasks, versioning
   - Proves "if Flow can manage Flow, it can manage anything"

4. **Continuous Improvement**: Learnings feed back into framework
   - Scope Boundary Rule (v1.0.8) from dogfooding experience
   - Subject Resolution Types (v1.0.7) from brainstorming confusion
   - Testing Strategy section (v1.0.9) from real testing needs

### Best Practices

1. **Treat Flow repo as a Flow project**
   - Use `.flow/PLAN.md` (not root PLAN.md)
   - Follow all framework patterns exactly
   - Never bypass the methodology

2. **Use all commands regularly**
   - `/flow-blueprint` for new features
   - `/flow-brainstorm_start` before implementing
   - `/flow-implement_start` and `/flow-implement_complete`
   - `/flow-status` to verify position

3. **Document every decision with rationale**
   - Why this approach over alternatives?
   - What tradeoffs were considered?
   - How does this serve users?

4. **Capture UX pain points as new tasks/iterations**
   - Command confusion → Task 5: Command Flow Redesign
   - Testing needs → Task 3: Documentation & Examples
   - User feedback → New features in backlog

5. **Update framework based on dogfooding insights**
   - Add patterns discovered during dogfooding
   - Enhance commands that felt awkward
   - Document lessons learned

### Evidence of Dogfooding Impact

**Discovered through dogfooding**:
- ✅ Task 5 (Command Flow Redesign) - emerged from real confusion
- ✅ Testing Strategy section - from actual testing needs
- ✅ Progress Dashboard pattern - discovered managing 3000+ line PLAN.md
- ✅ Scope Boundary Rule - from accidentally fixing out-of-scope issues
- ✅ Subject Resolution Types - from brainstorming ambiguity
- ✅ Pre-Implementation Tasks - from real refactoring needs

**Framework versions driven by dogfooding**:
- v1.0.4: Progress Dashboard (managing large files)
- v1.0.5: Migration system (mid-development adoption)
- v1.0.7: Subject Resolution Types (clearer decisions)
- v1.0.8: Scope Boundary Rule (prevent scope creep)
- v1.0.9: Testing Strategy (respect user conventions)

### How to Dogfood Your Framework

If you're building a framework/tool/library:

1. **Use it immediately**: Don't wait until it's "ready" - use v0.1 on itself
2. **Feel the pain**: Every awkward moment is a feature request
3. **Document everything**: Your experience is your best test case
4. **Iterate rapidly**: Fix what hurts while the pain is fresh
5. **Share the journey**: Your PLAN.md becomes your best documentation

**Example**: This TESTING.md was created using Flow's methodology:
```
/flow-brainstorm_start "Testing & Verification Strategy"
  - 6 subjects resolved
  - All Type B (Immediate Documentation)
  - No pre-implementation tasks

/flow-implement_start
  - Created TESTING.md with all 6 sections
  - Included examples from dogfooding
  - This file is the proof!
```

---

## Quick Reference

### Daily Testing Routine

**Before committing**:
1. Run `./build-standalone.sh`
2. Check `wc -l flow.sh` (~2200+ lines)
3. Run `./flow.sh --force` in test directory
4. Verify 20 commands installed

**Before releasing**:
1. Update versions (CHANGELOG.md, framework, README.md)
2. Run build system test (Section 1)
3. Run installation test (Section 2)
4. Test key commands (Section 3)
5. Validate cross-references (Section 4)
6. Create git tag and release

### Common Test Commands

```bash
# Build test
./build-standalone.sh && wc -l flow.sh

# Installation test
mkdir -p /tmp/flow-test && cd /tmp/flow-test && ~/flow/flow.sh

# Version check
grep -r "Version.*1.0" framework/ README.md CHANGELOG.md

# Link check (if markdown-link-check installed)
find . -name "*.md" -exec markdown-link-check {} \;
```

---

**Maintainer**: Flow Framework Team
**Feedback**: [GitHub Issues](https://github.com/khgs2411/flow/issues)
**Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md)
