#!/usr/bin/env python3
"""
Flow Framework - Core Logic

Shared utilities for MCP tools to interact with .flow/PLAN.md files.
"""

import os
import re
from pathlib import Path
from typing import Any, Optional
from datetime import datetime


class FlowError(Exception):
    """Base exception for Flow operations"""
    pass


class PlanNotFoundError(FlowError):
    """Raised when PLAN.md cannot be found"""
    pass


def find_plan_file(start_dir: Optional[str] = None) -> Path:
    """
    Find .flow/PLAN.md file starting from current directory.

    Args:
        start_dir: Starting directory (default: current working directory)

    Returns:
        Path to PLAN.md

    Raises:
        PlanNotFoundError: If PLAN.md cannot be found
    """
    if start_dir is None:
        start_dir = os.getcwd()

    current = Path(start_dir).resolve()

    # Check .flow/PLAN.md in current directory and parent directories
    while current != current.parent:
        plan_path = current / ".flow" / "PLAN.md"
        if plan_path.exists():
            return plan_path
        current = current.parent

    # Check root
    plan_path = current / ".flow" / "PLAN.md"
    if plan_path.exists():
        return plan_path

    raise PlanNotFoundError(
        "Could not find .flow/PLAN.md. Run flow_init() to initialize Flow framework."
    )


def read_plan(plan_path: Optional[Path] = None) -> str:
    """
    Read PLAN.md content.

    Args:
        plan_path: Path to PLAN.md (default: auto-find)

    Returns:
        PLAN.md content as string
    """
    if plan_path is None:
        plan_path = find_plan_file()

    return plan_path.read_text()


def write_plan(content: str, plan_path: Optional[Path] = None) -> None:
    """
    Write content to PLAN.md.

    Args:
        content: Content to write
        plan_path: Path to PLAN.md (default: auto-find)
    """
    if plan_path is None:
        plan_path = find_plan_file()

    plan_path.write_text(content)


def extract_dashboard(plan_content: str) -> dict[str, Any]:
    """
    Extract Progress Dashboard information from PLAN.md.

    Args:
        plan_content: Content of PLAN.md

    Returns:
        Dictionary with dashboard information
    """
    dashboard = {
        "last_updated": None,
        "phase": None,
        "task": None,
        "iteration": None,
        "status": None,
    }

    # Find Progress Dashboard section
    dashboard_match = re.search(
        r"## 📋 Progress Dashboard\s*\n(.*?)(?=\n##|\Z)",
        plan_content,
        re.DOTALL
    )

    if not dashboard_match:
        return dashboard

    dashboard_text = dashboard_match.group(1)

    # Extract Last Updated
    updated_match = re.search(r"\*\*Last Updated:\*\* (.+)", dashboard_text)
    if updated_match:
        dashboard["last_updated"] = updated_match.group(1)

    # Extract Current Phase
    phase_match = re.search(r"\*\*Current Phase:\*\* Phase (\d+): (.+?) \((.+?)\)", dashboard_text)
    if phase_match:
        dashboard["phase"] = {
            "number": int(phase_match.group(1)),
            "name": phase_match.group(2),
            "status": phase_match.group(3)
        }

    # Extract Current Task
    task_match = re.search(r"\*\*Current Task:\*\* Task (\d+): (.+?) \((.+?)\)", dashboard_text)
    if task_match:
        dashboard["task"] = {
            "number": int(task_match.group(1)),
            "name": task_match.group(2),
            "status": task_match.group(3)
        }

    # Extract Current Iteration
    iter_match = re.search(r"\*\*Current Iteration:\*\* Iteration (\d+): (.+?) \((.+?)\)", dashboard_text)
    if iter_match:
        dashboard["iteration"] = {
            "number": int(iter_match.group(1)),
            "name": iter_match.group(2),
            "status": iter_match.group(3)
        }

    # Extract overall status
    status_match = re.search(r"\*\*Status:\*\* (.+)", dashboard_text)
    if status_match:
        dashboard["status"] = status_match.group(1)

    return dashboard


def update_dashboard_timestamp(plan_content: str) -> str:
    """
    Update the Last Updated timestamp in Progress Dashboard.

    Args:
        plan_content: Content of PLAN.md

    Returns:
        Updated content with new timestamp
    """
    timestamp = datetime.now().strftime("%Y-%m-%d %I:%M %p")

    # Update Last Updated line
    updated_content = re.sub(
        r"(\*\*Last Updated:\*\*) .+",
        rf"\1 {timestamp}",
        plan_content
    )

    return updated_content


def find_current_phase(plan_content: str) -> Optional[dict[str, Any]]:
    """
    Find the current active phase (🚧 IN PROGRESS).

    Args:
        plan_content: Content of PLAN.md

    Returns:
        Dictionary with phase info or None if not found
    """
    # Find phase with 🚧 marker
    phase_match = re.search(
        r"### Phase (\d+): (.+?)\s*\n.*?🚧",
        plan_content,
        re.DOTALL
    )

    if phase_match:
        return {
            "number": int(phase_match.group(1)),
            "name": phase_match.group(2),
            "status": "🚧"
        }

    return None


def find_current_task(plan_content: str) -> Optional[dict[str, Any]]:
    """
    Find the current active task (🚧 IN PROGRESS).

    Args:
        plan_content: Content of PLAN.md

    Returns:
        Dictionary with task info or None if not found
    """
    # Find task with 🚧 marker
    task_match = re.search(
        r"#### Task (\d+): (.+?)\s*\n.*?🚧",
        plan_content,
        re.DOTALL
    )

    if task_match:
        return {
            "number": int(task_match.group(1)),
            "name": task_match.group(2),
            "status": "🚧"
        }

    return None


def find_current_iteration(plan_content: str) -> Optional[dict[str, Any]]:
    """
    Find the current active iteration (🚧 or 🎨).

    Args:
        plan_content: Content of PLAN.md

    Returns:
        Dictionary with iteration info or None if not found
    """
    # Find iteration with 🚧 or 🎨 marker
    iter_match = re.search(
        r"##### Iteration (\d+): (.+?)\s*\n.*?(🚧|🎨)",
        plan_content,
        re.DOTALL
    )

    if iter_match:
        return {
            "number": int(iter_match.group(1)),
            "name": iter_match.group(2),
            "status": iter_match.group(3)
        }

    return None


def get_status_emoji(status: str) -> str:
    """
    Convert status string to emoji.

    Args:
        status: Status string (e.g., "PENDING", "IN PROGRESS", "COMPLETE")

    Returns:
        Status emoji
    """
    status_map = {
        "PENDING": "⏳",
        "IN PROGRESS": "🚧",
        "READY": "🎨",
        "COMPLETE": "✅",
        "CANCELLED": "❌",
        "DEFERRED": "🔮",
    }

    return status_map.get(status.upper(), "⏳")


def format_success_response(
    command: str,
    operation: str,
    output: str,
    next_steps: str = "",
    dashboard: Optional[dict[str, Any]] = None,
    metadata: Optional[dict[str, Any]] = None
) -> dict[str, Any]:
    """
    Format a successful MCP tool response.

    Args:
        command: Command name (e.g., "flow-task-add")
        operation: What happened (e.g., "Task 5 added to Phase 2")
        output: Markdown-formatted output for AI
        next_steps: Suggested next actions
        dashboard: Updated dashboard state
        metadata: Additional context (category, framework sections, etc.)

    Returns:
        Formatted response dictionary
    """
    return {
        "success": True,
        "command": command,
        "operation": operation,
        "output": output,
        "next_steps": next_steps or "Run flow_status() to see current position.",
        "dashboard": dashboard,
        "metadata": metadata,
        "error": None
    }


def format_error_response(
    command: str,
    error: str,
    details: str = ""
) -> dict[str, Any]:
    """
    Format an error MCP tool response.

    Args:
        command: Command name
        error: Error message
        details: Additional error details

    Returns:
        Formatted error response dictionary
    """
    full_error = error
    if details:
        full_error = f"{error}\n\nDetails: {details}"

    return {
        "success": False,
        "command": command,
        "operation": "Failed",
        "output": f"❌ Error: {error}",
        "next_steps": "Please fix the error and try again.",
        "dashboard": None,
        "error": full_error
    }
