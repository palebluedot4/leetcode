# 28. Find the Index of the First Occurrence in a String

https://leetcode.com/problems/find-the-index-of-the-first-occurrence-in-a-string/

This is substring search, and every standard library already ships it with this
exact contract — the index of the first match, or `-1` if there is none — so the
answer is one call with nothing to adapt.

Time: O(n·m), Space: O(1)

`n` and `m` are the lengths of `haystack` and `needle`. O(n·m) is the naive
bound; how far below it each library gets is the library's business.
