"""Finds the next problem in a study list and fetches LeetCode's stubs for it.

Usage:
    python3 leetcode.py LIST

LIST is a study list such as lists/neetcode-250.md. Run from inside the
repository. The next problem is the first row, top to bottom, that is not
marked 🔒 and whose solution.go and solution.py are not both committed.
Prints one JSON object whose "status" is one of:

    finished     every row is solved or skipped.
    in_progress  the next problem's directory already exists; nothing fetched.
    premium      LeetCode reports the problem as Premium though the list does
                 not mark it 🔒; no stubs are available without a login.
    new          the problem is new; "snippets" holds LeetCode's Go and
                 Python 3 stubs, keyed "golang" and "python3".
"""

import argparse
import http.client
import json
import re
import subprocess
import sys
import urllib.error
import urllib.request
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

GRAPHQL_URL = "https://leetcode.com/graphql"
# LeetCode's responses sometimes arrive cut short; a second request succeeds.
ATTEMPTS = 3
QUERY = """
query question($slug: String!) {
  question(titleSlug: $slug) {
    isPaidOnly
    codeSnippets { langSlug code }
  }
}
"""
LANGUAGES = ("golang", "python3")
LINK = re.compile(
    r"\[(?P<number>\d+)\. (?P<title>[^\]]+)\]"
    r"\(https://leetcode\.com/problems/(?P<slug>[^/)]+)/?\)"
)
DIFFICULTY = re.compile(r"\|\s*(?P<difficulty>Easy|Medium|Hard)\s*\|")
PREMIUM = "🔒"


@dataclass(frozen=True)
class Problem:
    """A row of a study list."""

    number: str
    title: str
    slug: str
    difficulty: str
    premium: bool

    @property
    def directory(self) -> str:
        """The problem's directory, relative to the repository root."""
        return f"problems/{self.number}-{self.slug}"

    @property
    def url(self) -> str:
        """The problem's page on LeetCode."""
        return f"https://leetcode.com/problems/{self.slug}/"


def git(root: Path, *args: str) -> str:
    """Runs git in the repository and returns its standard output."""
    return subprocess.run(
        ["git", "-C", str(root), *args],
        check=True,
        capture_output=True,
        text=True,
    ).stdout


def parse(list_path: Path) -> list[Problem]:
    """Returns the problems of a study list, in its order."""
    problems: list[Problem] = []
    for line in list_path.read_text(encoding="utf-8").splitlines():
        if not line.startswith("|") or not (link := LINK.search(line)):
            continue
        difficulty = DIFFICULTY.search(line)
        problems.append(
            Problem(
                number=f"{int(link['number']):04d}",
                title=link["title"],
                slug=link["slug"],
                difficulty=difficulty["difficulty"] if difficulty else "",
                premium=PREMIUM in line,
            )
        )
    return problems


def post(request: urllib.request.Request, attempts: int = ATTEMPTS) -> Any:
    """Sends a request and returns its decoded JSON response."""
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            return json.load(response)
    except http.client.IncompleteRead, urllib.error.URLError:
        if attempts == 1:
            raise
        return post(request, attempts - 1)


def fetch(slug: str) -> dict[str, Any]:
    """Returns LeetCode's GraphQL record of a problem."""
    body = json.dumps({"query": QUERY, "variables": {"slug": slug}}).encode()
    request = urllib.request.Request(
        GRAPHQL_URL,
        data=body,
        headers={
            "Content-Type": "application/json",
            "Referer": "https://leetcode.com",
            "User-Agent": "Mozilla/5.0",
        },
    )
    question: dict[str, Any] | None = post(request)["data"]["question"]
    if question is None:
        raise SystemExit(f"LeetCode has no problem with the slug {slug!r}")
    return question


def next_problem(list_path: Path) -> dict[str, Any]:
    """Returns the status of the list's next problem, as described above."""
    root = Path(git(Path.cwd(), "rev-parse", "--show-toplevel").strip())
    tracked = set(git(root, "ls-files", "--", "problems").splitlines())
    for problem in parse(list_path):
        solutions = {f"{problem.directory}/solution.{ext}" for ext in ("go", "py")}
        if problem.premium or solutions <= tracked:
            continue
        result: dict[str, Any] = asdict(problem) | {
            "directory": problem.directory,
            "url": problem.url,
        }
        if (root / problem.directory).exists():
            return result | {"status": "in_progress"}
        question = fetch(problem.slug)
        if question["isPaidOnly"]:
            return result | {"status": "premium"}
        snippets = {
            snippet["langSlug"]: snippet["code"]
            for snippet in question["codeSnippets"]
            if snippet["langSlug"] in LANGUAGES
        }
        return result | {"status": "new", "snippets": snippets}
    return {"status": "finished"}


def main() -> int:
    """Prints the next problem of the list named on the command line."""
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("list", type=Path, help="a study list in lists/")
    args = parser.parse_args()
    json.dump(next_problem(args.list), sys.stdout, ensure_ascii=False, indent=2)
    print()
    return 0


if __name__ == "__main__":
    sys.exit(main())
