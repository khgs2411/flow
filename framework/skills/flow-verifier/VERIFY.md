# Verification Scripts

Quick reference for common Flow framework verification tasks using bash commands.

> **Note**: This is a Level 3 resource for the flow-reviewer Skill. See [SKILL.md](SKILL.md) for complete review guidance.

## Status Consistency Checks

### Find All IN PROGRESS Items
```bash
grep -r "🚧 IN PROGRESS" .flow/
```

### Count Active Work Items
```bash
grep -r "🚧 IN PROGRESS" .flow/ | wc -l
# Should be 1 (only one active item at a time)
```

### Find Mismatched Status Markers
```bash
# Find headers marked IN PROGRESS
grep -B 2 "### 🚧" .flow/phase-*/*.md

# Check if their implementation sections match
grep -A 5 "Status.*COMPLETE" .flow/phase-*/*.md | grep "### 🚧"
```

## Incomplete Work Detection

### Find Unchecked Action Items
```bash
grep -r "\[ \]" .flow/phase-*/*.md
```

### Find Iterations Marked Complete with Unchecked Items
```bash
for file in .flow/phase-*/task-*.md; do
  if grep -q "### ✅.*Iteration" "$file"; then
    echo "Checking $file..."
    grep -A 50 "### ✅.*Iteration" "$file" | grep "\[ \]" && echo "❌ Found unchecked items in complete iteration"
  fi
done
```

## Phantom Task Detection

### List Tasks from DASHBOARD
```bash
grep -E "Task [0-9]:" .flow/DASHBOARD.md | sed 's/.*Task /Task /'
```

### List Actual Task Files
```bash
ls .flow/phase-*/task-*.md | xargs -n 1 basename
```

### Compare (Find Missing Files)
```bash
# Extract task numbers from DASHBOARD
dashboard_tasks=$(grep -oE "Task [0-9]+" .flow/DASHBOARD.md | sort -u)

# Check each one exists
for task in $dashboard_tasks; do
  task_num=$(echo $task | grep -oE "[0-9]+")
  if ! ls .flow/phase-*/task-${task_num}.md 2>/dev/null | grep -q .; then
    echo "❌ Phantom task: $task (file missing)"
  fi
done
```

## Implementation Gate Verification

### Check Brainstorming Status Before Implementation
```bash
for file in .flow/phase-*/task-*.md; do
  if grep -q "## Brainstorming" "$file"; then
    brainstorm_status=$(grep -A 2 "## Brainstorming" "$file" | grep "Status" | head -1)
    impl_status=$(grep -A 2 "## Implementation" "$file" | grep "Status" | head -1 2>/dev/null)

    if echo "$impl_status" | grep -q "IN PROGRESS" && ! echo "$brainstorm_status" | grep -q "COMPLETE"; then
      echo "❌ Gate violation in $file"
      echo "   Brainstorming: $brainstorm_status"
      echo "   Implementation: $impl_status"
    fi
  fi
done
```

## Task Structure Validation

### Find Tasks with Both Standalone Items AND Iterations
```bash
for file in .flow/phase-*/task-*.md; do
  has_items=$(grep -c "^## Action Items" "$file" 2>/dev/null || echo 0)
  has_iterations=$(grep -c "### .*Iteration" "$file" 2>/dev/null || echo 0)

  if [ "$has_items" -gt 0 ] && [ "$has_iterations" -gt 0 ]; then
    echo "❌ Golden Rule violation: $file has both standalone items AND iterations"
  fi
done
```

## Common Verification Workflows

### Full Plan Health Check
```bash
#!/bin/bash
echo "=== Flow Plan Health Check ==="
echo

echo "1. Checking for multiple IN PROGRESS items..."
in_progress=$(grep -r "🚧 IN PROGRESS" .flow/ | wc -l)
if [ "$in_progress" -gt 1 ]; then
  echo "⚠️  Found $in_progress IN PROGRESS items (should be max 1)"
  grep -r "🚧 IN PROGRESS" .flow/
else
  echo "✅ Only $in_progress IN PROGRESS item"
fi
echo

echo "2. Checking for phantom tasks..."
# (phantom task check from above)
echo

echo "3. Checking for unchecked items in complete iterations..."
# (unchecked items check from above)
echo

echo "=== Health Check Complete ==="
```

### Quick Status Audit
```bash
echo "Task Status Summary:"
echo "==================="
echo "COMPLETE: $(grep -r "✅ COMPLETE" .flow/ | wc -l)"
echo "IN PROGRESS: $(grep -r "🚧 IN PROGRESS" .flow/ | wc -l)"
echo "PENDING: $(grep -r "⏳ PENDING" .flow/ | wc -l)"
echo "READY: $(grep -r "🎨 READY" .flow/ | wc -l)"
```

## Issue Reporting Template

When verification finds issues, report them like this:

```markdown
## Verification Results

**Date**: 2025-10-30
**Scope**: Full plan review

### Issues Found

#### ❌ Issue 1: Multiple IN PROGRESS Items
- **Details**: Found 3 items marked 🚧 IN PROGRESS
- **Locations**:
  - Phase 2, Task 3, Iteration 2
  - Phase 2, Task 4, Iteration 1
  - Phase 3, Task 1, Iteration 1
- **Action**: Mark 2 as complete or pending, keep only 1 active

#### ⚠️ Warning: Unchecked Action Items
- **Details**: Iteration marked complete but has unchecked items
- **Location**: Phase 2, Task 3, Iteration 2
- **Action**: Check off items or mark iteration IN PROGRESS
```
