# 26. Remove Duplicates from Sorted Array

https://leetcode.com/problems/remove-duplicates-from-sorted-array/

Sortedness gathers every copy of a value into one contiguous run, so a number
is new exactly when it differs from the last one kept — one comparison does the
work a hash set would. `k` is both the count kept and the next write slot, and
every write lands on a slot already read, so the prefix is rewritten in place.
The first element is always kept, so `k` starts at 1 and the loop needs no
empty-prefix guard.

Time: O(n), Space: O(1)
