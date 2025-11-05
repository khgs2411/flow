You are executing the `/flow-compact` command from the Flow framework.

**Purpose**: Generate comprehensive conversation report for context transfer to new AI instance.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from plan files**

- Generates comprehensive report using DASHBOARD.md, PLAN.md, and task file content
- Uses `/flow-status` dashboard-first logic for current position
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 2327-2362 for context preservation patterns

**Multi-File Architecture**: This command reads:
- `DASHBOARD.md` - Current work location and progress overview
- `PLAN.md` - Architecture, testing strategy, constraints (static context)
- `phase-N/task-M.md` - Current task file with iterations, brainstorming, implementation

**Context**:

- **Framework Guide**: .flow/framework/DEVELOPMENT_FRAMEWORK.md (auto-locate in `.claude/`, project root, or `~/.claude/flow/`)
- **Working Files**: .flow/DASHBOARD.md, .flow/PLAN.md, .flow/phase-N/task-M.md
- **Use case**: Before compacting conversation or starting new AI session - ensures zero context loss

**Instructions**:

1. **Read DASHBOARD.md**:
   - Find "📍 Current Work" section for current phase/task/iteration
   - Read "📊 Progress Overview" for completed work
   - Read "🎯 Next Actions" for pending items
   - Read "📝 Recent Activity" for conversation history
   - Read "💡 Key Decisions This Week" for important context

2. **Read PLAN.md**:
   - Extract "## 🎯 Project Goal" for feature overview
   - Read "## 🏗️ Architecture" section for technical context
   - Read "## 🧪 Testing Strategy" for quality requirements
   - Read "## 📋 Constraints" for limitations
   - Read "## 🎓 Learning Goals" for educational objectives

3. **Read current task file** (from DASHBOARD.md pointers):
   - Locate `.flow/phase-N/task-M.md`
   - Read "Task Overview" section (purpose, dependencies, scope)
   - Read current iteration brainstorming subjects (decisions, rationale)
   - Read "Implementation - Iteration [N]" section (action items, progress)
   - Read "Task Notes" section (discoveries, decisions, references)

4. **Generate comprehensive report covering**:

   **Current Work Context**:

   - What feature/task are we working on? (from DASHBOARD.md)
   - What phase/task/iteration are we in? (with status)
   - What was the original goal? (from PLAN.md + task Purpose)

   **Conversation History**:

   - What decisions were made during brainstorming? (from task file subjects)
   - What subjects were discussed and resolved? (with resolution types)
   - What pre-implementation tasks were identified and completed? (from task file)
   - What action items were generated? (from Implementation section)

   **Implementation Progress**:

   - What has been implemented so far? (from task file Implementation Notes)
   - What files were created/modified? (from Files Modified section)
   - What verification was done? (from Verification section)
   - What remains incomplete? (unchecked action items)

   **Challenges & Solutions**:

   - What blockers were encountered? (from Implementation Notes)
   - How were they resolved? (from Pre-Implementation Tasks or notes)
   - What design trade-offs were made? (from brainstorming rationale)

   **Next Steps**:

   - What is the immediate next action? (from DASHBOARD.md "🎯 Next Actions")
   - What are the pending action items? (from current iteration)
   - What should the next AI instance focus on?

   **Important Context**:

   - Any quirks or special considerations (from Task Notes)
   - Technical constraints (from PLAN.md + Task Overview dependencies)
   - User preferences or decisions that must be preserved (from decisions)

5. **Report format**:
```

# Context Transfer Report

## Generated: [Date/Time]

## Current Status

[Phase/Task/Iteration with status markers]

## Feature Overview

[What we're building and why]

## Conversation Summary

[Chronological summary of discussions and decisions]

## Implementation Progress

[What's done, what's in progress, what's pending]

## Key Decisions & Rationale

[Critical decisions made with reasoning]

## Files Modified

[List with brief description of changes]

## Challenges Encountered

[Problems and how they were solved]

## Next Actions

[Immediate next steps for new AI instance]

## Critical Context

[Must-know information for continuation]

```

5. **Important guidelines**:
- **Do NOT include generic project info** (tech stack, architecture overview, etc.)
- **Focus ENTIRELY on the feature at hand** and this conversation
- **Do NOT worry about token output length** - comprehensive is better than brief
- **Include WHY, not just WHAT** - decisions need context
- **Be specific** - reference exact file names, function names, line numbers
- **Preserve user preferences** - if user made specific choices, document them

6. **After generating report**:
- "Context transfer report generated. Copy this report to a new AI session to continue work with zero context loss."
- "Use `/flow-verify-plan` before starting new session to ensure plan files (DASHBOARD.md, task files) are synchronized."

**Manual alternative**:
- Read entire conversation history manually
- Read DASHBOARD.md for current status
- Read current task file for detailed context
- Read PLAN.md for architectural constraints
- Summarize key points, decisions, and progress
- Document in separate notes file
