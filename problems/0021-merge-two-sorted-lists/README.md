# 21. Merge Two Sorted Lists

https://leetcode.com/problems/merge-two-sorted-lists/

Both lists are sorted, so the smaller of the two heads is the smallest node
left anywhere — take it, relink it, advance that list. A dummy head absorbs the
"is this the first node?" case so the loop keeps one shape, and the moment
either list empties the other is already a sorted tail and is spliced on whole.

Time: O(n + m), Space: O(1)

`n` and `m` are the two lists' lengths.
