# Contributing to Flow Framework

Thank you for your interest in improving Flow! 🎯

## For Users

If you just want to **use** the Flow framework, no forking needed:

```bash
# Download the distribution file
wget https://raw.githubusercontent.com/khgs2411/flow/master/flow.sh
chmod +x flow.sh

# Run in your project
./flow.sh
```

That's it! The framework will be installed in your project.

---

## For Contributors

Want to improve the framework? Here's how:

### 1. Fork & Clone

```bash
# Fork this repository on GitHub first (click "Fork" button)

# Then clone YOUR fork
git clone https://github.com/YOUR-USERNAME/flow.git
cd flow
```

### 2. Understand the Structure

```
flow/
├── README.md                    # Documentation
├── flow.sh                      # Distribution file (GENERATED - don't edit directly!)
├── build-standalone.sh          # Build script (generates flow.sh)
└── framework/                   # SOURCE FILES (edit these!)
    ├── DEVELOPMENT_FRAMEWORK.md # Methodology guide
    ├── EXAMPLE_PLAN.md          # Reference example
    └── SLASH_COMMANDS.md        # Command definitions
```

**Important**:
- ✅ Edit files in `framework/` directory
- ❌ Don't edit `flow.sh` directly (it's generated)

### 3. Make Your Changes

```bash
# Create a feature branch
git checkout -b feature/my-improvement

# Edit source files
vim framework/DEVELOPMENT_FRAMEWORK.md
vim framework/EXAMPLE_PLAN.md
vim framework/SLASH_COMMANDS.md

# Rebuild the distribution file
./build-standalone.sh

# Test the generated flow.sh
cd /tmp/test-project
~/flow/flow.sh
# Verify installation works correctly
```

### 4. Commit & Push

```bash
# Stage your changes
git add -A

# Commit with descriptive message
git commit -m "Add: Description of your improvement

- Bullet point 1
- Bullet point 2"

# Push to YOUR fork
git push origin feature/my-improvement
```

### 5. Create Pull Request

1. Go to your fork on GitHub: `https://github.com/YOUR-USERNAME/flow`
2. Click "Pull Request" button
3. Select: `YOUR-USERNAME:feature/my-improvement` → `khgs2411:master`
4. Describe your changes
5. Submit!

---

## Development Workflow

### Building

```bash
# After editing source files in framework/
./build-standalone.sh

# This regenerates flow.sh with your changes embedded
```

### Testing

```bash
# Test in a clean directory
mkdir /tmp/test-flow
cd /tmp/test-flow
/path/to/flow/flow.sh

# Verify:
# - .claude/commands/ has 15 files
# - .flow/DEVELOPMENT_FRAMEWORK.md exists
# - .flow/EXAMPLE_PLAN.md exists
```

### Commit Message Format

Use descriptive commits:

```
[Type]: Short description (50 chars max)

- Detailed bullet point 1
- Detailed bullet point 2
- Reference to issue if applicable
```

**Types**:
- `Add:` New feature or content
- `Fix:` Bug fix
- `Update:` Improve existing content
- `Refactor:` Code restructure (no behavior change)
- `Docs:` Documentation only

---

## What to Contribute

### Ideas Welcome

- 🐛 **Bug fixes** - Found an issue? Fix it!
- 📝 **Documentation improvements** - Clarify confusing sections
- ✨ **New patterns** - Discovered useful workflow patterns?
- 🎨 **Example improvements** - Better examples in EXAMPLE_PLAN.md
- 🔧 **New slash commands** - Useful automation commands

### Before Starting Big Changes

**Open an issue first** to discuss:
- Major architectural changes
- New slash commands
- Significant pattern changes

This prevents wasted effort if the change doesn't align with the framework philosophy.

---

## Philosophy

Flow framework is built on these principles:

1. **Plan before code** - Brainstorming → Implementation
2. **Preserve context** - PLAN.md is memory across sessions
3. **Iterative refinement** - Skeleton → Flesh → Fibers
4. **Single source of truth** - One PLAN.md per feature
5. **AI-friendly** - Patterns that work across different AI models

Keep these in mind when proposing changes!

---

## Releasing (Maintainers Only)

### Single Source of Truth: VERSION File

The `VERSION` file is the **single source of truth** for versioning:

```bash
# VERSION file contains just the version number
1.1.1
```

All other files read from this:
- `build-standalone.sh` reads VERSION to build flow.sh
- `release.sh` reads VERSION for git tags and GitHub releases

### Release Process

```bash
# 1. Update VERSION file
echo "1.1.1" > VERSION

# 2. Run release script (handles everything)
./release.sh
```

The `release.sh` script automates:
1. ✅ Builds flow.sh with VERSION number
2. ✅ Prompts for changelog entry
3. ✅ Updates CHANGELOG.md
4. ✅ Creates git commit
5. ✅ Creates git tag (v1.1.1)
6. ✅ Pushes to GitHub
7. ✅ Creates GitHub release with flow.sh asset

### What to Include in Changelog

Follow this format:

```markdown
**v1.1.1** - Feature Name (YYYY-MM-DD)

**Changes**:
- Added new feature X
- Fixed bug Y
- Improved documentation Z

See the [v1.1.1 release](https://github.com/khgs2411/flow/releases/tag/v1.1.1) for full details.
```

### Version Numbering

Flow follows semantic versioning: `MAJOR.MINOR.PATCH`

- **MAJOR** (X.0.0): Breaking changes to framework structure or commands
- **MINOR** (0.X.0): New features, new commands, significant enhancements
- **PATCH** (0.0.X): Bug fixes, documentation updates, minor improvements

**Examples**:
- `1.0.0 → 1.0.1`: Fixed bug in `/flow-status` command (patch)
- `1.0.1 → 1.1.0`: Added backlog management commands (minor)
- `1.1.0 → 2.0.0`: Changed PLAN.md structure (breaking - major)

### Pre-Release Checklist

Before running `./release.sh`:

- [ ] All tests pass
- [ ] Documentation updated
- [ ] EXAMPLE_PLAN.md reflects new features
- [ ] Rebuilt flow.sh (`./build-standalone.sh`)
- [ ] Tested installation (`./flow.sh --force` in test directory)
- [ ] Git status is clean (commit everything first)

### Post-Release Tasks

After release is published:

- [ ] Verify GitHub release shows correct version
- [ ] Verify flow.sh download works
- [ ] Update README.md if needed (screenshots, feature list)
- [ ] Announce in project channels

---

## Questions?

- 💬 **Open an issue** for questions or discussions
- 📧 **Email** (if you prefer private communication - add your email if desired)
- 🐛 **Bug reports** - Include steps to reproduce

---

## Code of Conduct

Be respectful and constructive. We're all here to build better development tools.

---

**Thank you for contributing to Flow!** 🚀

*This framework was born from real-world usage on the RED RPG project. Every pattern here was battle-tested in organic development.*
