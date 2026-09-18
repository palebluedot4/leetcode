from itertools import takewhile


class Solution:
    def longestCommonPrefix(self, strs: list[str]) -> str:
        columns = zip(*strs, strict=False)
        agreed = takewhile(lambda col: len(set(col)) == 1, columns)
        return "".join(col[0] for col in agreed)
