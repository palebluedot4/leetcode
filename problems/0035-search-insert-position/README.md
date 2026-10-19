# 35. Search Insert Position

https://leetcode.com/problems/search-insert-position/

Finding `target` and finding where it would go are one question: the first
index whose value is not less than `target`. Keep `[lo, hi)` as the unknown
zone — everything left of `lo` is `< target`, everything from `hi` on is
`>= target` — and halve it until it is empty; `lo` is then the boundary. `hi`
starts at the length, not the last index, because "after everything" is a valid
answer.

Time: O(log n), Space: O(1)

Go's `slices.BinarySearch` and Python's `bisect_left` are this exact search, so
both are one call; JavaScript ships no binary search, so TypeScript writes the
loop.
