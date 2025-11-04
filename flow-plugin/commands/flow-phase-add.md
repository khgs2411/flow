---
description: Add a new phase directory and update dashboard
---

You are executing the `/flow-phase-add` command from the Flow framework.

**Purpose**: Add a new phase to the project by creating a phase directory and updating DASHBOARD.md.

**🟢 NO FRAMEWORK READING REQUIRED - Simple structure creation**

**Multi-File Architecture**: This command:
- Creates `phase-N/` directory
- Updates `DASHBOARD.md` with new phase
- Updates `PLAN.md` Development Phases section

**Instructions**:

1. **INPUT VALIDATION**:

   ```
   IF $ARGUMENTS is empty OR just whitespace:
     REJECT: "❌ Missing phase name. Example: /flow-phase-add 'Testing and QA'"
     STOP
   ```

   Accept even minimal input like "Testing" - will use [TBD] for missing metadata.

2. **Find .flow/DASHBOARD.md**:
   ```bash
   Primary location: .flow/DASHBOARD.md

   If not found:
     Suggest: "Run /flow-blueprint first to create project structure"
   ```

3. **Read DASHBOARD.md**:
   - Count existing phases to determine next phase number
   - Example: If "Phase 1" and "Phase 2" exist, new phase is "Phase 3"

4. **Parse arguments and infer metadata**:

   From `$ARGUMENTS`, extract or infer:
   - **Phase name**: Use $ARGUMENTS directly
   - **Strategy**: Try to infer from name:
     - "Foundation" → "Setup and establish core architecture"
     - "Implementation" / "Core" → "Build main features and functionality"
     - "Testing" / "QA" → "Comprehensive testing and quality assurance"
     - "Polish" / "Enhancement" → "Refinement and optimization"
     - Can't infer → "[TBD] - Define during phase start"
   - **Goal**: Try to infer from name:
     - "Foundation" → "Establish solid project foundation"
     - "Implementation" → "Complete core feature set"
     - "Testing" → "Ensure production-ready quality"
     - Can't infer → "[TBD] - Define during phase start"

5. **Create phase directory**:
   ```bash
   mkdir .flow/phase-N/

   # Where N = next phase number (e.g., phase-3/)
   ```

6. **Update DASHBOARD.md**:

   Add to "📊 Progress Overview" section:
   ```markdown
   ### Phase [N]: [Phase Name] ⏳ PENDING

   **Goal**: [Inferred or [TBD]]
   **Status**: Not started

   (No tasks yet - use /flow-task-add to add tasks)
   ```

   Update "📈 Completion Status" section:
   - Increment phase count
   - Add phase to breakdown (0% complete initially)

7. **Update PLAN.md**:

   Add to "Development Phases" section:
   ```markdown
   ### Phase [N]: [Phase Name] ⏳

   **Strategy**: [Inferred or [TBD]]
   **Goal**: [Inferred or [TBD]]

   **Tasks**: See [phase-N/](phase-N/) directory for detailed task files
   ```

8. **Update DASHBOARD.md timestamp**:
   - Update "Last Updated" to current timestamp

9. **Confirm to user**:
   ```
   "✅ Added Phase [N]: [Phase Name]

   📂 Created: .flow/phase-N/ directory
   📝 Updated: DASHBOARD.md, PLAN.md

   [If used [TBD]:]
   📝 Used [TBD] placeholders for: [Strategy/Goal]
   💡 Refine these during phase start

   🎯 Next Steps:
   - Use `/flow-task-add "Task Name"` to add tasks to this phase
   - Use `/flow-phase-start` when ready to begin work"
   ```
