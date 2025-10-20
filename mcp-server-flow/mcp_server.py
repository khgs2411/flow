#!/usr/bin/env python3
"""
MCP Server for Flow Framework

Model Context Protocol server that provides Flow development methodology tools.

AUTO-GENERATED - DO NOT EDIT DIRECTLY
Generated from framework/SLASH_COMMANDS.md metadata
"""

import os
import shutil
from pathlib import Path
from typing import Any, cast
from fastmcp import FastMCP

from flow_core import (
    find_plan_file,
    read_plan,
    write_plan,
    extract_dashboard,
    update_dashboard_timestamp,
    find_current_phase,
    find_current_task,
    find_current_iteration,
    format_success_response,
    format_error_response,
    PlanNotFoundError,
    FlowError,
)

# ============== INITIALIZATION ==============

mcp = FastMCP("Flow")

# ============== SPECIAL MCP TOOL: flow_init ==============

@mcp.tool()
def flow_init(create_slash_commands: bool = True) -> dict[str, Any]:
    """
    Initialize Flow framework in current project.

    Creates .flow/ directory with framework documentation and optionally
    .claude/commands/ with slash commands for Claude Code users.

    Args:
        create_slash_commands: Create .claude/commands/ slash commands (default: True).
                              Set to False if not using Claude Code.

    Returns:
        Initialization status and next steps
    """
    try:
        # Get framework files from package installation
        package_dir = Path(__file__).parent
        framework_source = package_dir / "framework"

        # Verify framework files exist
        if not framework_source.exists():
            return format_error_response(
                "flow-init",
                "Framework files not found in package",
                f"Expected framework files at: {framework_source}"
            )

        # Create .flow/ directory
        flow_dir = Path(".flow")
        flow_dir.mkdir(exist_ok=True)

        # Copy framework documentation
        docs_copied = []
        for doc in ["DEVELOPMENT_FRAMEWORK.md", "EXAMPLE_PLAN.md"]:
            src = framework_source / doc
            dest = flow_dir / doc
            if src.exists():
                shutil.copy(src, dest)
                docs_copied.append(doc)

        # Optionally create slash commands
        commands_created = 0
        if create_slash_commands:
            commands_dir = Path(".claude/commands")
            commands_dir.mkdir(parents=True, exist_ok=True)

            # Extract commands from SLASH_COMMANDS.md
            slash_commands_file = framework_source / "SLASH_COMMANDS.md"
            if slash_commands_file.exists():
                commands_created = extract_slash_commands(
                    slash_commands_file,
                    commands_dir
                )

        # Generate output report
        output = f"""# Flow Framework Initialized ✅

## What was created:

### .flow/ Directory
"""
        for doc in docs_copied:
            output += f"- ✅ {doc}\n"

        if create_slash_commands:
            output += f"\n### .claude/commands/ Directory\n"
            output += f"- ✅ {commands_created} slash commands extracted\n"
        else:
            output += "\n### Slash Commands\n"
            output += "- ⏭️  Skipped (create_slash_commands=False)\n"

        output += """

## Next Steps

1. **Create your first plan**: Run `flow_blueprint()` to create .flow/PLAN.md
2. **Or migrate existing docs**: Run `flow_migrate()` if you have existing planning docs

## Available Tools

Run `flow_status()` anytime to see where you are in the development process.
"""

        return format_success_response(
            "flow-init",
            f"Flow framework initialized (.flow/ + {commands_created if create_slash_commands else 0} commands)",
            output,
            "Run flow_blueprint() to create your first development plan"
        )

    except Exception as e:
        return format_error_response(
            "flow-init",
            "Failed to initialize Flow framework",
            str(e)
        )


def extract_slash_commands(slash_commands_file: Path, output_dir: Path) -> int:
    """
    Extract slash commands from SLASH_COMMANDS.md to .claude/commands/

    Args:
        slash_commands_file: Path to SLASH_COMMANDS.md
        output_dir: Directory to write command files

    Returns:
        Number of commands extracted
    """
    content = slash_commands_file.read_text()

    # Find all command sections (## /flow-...)
    import re
    command_pattern = r"## (/flow-[\w-]+)\s*\n.*?\*\*File\*\*: `([\w-]+\.md)`\s*\n```markdown\n(.*?)```"
    matches = re.findall(command_pattern, content, re.DOTALL)

    count = 0
    for command_name, filename, command_content in matches:
        command_file = output_dir / filename
        command_file.write_text(command_content)
        count += 1

    return count


# ============== AUTO-GENERATED MCP TOOLS ==============

@mcp.tool()
def flow_blueprint(project_description: str) -> dict[str, Any]:
    """
    Create new .flow/PLAN.md for a feature/project from scratch

    Args:
        project_description: Rich description of the feature/project including requirements, constraints, references, and testing methodology

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()

        # TODO: Implement /flow-blueprint logic
        # Category: planning_creation
        # Operations: WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-blueprint",
            "flow_blueprint executed",
            output,
            "Next steps for /flow-blueprint"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-blueprint",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-blueprint",
            "Failed to execute /flow-blueprint",
            str(e)
        )


@mcp.tool()
def flow_migrate(existing_file_path: str = "") -> dict[str, Any]:
    """
    Migrate existing PRD/PLAN/TODO to Flow's .flow/PLAN.md format

    Args:
        existing_file_path: Path to existing plan file (auto-discovers if not provided)

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-migrate logic
        # Category: planning_creation
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-migrate",
            "flow_migrate executed",
            output,
            "Next steps for /flow-migrate"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-migrate",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-migrate",
            "Failed to execute /flow-migrate",
            str(e)
        )


@mcp.tool()
def flow_plan_update() -> dict[str, Any]:
    """
    Update existing plan to match latest Flow framework structure

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-plan-update logic
        # Category: maintenance
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-plan-update",
            "flow_plan_update executed",
            output,
            "Next steps for /flow-plan-update"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-plan-update",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-plan-update",
            "Failed to execute /flow-plan-update",
            str(e)
        )


@mcp.tool()
def flow_phase_add(phase_name: str, phase_description: str = "") -> dict[str, Any]:
    """
    Add a new phase to the development plan

    Args:
        phase_name: Name of the phase to add
        phase_description: Optional description of the phase

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-phase-add logic
        # Category: structure_addition
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-phase-add",
            "flow_phase_add executed",
            output,
            "Next steps for /flow-phase-add"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-phase-add",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-phase-add",
            "Failed to execute /flow-phase-add",
            str(e)
        )


@mcp.tool()
def flow_phase_start() -> dict[str, Any]:
    """
    Mark current phase as in progress

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-phase-start logic
        # Category: state_management
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-phase-start",
            "flow_phase_start executed",
            output,
            "Next steps for /flow-phase-start"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-phase-start",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-phase-start",
            "Failed to execute /flow-phase-start",
            str(e)
        )


@mcp.tool()
def flow_phase_complete() -> dict[str, Any]:
    """
    Mark current phase as complete

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-phase-complete logic
        # Category: state_management
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-phase-complete",
            "flow_phase_complete executed",
            output,
            "Next steps for /flow-phase-complete"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-phase-complete",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-phase-complete",
            "Failed to execute /flow-phase-complete",
            str(e)
        )


@mcp.tool()
def flow_task_add(task_name: str, task_description: str = "", task_purpose: str = "") -> dict[str, Any]:
    """
    Add a new task under the current phase

    Args:
        task_name: Name of the task to add
        task_description: Optional description of the task
        task_purpose: Optional purpose statement for the task

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-task-add logic
        # Category: structure_addition
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-task-add",
            "flow_task_add executed",
            output,
            "Next steps for /flow-task-add"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-task-add",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-task-add",
            "Failed to execute /flow-task-add",
            str(e)
        )


@mcp.tool()
def flow_task_start() -> dict[str, Any]:
    """
    Mark current task as in progress

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-task-start logic
        # Category: state_management
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-task-start",
            "flow_task_start executed",
            output,
            "Next steps for /flow-task-start"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-task-start",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-task-start",
            "Failed to execute /flow-task-start",
            str(e)
        )


@mcp.tool()
def flow_task_complete() -> dict[str, Any]:
    """
    Mark current task as complete

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-task-complete logic
        # Category: state_management
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-task-complete",
            "flow_task_complete executed",
            output,
            "Next steps for /flow-task-complete"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-task-complete",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-task-complete",
            "Failed to execute /flow-task-complete",
            str(e)
        )


@mcp.tool()
def flow_iteration_add(iteration_name: str, iteration_description: str = "") -> dict[str, Any]:
    """
    Add a new iteration under the current task

    Args:
        iteration_name: Name/goal of the iteration to add
        iteration_description: Optional description of the iteration

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-iteration-add logic
        # Category: structure_addition
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-iteration-add",
            "flow_iteration_add executed",
            output,
            "Next steps for /flow-iteration-add"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-iteration-add",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-iteration-add",
            "Failed to execute /flow-iteration-add",
            str(e)
        )


@mcp.tool()
def flow_brainstorm_start(topics: str = "") -> dict[str, Any]:
    """
    Start brainstorming session with user-provided topics

    Args:
        topics: Topics to discuss (prompts if not provided)

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-brainstorm-start logic
        # Category: brainstorming
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-brainstorm-start",
            "flow_brainstorm_start executed",
            output,
            "Next steps for /flow-brainstorm-start"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-brainstorm-start",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-brainstorm-start",
            "Failed to execute /flow-brainstorm-start",
            str(e)
        )


@mcp.tool()
def flow_brainstorm_subject(subject_text: str) -> dict[str, Any]:
    """
    Add a subject to discuss in brainstorming

    Args:
        subject_text: Subject to add to discussion

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-brainstorm-subject logic
        # Category: brainstorming
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-brainstorm-subject",
            "flow_brainstorm_subject executed",
            output,
            "Next steps for /flow-brainstorm-subject"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-brainstorm-subject",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-brainstorm-subject",
            "Failed to execute /flow-brainstorm-subject",
            str(e)
        )


@mcp.tool()
def flow_brainstorm_review() -> dict[str, Any]:
    """
    Review all resolved subjects, suggest follow-up work

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-brainstorm-review logic
        # Category: brainstorming
        # Operations: READ

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-brainstorm-review",
            "flow_brainstorm_review executed",
            output,
            "Next steps for /flow-brainstorm-review"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-brainstorm-review",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-brainstorm-review",
            "Failed to execute /flow-brainstorm-review",
            str(e)
        )


@mcp.tool()
def flow_brainstorm_complete() -> dict[str, Any]:
    """
    Complete brainstorming and generate action items

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-brainstorm-complete logic
        # Category: brainstorming
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-brainstorm-complete",
            "flow_brainstorm_complete executed",
            output,
            "Next steps for /flow-brainstorm-complete"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-brainstorm-complete",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-brainstorm-complete",
            "Failed to execute /flow-brainstorm-complete",
            str(e)
        )


@mcp.tool()
def flow_implement_start() -> dict[str, Any]:
    """
    Begin implementation of current iteration

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-implement-start logic
        # Category: state_management
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-implement-start",
            "flow_implement_start executed",
            output,
            "Next steps for /flow-implement-start"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-implement-start",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-implement-start",
            "Failed to execute /flow-implement-start",
            str(e)
        )


@mcp.tool()
def flow_implement_complete() -> dict[str, Any]:
    """
    Mark current iteration as complete

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-implement-complete logic
        # Category: state_management
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-implement-complete",
            "flow_implement_complete executed",
            output,
            "Next steps for /flow-implement-complete"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-implement-complete",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-implement-complete",
            "Failed to execute /flow-implement-complete",
            str(e)
        )


@mcp.tool()
def flow_status() -> dict[str, Any]:
    """
    Show current position and verify plan consistency

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-status logic
        # Category: navigation_query
        # Operations: READ

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-status",
            "flow_status executed",
            output,
            "Next steps for /flow-status"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-status",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-status",
            "Failed to execute /flow-status",
            str(e)
        )


@mcp.tool()
def flow_summarize() -> dict[str, Any]:
    """
    Generate summary of all phases/tasks/iterations

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-summarize logic
        # Category: navigation_query
        # Operations: READ

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-summarize",
            "flow_summarize executed",
            output,
            "Next steps for /flow-summarize"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-summarize",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-summarize",
            "Failed to execute /flow-summarize",
            str(e)
        )


@mcp.tool()
def flow_next_subject() -> dict[str, Any]:
    """
    Discuss next subject, capture decision, and mark resolved

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-next-subject logic
        # Category: navigation_query
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-next-subject",
            "flow_next_subject executed",
            output,
            "Next steps for /flow-next-subject"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-next-subject",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-next-subject",
            "Failed to execute /flow-next-subject",
            str(e)
        )


@mcp.tool()
def flow_next_iteration() -> dict[str, Any]:
    """
    Show next iteration details

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-next-iteration logic
        # Category: navigation_query
        # Operations: READ

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-next-iteration",
            "flow_next_iteration executed",
            output,
            "Next steps for /flow-next-iteration"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-next-iteration",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-next-iteration",
            "Failed to execute /flow-next-iteration",
            str(e)
        )


@mcp.tool()
def flow_next() -> dict[str, Any]:
    """
    Smart helper - suggests next action based on current context

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-next logic
        # Category: navigation_query
        # Operations: READ

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-next",
            "flow_next executed",
            output,
            "Next steps for /flow-next"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-next",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-next",
            "Failed to execute /flow-next",
            str(e)
        )


@mcp.tool()
def flow_rollback() -> dict[str, Any]:
    """
    Undo last plan change

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-rollback logic
        # Category: maintenance
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-rollback",
            "flow_rollback executed",
            output,
            "Next steps for /flow-rollback"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-rollback",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-rollback",
            "Failed to execute /flow-rollback",
            str(e)
        )


@mcp.tool()
def flow_verify_plan() -> dict[str, Any]:
    """
    Verify plan file matches actual codebase state

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-verify-plan logic
        # Category: maintenance
        # Operations: READ

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-verify-plan",
            "flow_verify_plan executed",
            output,
            "Next steps for /flow-verify-plan"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-verify-plan",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-verify-plan",
            "Failed to execute /flow-verify-plan",
            str(e)
        )


@mcp.tool()
def flow_compact() -> dict[str, Any]:
    """
    No description available

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-compact logic
        # Category: maintenance
        # Operations: READ

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-compact",
            "flow_compact executed",
            output,
            "Next steps for /flow-compact"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-compact",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-compact",
            "Failed to execute /flow-compact",
            str(e)
        )


@mcp.tool()
def flow_plan_split() -> dict[str, Any]:
    """
    Archive old completed tasks to reduce PLAN.md size

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-plan-split logic
        # Category: maintenance
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-plan-split",
            "flow_plan_split executed",
            output,
            "Next steps for /flow-plan-split"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-plan-split",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-plan-split",
            "Failed to execute /flow-plan-split",
            str(e)
        )


@mcp.tool()
def flow_backlog_add(task_numbers: str) -> dict[str, Any]:
    """
    Move task(s) to backlog to reduce active plan clutter

    Args:
        task_numbers: Task number(s) to move to backlog (e.g. '14' or '14-22')

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-backlog-add logic
        # Category: backlog
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-backlog-add",
            "flow_backlog_add executed",
            output,
            "Next steps for /flow-backlog-add"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-backlog-add",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-backlog-add",
            "Failed to execute /flow-backlog-add",
            str(e)
        )


@mcp.tool()
def flow_backlog_view() -> dict[str, Any]:
    """
    Show backlog contents (tasks waiting)

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-backlog-view logic
        # Category: backlog
        # Operations: READ

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-backlog-view",
            "flow_backlog_view executed",
            output,
            "Next steps for /flow-backlog-view"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-backlog-view",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-backlog-view",
            "Failed to execute /flow-backlog-view",
            str(e)
        )


@mcp.tool()
def flow_backlog_pull(task_number: str, position: str = "") -> dict[str, Any]:
    """
    Pull task from backlog back into active plan

    Args:
        task_number: Task number to pull from backlog
        position: Optional positioning instruction

    Returns:
        Status response with operation result
    """
    try:
        # Find and read PLAN.md
        plan_path = find_plan_file()
        plan_content = read_plan(plan_path)

        # TODO: Implement /flow-backlog-pull logic
        # Category: backlog
        # Operations: READ, WRITE

        output = f"""# {command_name} Result

        TODO: Implement command logic
        """

        return format_success_response(
            "/flow-backlog-pull",
            "flow_backlog_pull executed",
            output,
            "Next steps for /flow-backlog-pull"
        )

    except PlanNotFoundError:
        return format_error_response(
            "/flow-backlog-pull",
            "PLAN.md not found",
            "Run flow_init() first, then flow_blueprint() to create a plan"
        )
    except Exception as e:
        return format_error_response(
            "/flow-backlog-pull",
            "Failed to execute /flow-backlog-pull",
            str(e)
        )


# ============== ENTRY POINT ==============

def main():
    """Entry point for the MCP server"""
    mcp.run()


if __name__ == "__main__":
    main()
