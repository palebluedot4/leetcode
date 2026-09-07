ROMAN_VALUES = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000}


class Solution:
    def romanToInt(self, s: str) -> int:
        total = prev = 0
        for c in reversed(s):
            v = ROMAN_VALUES[c]
            total += -v if v < prev else v
            prev = v
        return total
