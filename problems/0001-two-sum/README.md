# 1. Two Sum

https://leetcode.com/problems/two-sum/

Trade the second loop for a hash map: each number is recorded as it is passed,
so the later half of any valid pair finds its partner already waiting — one
pass instead of two.

Time: O(n), Space: O(n)
