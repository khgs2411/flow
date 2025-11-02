# Flow Framework Skills Guide

Complete guide for creating effective Agent Skills for the Flow framework.

## Table of Contents

1. [Overview](#overview)
2. [Writing Effective Descriptions](#writing-effective-descriptions)
3. [When to Use allowed-tools](#when-to-use-allowed-tools)
4. [Single-File vs Multi-File Decision](#single-file-vs-multi-file-decision)
5. [Testing Skill Activation](#testing-skill-activation)
6. [Common Pitfalls](#common-pitfalls)
7. [Troubleshooting](#troubleshooting)

---

## Overview

Agent Skills are **model-invoked** capabilities - Claude autonomously decides when to use them based on your request and the Skill's description. This differs from slash commands which are **user-invoked** (you explicitly type `/command`).

**Key Principle**: Skills provide awareness and context, not authority. They help Claude understand Flow patterns while keeping the human as the driver.

---

## Writing Effective Descriptions

The `description` field (max 1024 characters) is **critical** for Skill discovery. It must include:

### Formula

1. **What the Skill does** (capability)
2. **When to use it** (specific trigger phrases users would say)
3. **What it provides** (outcome/guidance)

### Good Example

```yaml
description: Navigate Flow framework's multi-file architecture (DASHBOARD.md, PLAN.md, phase-N/task-M.md). Use when user asks "where am I", "what's next", "show status", "current work", or wants to understand project structure. Provides dashboard-first navigation guidance.
```

**Why it works**:
- ✅ Describes capability: "Navigate multi-file architecture"
- ✅ Lists specific triggers: "where am I", "what's next", "show status"
- ✅ States outcome: "dashboard-first navigation guidance"
- ✅ Within 1024 char limit

### Bad Example

```yaml
description: Helps with navigation
```

**Why it fails**:
- ❌ Vague: "Helps with" is too general
- ❌ No triggers: Claude won't know when to activate
- ❌ No outcome: What does it provide?

### Trigger Phrase Best Practices

**Include natural language users would actually say**:
- ✅ "what should I work on next?"
- ✅ "let's implement this"
- ✅ "review the plan"
- ❌ "navigate_flow_structure" (too technical)
- ❌ "use skill" (too meta)

**Cover variations**:
- "What's next?" / "What should I do next?" / "Where am I?"
- "Let's code" / "Time to implement" / "Start building"
- "Check the plan" / "Review status" / "Verify completion"

---

## When to Use allowed-tools

The `allowed-tools` field restricts which tools Claude can use when a Skill is active.

### When to Restrict (Read-Only Skills)

**Use `allowed-tools: Read, Grep, Glob` for**:
- **Navigation Skills**: Only read files, don't modify
- **Review Skills**: Inspect code/plans without changes
- **Status Skills**: Check state without altering it

**Example**:
```yaml
---
name: flow-navigator
description: Navigate Flow framework's multi-file architecture...
allowed-tools: Read, Grep, Glob
---
```

**Benefits**:
- Prevents accidental modifications
- Faster (no permission prompts for read operations)
- Clear intent (inspection only)

### When NOT to Restrict (Implementation Skills)

**Omit `allowed-tools` for**:
- **Planning Skills**: Need to create/modify files
- **Implementation Skills**: Need full tool access
- **Documentation Skills**: Need write access

**Example**:
```yaml
---
name: flow-implementer
description: Guide implementation workflow...
# No allowed-tools - needs write access
---
```

---

## Single-File vs Multi-File Decision

Use this decision tree:

### Use Single-File Template (`_TEMPLATE/`)

**When**:
- ✅ Skill fits in < 200 lines
- ✅ No supporting documentation needed
- ✅ Instructions are straightforward
- ✅ Few examples needed

**Examples**: flow-navigator, flow-reviewer (read-only, simple workflows)

### Use Multi-File Template (`_TEMPLATE-MULTI/`)

**When**:
- ✅ Skill requires > 200 lines
- ✅ Detailed reference documentation needed
- ✅ Multiple complex examples
- ✅ Templates or scripts to include

**Examples**: flow-planner (many templates), flow-architect (extensive guidance)

### Progressive Disclosure Pattern

Multi-file Skills use **progressive disclosure** - Claude only loads supporting files when needed:

```markdown
# SKILL.md (always loaded)
Quick start instructions here.

For details, see [REFERENCE.md](REFERENCE.md).  # Loaded only if user needs details

## Examples
See [EXAMPLES.md](EXAMPLES.md) for scenarios.  # Loaded only for examples
```

**Benefits**:
- Keeps context manageable
- Fast initial activation
- Deep dive available when needed

---

## Testing Skill Activation

After creating a Skill, test that it activates correctly:

### Step 1: Deploy Skill

```bash
# Build and deploy
./build-standalone.sh
./flow.sh
```

### Step 2: Test Trigger Phrases

Use **exact trigger phrases from description**:

```
# For flow-navigator
User: "What should I work on next?"
Expected: Skill activates, reads DASHBOARD.md, provides navigation

# For flow-planner
User: "Let's add a new task"
Expected: Skill activates, suggests /flow-task-add, shows task structure

# For flow-implementer
User: "Time to implement"
Expected: Skill activates, checks brainstorming, uses /flow-implement-start
```

### Step 3: Verify Activation

**Signs Skill activated correctly**:
- Claude references Skill content in response
- Appropriate guidance provided
- Correct tools used (respecting allowed-tools if set)

**Signs Skill did NOT activate**:
- Generic response without Skill context
- Wrong workflow suggested
- No mention of Flow patterns

### Step 4: Refine Description

If Skill doesn't activate:
1. Add more trigger phrase variations to description
2. Make description more specific
3. Ensure trigger phrases match how users actually talk
4. Test again

---

## Common Pitfalls

### 1. Vague Descriptions

**Problem**: `description: "For working with Flow"`
**Solution**: Be specific about what, when, and how

### 2. Missing Trigger Phrases

**Problem**: Description doesn't include phrases users would say
**Solution**: Add natural language triggers: "Use when user asks '...'"

### 3. Description Too Long

**Problem**: 2000 character description (exceeds 1024 limit)
**Solution**: Be concise, move details to SKILL.md body

### 4. Wrong allowed-tools Setting

**Problem**: Read-only Skill without allowed-tools restriction
**Solution**: Add `allowed-tools: Read, Grep, Glob` for inspection-only Skills

### 5. Duplicate Functionality

**Problem**: Skill overlaps with existing slash command
**Solution**: Skills complement commands, don't replace them. Skill = awareness, command = execution

### 6. Too Broad Scope

**Problem**: One Skill trying to do everything
**Solution**: Keep Skills focused on one capability, compose multiple Skills

### 7. Testing with Wrong Phrases

**Problem**: Testing with phrases not in description
**Solution**: Test with exact trigger phrases from description field

---

## Troubleshooting

### Skill Doesn't Activate

**Check**:
1. Description includes specific trigger phrases
2. Description under 1024 characters
3. YAML syntax valid (opening/closing `---`)
4. Name format: lowercase, hyphens only, max 64 chars
5. Skill file deployed to `.claude/skills/flow-*/SKILL.md`

**Test**:
```bash
# Verify Skill exists
ls ~/.claude/skills/flow-navigator/SKILL.md
# or
ls .claude/skills/flow-navigator/SKILL.md

# Check description
cat .claude/skills/flow-navigator/SKILL.md | head -10
```

### Skill Activates at Wrong Time

**Problem**: Skill triggers when it shouldn't

**Solution**: Make description more specific:
- Add context about when NOT to use
- Narrow trigger phrases
- Add distinguishing terms

### Multiple Skills Conflict

**Problem**: Two Skills activate simultaneously or wrong one activates

**Solution**: Differentiate descriptions:
- Use distinct trigger terms
- Add specific context (e.g., "for navigation" vs "for implementation")
- Reference different user intents

### allowed-tools Not Working

**Problem**: Skill still asks for write permissions despite `allowed-tools: Read, Grep, Glob`

**Check**:
1. YAML syntax correct (comma-separated tools)
2. Tool names match exactly: Read, Grep, Glob (capitalized)
3. Skill redeployed after changes

---

## Validation Checklist

Before deploying a new Skill:

- [ ] **Name**: Lowercase, hyphens only, max 64 chars
- [ ] **Description**: Max 1024 chars, includes what/when/outcome
- [ ] **Trigger phrases**: Specific natural language phrases included
- [ ] **allowed-tools**: Set for read-only Skills
- [ ] **Instructions**: Clear step-by-step guidance
- [ ] **Examples**: At least one concrete example
- [ ] **Testing**: Skill activates with trigger phrases
- [ ] **No conflicts**: Doesn't overlap with other Skills
- [ ] **Focused scope**: One capability, not too broad

---

## Examples from Flow Skills

### flow-navigator (Read-Only)

```yaml
name: flow-navigator
description: Navigate Flow framework's multi-file architecture (DASHBOARD.md, PLAN.md, phase-N/task-M.md). Use when user asks "where am I", "what's next", "show status", "current work", or wants to understand project structure. Provides dashboard-first navigation guidance. Read-only access.
allowed-tools: Read, Grep, Glob
```

### flow-implementer (Full Access)

```yaml
name: flow-implementer
description: Guide implementation workflow using Flow framework. Use when user says "implement", "let's code", "start building", "time to write code", or is ready to execute action items. Enforces pre-implementation gate (brainstorming must be complete), guides use of /flow-implement-start and /flow-implement-complete commands, tracks action item completion.
# No allowed-tools - needs write access
```

### flow-reviewer (Read-Only)

```yaml
name: flow-reviewer
description: Review code and plan consistency using Flow framework. Use when user says "review", "verify", "check", "validate", or asks "is this complete". Validates status markers match actual state, checks for phantom tasks, ensures brainstorming complete before implementation. Read-only inspection using Read, Grep, Glob tools.
allowed-tools: Read, Grep, Glob
```

---

## References

- **Agent Skills Documentation**: https://docs.claude.com/en/docs/claude-code/skills
- **Agent Skills Best Practices**: https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices
- **Flow Framework**: framework/DEVELOPMENT_FRAMEWORK.md
- **Skills Templates**: framework/skills/_TEMPLATE/ and framework/skills/_TEMPLATE-MULTI/
