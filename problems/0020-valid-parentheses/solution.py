CLOSERS = {"(": ")", "[": "]", "{": "}"}


class Solution:
    def isValid(self, s: str) -> bool:
        if len(s) % 2:
            return False
        stack: list[str] = []
        for c in s:
            if c in CLOSERS:
                stack.append(CLOSERS[c])
            elif not stack or c != stack.pop():
                return False
        return not stack
