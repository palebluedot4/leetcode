# 1. Two Sum

https://leetcode.com/problems/two-sum/

Trade the second loop for a hash map: by the time a number is visited, every
complement that could pair with it has already been recorded, so a single pass
finds the answer.

Time: O(n), Space: O(n)
