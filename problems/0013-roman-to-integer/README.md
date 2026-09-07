# 13. Roman to Integer

https://leetcode.com/problems/roman-to-integer/

Every numeral is added except when it is smaller than the one to its right,
which marks the front of a subtractive pair (`IV`, `XC`) and flips its sign —
one comparison per numeral, no pair special-cased. Scanning right to left
removes the boundary check: `prev` starts at 0, below every numeral, so the
numeral the scan begins on is always added.

Time: O(n), Space: O(1)
