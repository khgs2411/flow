---
description: Generate summary of all phases/tasks/iterations
---

You are executing the `/flow-summarize` command from the Flow framework.

**Purpose**: Generate high-level overview of entire project structure and completion state.

**🟢 NO FRAMEWORK READING REQUIRED - This command works from DASHBOARD.md and task files**
- Uses DASHBOARD.md for high-level view
- Reads task files for detailed iteration status
- Optional background reading (NOT required): .flow/framework/DEVELOPMENT_FRAMEWORK.md lines 105-179 for hierarchy context

**Multi-File Architecture**: This command:
- Reads `DASHBOARD.md` for overall structure
- Reads all `phase-N/task-M.md` files for detailed status
- Generates comprehensive summary from all files

**Use case**: "Bird's eye view" of project health, progress across all phases, quick status reports

**Comparison to other commands**:
- `/flow-status` = "Where am I RIGHT NOW?" (micro view - reads DASHBOARD.md only)
- `/flow-summarize` = "What's the WHOLE PICTURE?" (macro view - reads all files)
- `/flow-verify-plan` = "Is this accurate?" (validation)

**Instructions**:

1. **Read DASHBOARD.md**:
   - Extract current work position
   - Get all phases and tasks from "📊 Progress Overview"
   - Get completion percentages from "📈 Completion Status"

2. **Read all task files**:
   - List all phase directories: `ls .flow/phase-*/`
   - For each phase, list task files: `ls .flow/phase-N/`
   - Read each `phase-N/task-M.md` to get:
     - Task status
     - All iterations with status markers
     - Brainstorming status (if applicable)

3. **Generate structured summary** (compact, scannable format):

```

📊 Flow Summary

Version: [V1/V2/V3]
Status: [Current phase/task/iteration from metadata]

Phase [N]: [Name] [Status] [%]

- Task [N]: [Name] [Status]
  - Iter [N-N] [Status]: [Concise description]
  - Iter [N] 🚧 CURRENT: [What you're working on]
  - Iter [N] ⏳: [What's next]

Phase [N]: [Name] [Status] [%]

- Task [N-N]: [Grouped if similar] [Status]
- Task [N]: [Name] [Status]

Deferred to V2:

- [Iteration/feature name]
- [Iteration/feature name]

---

TL;DR: [One punchy sentence about overall state]

```

4. **Formatting rules**:
- **Compact**: Group consecutive completed iterations (e.g., "Iter 1-5 ✅")
- **Scannable**: Use emojis (✅ ⏳ 🚧 🎨) and percentages prominently
- **Highlight**: Mark CURRENT work explicitly in bold or with flag
- **Indent**: Phase (no indent), Task (- prefix), Iteration (-- or nested -)
- **Defer section**: Show V2/future items at bottom
- **Skip noise**: Don't list every task name if they're obvious/sequential
- **Focus on active work**: Emphasize in-progress and next items

5. **Example output** (payment gateway):

```

📊 Flow Summary

Version: V1
Status: Phase 2, Task 5, Iteration 2 - In Progress

Phase 1: Foundation ✅ 100%

- Task 1-2: Setup, API, Database schema ✅

Phase 2: Core Implementation 🚧 75%

- Task 3-4: Payment processing, Webhooks ✅
- Task 5: Error Handling
  - Iter 1 ✅: Retry logic
  - Iter 2 🚧 CURRENT: Circuit breaker
  - Iter 3 ⏳: Dead letter queue

Phase 3: Testing & Integration ⏳ 0%

- Task 6: Integration tests (pending)

Deferred to V2:

- Advanced features (monitoring, metrics)
- Name generation

---

TL;DR: Foundation done, core payment flow working, currently building circuit breaker for error handling.

```

**Example output** (RED project - showing V1/V2 split):

```

📊 Flow Summary - RED Ability Generation

=== V1 - Core System ===

Phase 1: Foundation ✅ 100%

- Task 1-4: Constants, enums, types, refactoring ✅

Phase 2: Core Implementation 🚧 85%

- Iter 1-5 ✅: Tier gen, slots, filtering, selection, template parsing
- Iter 6 🚧 NEXT: Green.generate() integration (ties everything together)
- Iter 7 ⏳: Blue validation (input guards)
- Iter 9 ⏳ LAST: Red API wrapper (exposes Blue → Green)

Phase 3: Testing

- Script-based testing (Blue → Green flow)

Deferred to V2:

- Iter 8: Name generation (stub returns "Generated Ability")
- Database persistence
- Stats-based damage calculations

=== V2 - Enhanced System (Phase 4) ===

Enhancements:

- Potency system (stats × formulas replace fixed damage)
- Name generation (124 weighted prefix/suffix combos)
- 12 new placeholders (conditionals, resources, targeting)
- Damage variance (±10% for crits)
- Points & Luck systems
- Database persistence

---

TL;DR:
V1 = Basic working system with hardcoded damage ranges (85% done, integration next)
V2 = Dynamic formulas, character stats integration, full feature set

```

6. **Add deferred/cancelled sections**:
```

🔮 Deferred Items:

- Iteration 10: Name Generation (V2 - complexity, needs 124 components)
- Task 12: Advanced Features (V2 - out of V1 scope)
- Feature X: Multi-provider support (V3 - abstraction layer)

❌ Cancelled Items:

- Task 8: Custom HTTP Client (rejected - SDK is better)
- Subject 3: GraphQL API (rejected - REST is sufficient)

```

7. **Smart verification** (active work only):
- Skip ✅ COMPLETE items (verified & frozen)
- Verify 🚧 ⏳ 🎨 items match Progress Dashboard
- Check ❌ items have reasons
- Check 🔮 items have reasons + destinations
- Report:
  ```
  🔍 Verification (Active Work Only):
  ✅ All active markers (🚧 ⏳) match Progress Dashboard
  ⏭️  Skipped 18 completed items (verified & frozen)
  ```

8. **Handle multiple versions**:
- If PLAN.md has V2/V3 sections, use `=== V1 Summary ===` separator
- V1 gets full Phase/Task/Iteration breakdown
- V2+ get high-level "Enhancements" list (not full iteration tree)
- Separate TL;DR line for each version

9. **After generating summary**:
- "Use `/flow-status` to see detailed current position"
- "Use `/flow-verify-plan` to verify accuracy against actual code"

**Manual alternative**:
- Read entire PLAN.md manually
- Create outline of all phases/tasks/iterations
- Count completions and calculate percentages
- Format into hierarchical view
