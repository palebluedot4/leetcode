# 20. Valid Parentheses

https://leetcode.com/problems/valid-parentheses/

Nesting is last-in-first-out, so a stack is the entire data structure. Push the
closer an opener _demands_ rather than the opener itself, and every closing
bracket is settled by one equality against the top — the pairing is resolved on
the way in, so no case is left where the wrong closer matches.

Time: O(n), Space: O(n)
