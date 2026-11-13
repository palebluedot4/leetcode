"""Schedules /recall: which accepted problems are due to be solved again today.

Usage:
    python3 schedule.py due
    python3 schedule.py log NUMBER {pass,reset}

Run from inside the repository. A problem enters the schedule on the day its
first solution file is committed. Each recall that passes moves it one stage
on; one that does not resets it to the first stage. The wait before the next
recall is counted from the last time the problem was written, so a recall
done late shifts the rest of the schedule rather than losing a step. After
the last stage the problem leaves the schedule.

`due` prints a JSON object: today's date, how many problems were recalled
today, the backlog (every problem due now), and "due", the problems to
recall now, most overdue first, at most what is left of the daily limit;
each names its committed directory and the draft directory to recall it in.
`log` appends one line to .recall/log, the only state the schedule keeps.
"""

import argparse
import json
import subprocess
import sys
from dataclasses import dataclass
from datetime import date
from pathlib import Path
from typing import Any, Literal

INTERVALS = (3, 7, 21)
DAILY_LIMIT = 5
BACKLOG_WARNING = 10
LOG = Path(".recall/log")
SOLUTIONS = ("problems/*/solution.go", "problems/*/solution.py")

type Result = Literal["pass", "reset"]


@dataclass(frozen=True)
class Entry:
    """One line of the log: a recall of a problem on a day."""

    day: date
    number: str
    result: Result


@dataclass(frozen=True)
class Due:
    """A problem due for recall."""

    number: str
    directory: str
    overdue: float


def git(root: Path, *args: str) -> str:
    """Runs git in the repository and returns its standard output."""
    return subprocess.run(
        ["git", "-C", str(root), *args],
        check=True,
        capture_output=True,
        text=True,
    ).stdout


def repository_root() -> Path:
    """Returns the root of the repository the working directory is in."""
    return Path(git(Path.cwd(), "rev-parse", "--show-toplevel").strip())


def solved(root: Path) -> dict[str, tuple[str, date]]:
    """Maps each problem with a committed solution to its directory and the day
    its first solution file was committed, in local time."""
    head = subprocess.run(
        ["git", "-C", str(root), "rev-parse", "--quiet", "--verify", "HEAD"],
        capture_output=True,
        check=False,
    )
    if head.returncode != 0:
        return {}
    tracked = set(git(root, "ls-files", "--", *SOLUTIONS).splitlines())
    history = git(
        root,
        "log",
        "--diff-filter=A",
        "--name-only",
        "--format=@%ad",
        "--date=format-local:%Y-%m-%d",
        "--",
        *SOLUTIONS,
    )
    problems: dict[str, tuple[str, date]] = {}
    day = date.min
    for line in history.splitlines():
        if line.startswith("@"):
            day = date.fromisoformat(line[1:])
        elif line in tracked:
            directory = str(Path(line).parent)
            number = Path(directory).name[:4]
            if number not in problems or day < problems[number][1]:
                problems[number] = (directory, day)
    return problems


def read_log(root: Path) -> list[Entry]:
    """Returns the log's entries in the order they were written."""
    path = root / LOG
    if not path.exists():
        return []
    entries: list[Entry] = []
    for line_number, line in enumerate(path.read_text().splitlines(), 1):
        if not line.strip():
            continue
        match line.split():
            case [day, number, ("pass" | "reset") as result]:
                entries.append(Entry(date.fromisoformat(day), number, result))
            case _:
                raise SystemExit(f"{path}:{line_number}: cannot read {line!r}")
    return entries


def due(root: Path, today: date) -> dict[str, Any]:
    """Returns today's schedule, as described above."""
    entries = read_log(root)
    recalled_today = {entry.number for entry in entries if entry.day == today}
    backlog: list[Due] = []
    for number, (directory, first) in solved(root).items():
        stage, last = 0, first
        for entry in entries:
            if entry.number == number:
                stage = stage + 1 if entry.result == "pass" else 0
                last = entry.day
        if stage >= len(INTERVALS) or number in recalled_today:
            continue
        interval = INTERVALS[stage]
        elapsed = (today - last).days
        if elapsed >= interval:
            backlog.append(Due(number, directory, elapsed / interval))
    backlog.sort(key=lambda problem: (-problem.overdue, problem.number))
    remaining = max(0, DAILY_LIMIT - len(recalled_today))
    return {
        "today": today.isoformat(),
        "daily_limit": DAILY_LIMIT,
        "recalled_today": len(recalled_today),
        "backlog": len(backlog),
        "backlog_warning": len(backlog) > BACKLOG_WARNING,
        "due": [
            {
                "number": problem.number,
                "directory": problem.directory,
                "draft": str(LOG.parent / Path(problem.directory).name),
            }
            for problem in backlog[:remaining]
        ],
    }


def log(root: Path, today: date, number: str, result: Result) -> None:
    """Appends a recall of a solved problem to the log."""
    number = f"{int(number):04d}"
    if number not in solved(root):
        raise SystemExit(f"{number} has no committed solution to recall")
    path = root / LOG
    path.parent.mkdir(exist_ok=True)
    with path.open("a") as file:
        file.write(f"{today.isoformat()} {number} {result}\n")


def main() -> int:
    """Runs the subcommand named on the command line."""
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    commands = parser.add_subparsers(dest="command", required=True)
    commands.add_parser("due", help="print today's schedule as JSON")
    log_parser = commands.add_parser("log", help="record a recall")
    log_parser.add_argument("number", help="the problem's number, e.g. 0217")
    log_parser.add_argument("result", choices=("pass", "reset"))
    args = parser.parse_args()

    root, today = repository_root(), date.today()
    if args.command == "due":
        json.dump(due(root, today), sys.stdout, indent=2)
        print()
    else:
        log(root, today, args.number, args.result)
    return 0


if __name__ == "__main__":
    sys.exit(main())
