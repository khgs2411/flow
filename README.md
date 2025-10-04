# Flow Framework

**AI-in-the-loop iterative development that preserves context and prevents refactoring hell.**

_Domain-Driven Design meets Agile philosophy. You design the architecture and iterations. AI executes within your framework. Context never gets lost._

[![Version](https://img.shields.io/badge/version-1.1.4-blue.svg)](https://github.com/khgs2411/flow/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](#license)

---

## Why Flow?

Building complex features with AI often leads to:

- **Context loss** across sessions
- **Refactoring cycles** from poor upfront design
- **Missed edge cases** discovered too late
- **Disconnected implementations** that don't fit together

Flow solves this by enforcing **structured planning before coding**:

```
Brainstorm → Design → Iterate → Implement → Verify
```

Everything is preserved in `.flow/PLAN.md` - a living document that survives across sessions, AI models, and developers.

---

## Quick Start

### Install Flow (30 seconds)

**Option 1: Direct Download** (no git required)

```bash
cd /path/to/your/project
```

```bash
curl -O https://raw.githubusercontent.com/khgs2411/flow/master/flow.sh
chmod +x flow.sh && ./flow.sh
```

**Option 2: Clone & Run**

```bash
git clone https://github.com/khgs2411/flow.git ~/flow-framework
cd /path/to/your/project
~/flow-framework/flow.sh
```

**What gets installed:**

```
your-project/
├── .claude/commands/    # 28 slash commands
│   ├── flow-blueprint.md
│   ├── flow-brainstorm-start.md
│   └── ...
└── .flow/               # Framework docs
    ├── DEVELOPMENT_FRAMEWORK.md
    └── EXAMPLE_PLAN.md
```

### Create Your First Plan

**For new projects:**

```bash
/flow-blueprint "Real-time collaborative text editor with conflict resolution"
```

**For existing projects:**

```bash
/flow-migrate existing-plan.md
```

**Start your first iteration:**

```bash
/flow-brainstorm-start "CRDT vs OT, WebSocket architecture, offline support"
/flow-next-subject  # Discuss and resolve each subject
/flow-brainstorm-review  # Generate iterations and pre-tasks
/flow-implement-start  # Begin coding
```

---

## How It Works

### The Flow Hierarchy

```
PHASE (Testing, Implementation, Polish)
  └── TASK (Authentication, API Design)
      └── ITERATION (Skeleton, Error Handling, Optimization)
          ├── BRAINSTORM (Design before code)
          │   └── SUBJECTS (Key decisions to make)
          └── IMPLEMENTATION (Code with action items)
```

### Status Markers Track Progress

- `⏳ PENDING` - Not started
- `🚧 IN PROGRESS` - Currently working
- `🎨 READY` - Brainstorming complete, ready to code
- `✅ COMPLETE` - Finished and verified
- `❌ CANCELLED` - Abandoned
- `🔮 FUTURE` - Deferred to later version

### The Workflow

1. **Blueprint** - Create structured plan from requirements
2. **Brainstorm** - Design decisions before writing code
3. **Resolve Subjects** - Capture WHY for each decision
4. **Review** - Generate iterations and identify pre-tasks
5. **Implement** - Code with tracked action items
6. **Verify** - Ensure implementation matches plan
7. **Iterate** - Repeat for next feature increment

---

## Key Features

### 🧠 Brainstorming Sessions

Document design decisions with rationale BEFORE coding. Prevents refactoring hell.

```markdown
### Subject: API Authentication Strategy ✅

**Decision**: Use JWT with refresh tokens

**Rationale**:

- Stateless authentication scales better
- Refresh tokens provide security + UX balance
- Industry standard with mature libraries

**Action Items**:

- [ ] Implement JWT generation (jsonwebtoken)
- [ ] Create refresh token rotation
- [ ] Add token blacklist for logout
```

### 📋 Pre-Implementation Tasks

Handle blockers discovered during brainstorming:

```markdown
### Pre-Implementation Tasks

#### ⏳ Task 1: Refactor Legacy Auth Module

**Why**: Current auth is tightly coupled to session storage
**What**: Extract to AuthService interface

- [ ] Create AuthService interface
- [ ] Implement JWTAuthService
- [ ] Update controllers to use interface
```

### 🎯 Progress Dashboard

Always-visible navigation for complex projects:

```markdown
## Progress Dashboard

**Current Work**:

- **Phase**: [Phase 2 - Implementation](#phase-2-implementation) 🚧
- **Task**: [Task 3 - API Layer](#task-3-api-layer) 🚧
- **Iteration**: [Iteration 5 - Error Handling](#iteration-5-error-handling) 🚧

**Overall Progress**: 47% (14/30 iterations complete)
```

### 📦 Backlog Management

Move pending tasks out of active plan for token efficiency:

```bash
/flow-backlog-add 14-18  # Move tasks 14-18 to backlog
/flow-backlog-view       # See what's in backlog
/flow-backlog-pull 16    # Pull task 16 back to active plan
```

### ✅ Plan Verification

Ensure your plan matches reality:

```bash
/flow-verify-plan  # Checks completed items exist in codebase
```

---

## Framework Philosophy

### The Human Body Metaphor

**Skeleton → Veins → Flesh → Fibers**

Like building a body, you start with structure and progressively add complexity:

1. **Skeleton** (V1) - Basic structure, happy path only
2. **Veins** (V1) - Core data flow and connections
3. **Flesh** (V2) - Error handling, edge cases
4. **Fibers** (V3) - Performance, optimization, polish

**Why this works:**

- Prevents premature optimization
- Forces you to prove the architecture before adding complexity
- Each iteration builds on validated foundations
- Natural scope boundaries (V1/V2/V3)

### Core Principles

**1. Plan Before Code**
Design decisions documented upfront reduce refactoring by 80%.

**2. Context Preservation**
`.flow/PLAN.md` is the single source of truth. Anyone (human or AI) can resume work instantly.

**3. Explicit Over Implicit**
Every decision has documented rationale. No "we think this works" - only "we chose X because Y".

**4. Progressive Disclosure**
Focus on what's needed NOW. Defer complexity to later iterations.

**5. Brainstorm Before Implement**
Thinking time is cheaper than refactoring time.

---

## Slash Commands (28 total)

### Planning (3)

- `/flow-blueprint` - Create new plan from scratch
- `/flow-migrate` - Convert existing PRD/PLAN/TODO to Flow format
- `/flow-plan-update` - Update plan to latest framework structure

### Phase Management (3)

- `/flow-phase-add` - Add new phase
- `/flow-phase-start` - Mark phase in progress
- `/flow-phase-complete` - Complete phase

### Task Management (3)

- `/flow-task-add` - Add new task
- `/flow-task-start` - Mark task in progress
- `/flow-task-complete` - Complete task

### Iteration Workflow (8)

- `/flow-iteration-add` - Add new iteration
- `/flow-brainstorm-start` - Begin brainstorming session
- `/flow-brainstorm-subject` - Add subject to discussion
- `/flow-next-subject` - Discuss and resolve next subject
- `/flow-brainstorm-review` - Review decisions, create follow-up work
- `/flow-brainstorm-complete` - Finalize brainstorming
- `/flow-implement-start` - Begin implementation
- `/flow-implement-complete` - Complete iteration

### Backlog Management (3)

- `/flow-backlog-add` - Move tasks to backlog
- `/flow-backlog-view` - Show backlog contents
- `/flow-backlog-pull` - Pull task back to active plan

### Navigation & Status (5)

- `/flow-status` - Current position (micro view)
- `/flow-summarize` - Full project overview (macro view)
- `/flow-verify-plan` - Verify plan matches codebase
- `/flow-next` - Smart helper (suggests next action)
- `/flow-rollback` - Undo last plan change

### Plan Maintenance (3)

- `/flow-plan-split` - Archive old tasks to reduce file size
- `/flow-next-iteration` - Show next iteration details
- `/flow-compact` - Generate handoff report for new AI session

---

## Real-World Example

**Scenario**: Building a payment gateway integration

### 1. Create Blueprint

```bash
/flow-blueprint "Stripe Payment Gateway Integration

Requirements:
- Credit card processing with 3D Secure
- Webhook handling for async notifications
- Retry logic: 3 attempts, exponential backoff

Constraints:
- Express.js backend
- Max 2-second response time
- PCI DSS compliant

Testing:
- Stripe test mode simulation
- Mock webhook events
"
```

**Result**: Structured plan with phases, tasks, iterations

### 2. Brainstorm First Iteration

```bash
/flow-brainstorm-start "Payment flow architecture, webhook security, retry strategy, error handling"
```

**AI creates**:

```markdown
### Subjects to Discuss

1. ⏳ Payment Flow Architecture
2. ⏳ Webhook Security & Verification
3. ⏳ Retry Strategy & Idempotency
4. ⏳ Error Handling & User Feedback
```

### 3. Resolve Each Subject

```bash
/flow-next-subject
```

**AI presents subject 1, you discuss together, AI captures:**

```markdown
### Subject 1: Payment Flow Architecture ✅

**Decision**: Two-phase commit pattern (reserve → capture)

**Rationale**:

- Prevents double-charging on network failures
- Enables fraud checks between reserve and capture
- Stripe native support via PaymentIntent API
- Standard e-commerce pattern (Amazon, Shopify use this)

**Action Items**:

- [ ] Create PaymentIntent on checkout initiation
- [ ] Implement reserve endpoint (confirm payment)
- [ ] Implement capture endpoint (fulfill order)
- [ ] Add timeout for abandoned reservations (15min TTL)
```

**Repeat for subjects 2-4...**

### 4. Review & Create Work

```bash
/flow-brainstorm-review
```

**AI analyzes decisions and suggests**:

- 3 new iterations for Phase 1
- 2 pre-implementation tasks (refactor existing payment module)

### 5. Implement

```bash
/flow-implement-start
```

**AI creates**:

```markdown
### Implementation

**Action Items** (from brainstorming):

- [ ] Create PaymentIntent on checkout initiation
- [ ] Implement reserve endpoint (confirm payment)
- [ ] Implement capture endpoint (fulfill order)
- [ ] Add timeout for abandoned reservations (15min TTL)
- [ ] Implement webhook signature verification
- [ ] Add idempotency keys to API calls
- [ ] Create retry queue with exponential backoff
- [ ] Build error translation for user-friendly messages
```

You code, checking off items as you complete them.

### 6. Complete & Verify

```bash
/flow-implement-complete
```

**AI prompts for verification**:

```
Verification Notes:
- ✅ Tested reserve → capture flow with test cards
- ✅ Verified webhook signature validation
- ✅ Confirmed retry logic with network failure simulation
- ✅ All error cases return user-friendly messages
- ✅ Payment reservations auto-expire after 15min
```

**Iteration marked ✅ COMPLETE**

---

## Using Flow Without Slash Commands

**The methodology is the core, not the commands.**

You can use Flow with ANY AI (ChatGPT, Gemini, etc.) by manually following the patterns:

1. Copy `.flow/EXAMPLE_PLAN.md` as template
2. Follow the hierarchy: Phase → Task → Iteration
3. Use status markers: ⏳ 🚧 🎨 ✅
4. Document decisions with rationale
5. Reference `framework/SLASH_COMMANDS.md` for guidance

**Example prompt for ChatGPT**:

```
Read framework/SLASH_COMMANDS.md section '/flow-blueprint'
and execute those instructions for "User Authentication System"
```

The AI will follow the steps manually. You lose autocomplete but keep the full methodology.

---

## Architecture

### Three-Part System

1. **`flow.sh`** (~146KB single file)

   - Self-contained deployment script
   - All framework content embedded via heredocs
   - Zero external dependencies
   - This is what gets distributed

2. **`framework/`** (source files for development)

   - `DEVELOPMENT_FRAMEWORK.md` - Complete methodology (3,897 lines)
   - `EXAMPLE_PLAN.md` - Payment gateway reference (509 lines)
   - `SLASH_COMMANDS.md` - 28 command definitions

3. **Build system**
   - `build-standalone.sh` - Generates `flow.sh` from sources
   - Embeds all framework content into single distributable file

### For Framework Developers

**Edit framework**:

```bash
# Edit source files
vim framework/DEVELOPMENT_FRAMEWORK.md
vim framework/SLASH_COMMANDS.md

# Rebuild distribution
./build-standalone.sh

# Test in a project
cd /path/to/test-project
~/flow/flow.sh --force
```

**Release new version**:

```bash
./release.sh --patch   # 1.1.4 → 1.1.5
./release.sh --minor   # 1.1.4 → 1.2.0
./release.sh --major   # 1.1.4 → 2.0.0
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contributor guide.

---

## Key Design Decisions

### Why single-file distribution?

- **Portability** - Share one file, no dependencies
- **Reliability** - No network requests, no missing files
- **Simplicity** - Users just run `./flow.sh`

### Why separate source files?

- **Maintainability** - Edit markdown, not heredocs
- **Version Control** - Clean diffs on actual content
- **Development** - Use proper markdown editors

### Why brainstorm before code?

- **Prevents refactoring** - Design decisions upfront
- **Captures rationale** - WHY is preserved, not just WHAT
- **Async collaboration** - Team sees thought process

### Why pre-implementation tasks?

- **Real-world pattern** - Often need to refactor before new work
- **Explicit blockers** - No hidden dependencies
- **Brainstorm completeness** - Can't start coding until ready

---

## Comparison to Other Approaches

| Approach          | Planning           | Context              | Iteration           | AI Guided |
| ----------------- | ------------------ | -------------------- | ------------------- | --------- |
| **Flow**          | Structured upfront | Preserved in PLAN.md | Built-in (V1/V2/V3) | ✅ Yes    |
| **Spec-Kit**      | Test-driven        | In tests             | Manual              | ❌ No     |
| **Agile**         | Sprint planning    | In tickets           | Sprint-based        | ❌ No     |
| **Waterfall**     | All upfront        | In docs              | None                | ❌ No     |
| **Cowboy Coding** | None               | Developer's head     | Ad-hoc              | ❌ No     |

**Flow's unique value**: AI-native workflow with mandatory context preservation.

---

## What's New

**Latest**: v1.1.4 - See [GitHub Releases](https://github.com/khgs2411/flow/releases) for full changelog.

---

## Resources

- **📖 Full Methodology**: [DEVELOPMENT_FRAMEWORK.md](framework/DEVELOPMENT_FRAMEWORK.md)
- **📝 Example Plan**: [EXAMPLE_PLAN.md](framework/EXAMPLE_PLAN.md)
- **⚙️ Command Reference**: [SLASH_COMMANDS.md](framework/SLASH_COMMANDS.md)
- **🤝 Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **🐛 Issues**: [GitHub Issues](https://github.com/khgs2411/flow/issues)

---

## Credits

**Created by**: [Liad Goren](https://github.com/khgs2411)

**Inspired by**: Real-world experience building a complex RPG skill generation system. The patterns emerged organically through AI-assisted development, revealing what actually works when AI and humans collaborate on complex software.

**Philosophy**: Domain-Driven Design + Agile + Extreme Programming

**AI Partner**: Claude (Anthropic) via Claude Code

---

## License

MIT License - Free for personal and commercial use.

Attribution appreciated but not required.

---

<div align="center">

**"Build the skeleton first, then add flesh."**

_— Flow Framework_

[⬆ Back to Top](#flow-framework)

</div>
