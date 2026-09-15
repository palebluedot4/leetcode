from itertools import takewhile
from typing import List


class Solution:
    def longestCommonPrefix(self, strs: List[str]) -> str:
        columns = zip(*strs, strict=False)
        agreed = takewhile(lambda col: len(set(col)) == 1, columns)
        return "".join(col[0] for col in agreed)
