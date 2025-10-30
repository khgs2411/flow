# Flow Framework

**Iterative Design-Driven Development where humans drive, AI executes.**

_You make the decisions. AI implements within your framework. Context is never lost._

[![Version](https://img.shields.io/badge/version-1.3.0-blue.svg)](https://github.com/khgs2411/flow/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](#license)

---

## Philosophy

Flow is **not** AI autopilot. It's **human-in-loop development** that leverages AI as an execution engine, not a decision maker.

**The human drives. The AI executes.**

Traditional AI development: You prompt → Wait → Hope it works → Refactor when it doesn't.

Flow development: You design → AI implements → You verify → Iterate with preserved context.

### Why This Matters

Building with AI often fails because:

- **AI decides** architecture (leads to refactoring hell)
- **Context disappears** between sessions (AI forgets your design)
- **No iteration structure** (everything is a rewrite)
- **Decisions lack rationale** (why did we choose this?)

Flow fixes this by **putting you in control**:

```
You Brainstorm → Document Decisions → AI Implements → You Verify → Next Iteration
```

Everything lives in `.flow/PLAN.md` - your design, your decisions, your rationale. The AI reads it, follows it, and never loses context.

---

## How It Works

### Human vs AI Responsibilities

**👤 You (Human)**:

- Design the architecture
- Make technical decisions
- Define iterations
- Document rationale
- Verify implementations

**🤖 AI**:

- Reads your framework
- Follows your patterns
- Implements your decisions
- Asks when unclear
- Never decides architecture

### The File Structure

Flow separates your workspace from AI reference files:

```
your-project/
├── .claude/commands/        # 25 slash commands (AI helpers)
│   ├── flow-blueprint.md
│   ├── flow-brainstorm-start.md
│   └── ...
│
└── .flow/
    ├── 👤 YOUR WORKSPACE (you own these)
    │   ├── PLAN.md          # Your design document
    │   ├── DASHBOARD.md     # Your progress tracker
    │   └── phase-*/task-*.md # Your detailed iterations
    │
    └── 🤖 AI REFERENCE (read-only templates)
        └── framework/
            ├── DEVELOPMENT_FRAMEWORK.md  # Complete methodology
            ├── SLASH_COMMANDS.md         # Command definitions
            └── examples/                 # Reference examples
```

**Key principle**: You control `.flow/PLAN.md` and task files. AI reads `framework/` for patterns but never decides your architecture.

---

## Quick Start

### 1. Install Flow (30 seconds)

```bash
cd /path/to/your/project
```

```bash
# Download and run
curl -O https://raw.githubusercontent.com/khgs2411/flow/master/flow.sh
chmod +x flow.sh && ./flow.sh
```

```bash
# Rerun to update
curl -O https://raw.githubusercontent.com/khgs2411/flow/master/flow.sh
chmod +x flow.sh && ./flow.sh --force
```

### 2. Create Your First Plan

**For new features:**

```bash
/flow-blueprint "Real-time chat with WebSocket, Redis pub/sub, and message history"
```

AI generates structured plan. **You review and adjust the architecture.**

### 3. Brainstorm Before Code

```bash
/flow-brainstorm-start "WebSocket vs SSE, Redis pub/sub architecture, message persistence strategy"
```

AI presents decision points. **You discuss and decide together.**

### 4. AI Implements Your Design

```bash
/flow-implement-start
```

AI codes based on **your documented decisions**, not its assumptions.

---

## Core Workflow

### 1. Design Phase (You Lead)

```bash
/flow-blueprint "Payment Gateway Integration"
```

- You define requirements
- You set constraints
- You outline phases
- AI structures the plan

### 2. Brainstorming (Collaborative)

```bash
/flow-brainstorm-start "Payment flow, webhook security, retry strategy"
/flow-next-subject  # Discuss each decision point
```

AI presents options, **you choose**:

```markdown
### Subject: Payment Flow Architecture ✅

**Decision**: Two-phase commit (reserve → capture)

**Rationale** (YOUR reasoning):

- Prevents double-charging on network failures
- Enables fraud checks between reserve and capture
- Industry standard (Amazon, Shopify)

**Action Items** (for AI to implement):

- [ ] Create PaymentIntent on checkout
- [ ] Implement reserve endpoint
- [ ] Implement capture endpoint
```

### 3. Implementation (AI Executes)

```bash
/flow-implement-start
```

AI implements **your design decisions**, following action items from brainstorming.

### 4. Verification (You Confirm)

```bash
/flow-implement-complete
```

You verify the implementation matches your design.

---

## The Iteration Structure

**"Build the skeleton first, then add flesh."** — Flow Framework

### Progressive Refinement

Flow uses a body-building metaphor for iterations:

- **V1 - Skeleton**: Basic structure, happy path only
- **V2 - Veins**: Core data flow, error handling
- **V3 - Flesh**: Edge cases, optimization
- **V4 - Fibers**: Polish, performance tuning

**Why this works**: You validate the architecture before adding complexity. No big-bang rewrites.

### Hierarchy

```
PHASE (Testing, Implementation, Deployment)
  └── TASK (User Auth, API Layer)
      └── ITERATION (Skeleton, Error Handling)
          ├── BRAINSTORM (Design decisions)
          └── IMPLEMENTATION (Coding)
```

### Status Tracking

- `⏳ PENDING` - Not started
- `🚧 IN PROGRESS` - Working now
- `🎨 READY` - Design complete, ready to code
- `✅ COMPLETE` - Done and verified

---

## Key Features

### Context Preservation

**Problem**: AI forgets your design between sessions.

**Solution**: Everything in `.flow/PLAN.md`. Any AI (or human) can resume instantly.

### Rationale Documentation

**Problem**: Code shows WHAT, not WHY.

**Solution**: Every decision documented with reasoning during brainstorming.

```markdown
**Decision**: Use PostgreSQL, not MongoDB

**Rationale**:

- Strong ACID guarantees for financial data
- Better complex query support for reporting
- Team has 5 years PostgreSQL experience
```

### Pre-Implementation Tasks

**Problem**: Refactoring discovered mid-implementation derails work.

**Solution**: Identify blockers during brainstorming, handle BEFORE coding.

```markdown
### Pre-Implementation Tasks

#### Task 1: Refactor Legacy Payment Module

**Why**: Current code tightly coupled to Stripe
**What**: Extract PaymentProvider interface

- [ ] Create interface
- [ ] Implement StripeProvider
- [ ] Update controllers
```

---

## Slash Commands

Flow provides 25 slash commands for AI-assisted workflow:

**Planning** (3): `/flow-blueprint`, `/flow-migrate`, `/flow-plan-update`

**Structure** (9): `/flow-phase-*`, `/flow-task-*`, `/flow-iteration-*`

**Brainstorming** (5): `/flow-brainstorm-start`, `/flow-next-subject`, `/flow-brainstorm-complete`, etc.

**Implementation** (2): `/flow-implement-start`, `/flow-implement-complete`

**Navigation** (6): `/flow-status`, `/flow-next`, `/flow-summarize`, `/flow-verify-plan`, etc.

See [SLASH_COMMANDS.md](framework/SLASH_COMMANDS.md) for full reference.

---

## Using Without Slash Commands

**The methodology is framework-agnostic.** You can use Flow principles with any AI (ChatGPT, Gemini, etc.).

### Setup

First, get the framework reference files:

**Option 1: Clone the repository** (recommended)

```bash
git clone https://github.com/khgs2411/flow.git ~/flow-framework
```

**Option 2: Download framework folder only**

```bash
# Download the framework directory
curl -L https://github.com/khgs2411/flow/archive/refs/heads/master.zip -o flow.zip
unzip flow.zip "flow-master/framework/*"
mv flow-master/framework ~/flow-framework
rm -rf flow-master flow.zip
```

### Using the Framework

1. Use `~/flow-framework/examples/PLAN.md` as a template
2. Follow Phase → Task → Iteration hierarchy
3. Use status markers (`⏳ 🚧 ✅`)
4. Document decisions with rationale
5. Reference `~/flow-framework/SLASH_COMMANDS.md` for command patterns

**Example ChatGPT prompt**:

```
I'm using the Flow Framework for iterative development.

Please read ~/flow-framework/SLASH_COMMANDS.md and find
the /flow-brainstorm-start command instructions.

Follow those instructions to help me brainstorm
"WebSocket architecture decisions" for my project.
```

The AI will follow Flow patterns manually without slash command integration.

---

## Real-World Example

**Building a payment gateway:**

**1. You design** (via `/flow-blueprint`):

```markdown
## Phase 1: Core Payment Flow

### Task 1: Stripe Integration

- Iteration 1: Basic charge flow (skeleton)
- Iteration 2: Error handling (veins)
- Iteration 3: Webhooks (flesh)
```

**2. You brainstorm** (via `/flow-brainstorm-start`):

```markdown
### Subject: Charge Flow Architecture ✅

**Decision**: Two-phase commit (reserve → capture)

**Rationale** (you decide):

- Prevents double-charging
- Enables fraud checks
- Industry standard

**Action Items** (AI implements):

- [ ] PaymentIntent API integration
- [ ] Reserve endpoint
- [ ] Capture endpoint
```

**3. AI implements** your design:

```bash
/flow-implement-start
```

AI creates the code following YOUR documented decisions.

**4. You verify**:

```bash
/flow-implement-complete
```

Confirm implementation matches your design.

---

## Why Flow Over Alternatives?

| Approach      | Who Decides | Context Preserved | Iteration Structure | AI Leveraged |
| ------------- | ----------- | ----------------- | ------------------- | ------------ |
| **Flow**      | Human       | Yes (PLAN.md)     | Built-in (V1/V2/V3) | ✅ Execution |
| **Spec-Kit**  | Human       | In tests          | Manual              | ❌ No        |
| **Agile**     | Team        | In tickets        | Sprint-based        | ❌ No        |
| **Cowboy AI** | AI          | Lost per session  | None                | ❌ Decides   |

**Flow's unique value**: Human-driven design + AI-powered execution + mandatory context preservation.

---

## Architecture (For Framework Developers)

### Three-Part System

1. **`flow.sh`** (~150KB)

   - Self-contained deployment script
   - All framework content embedded (no external dependencies)
   - This is what users download

2. **`framework/`** (source files)

   - `DEVELOPMENT_FRAMEWORK.md` - Complete methodology (3,900 lines)
   - `SLASH_COMMANDS.md` - All command definitions
   - `examples/` - Reference examples

3. **Build system**
   - `build-standalone.sh` - Generates `flow.sh` from sources
   - Embeds framework docs via heredocs

### Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guide.

**Quick start**:

```bash
# Edit framework source
vim framework/DEVELOPMENT_FRAMEWORK.md

# Rebuild distribution
./build-standalone.sh

# Test
cd /test-project && ~/flow/flow.sh --force
```

---

## Resources

- **📖 Methodology**: [DEVELOPMENT_FRAMEWORK.md](framework/DEVELOPMENT_FRAMEWORK.md)
- **📝 Examples**: [framework/examples/](framework/examples/)
- **⚙️ Commands**: [SLASH_COMMANDS.md](framework/SLASH_COMMANDS.md)
- **🤝 Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **🐛 Issues**: [GitHub Issues](https://github.com/khgs2411/flow/issues)

---

## Credits

**Created by**: [Liad Goren](https://github.com/khgs2411)

**Philosophy**: Domain-Driven Design + Agile + Extreme Programming

**AI Partner**: Claude (Anthropic)

**Inspired by**: Real-world AI-assisted development on complex RPG systems, revealing what actually works when humans and AI collaborate.

---

## License

MIT License - Free for personal and commercial use.

---

<div align="center">

**"Build the skeleton first, then add flesh."**

_— Flow Framework_

[⬆ Back to Top](#flow-framework)

</div>
