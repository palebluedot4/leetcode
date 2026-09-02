# 9. Palindrome Number

https://leetcode.com/problems/palindrome-number/

Reverse only the second half: build the reversed number digit by digit and stop
once it passes what is left of the original — that crossing point _is_ the
middle, so half the digits suffice and nothing can overflow.

| Language   | Time     | Space    |
| ---------- | -------- | -------- |
| Go         | O(log n) | O(1)     |
| Python     | O(log n) | O(log n) |
| TypeScript | O(log n) | O(log n) |

`n` is the value of `x`, so `log n` is its digit count.

Go reverses digits arithmetically; the idiomatic Python and TypeScript answer
is a string reversal, which allocates.
