# 27. Remove Element

https://leetcode.com/problems/remove-element/

Compact instead of delete: every survivor is copied down to the front, so each
element moves at most once instead of the whole tail shifting on every removal.
`k` is both the count kept and the next write slot, and it never passes the read
position, so a write only ever lands on a value already read.

Time: O(n), Space: O(1)
