class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        seen: dict[int, int] = {}
        for i, num in enumerate(nums):
            if (j := seen.get(target - num)) is not None:
                return [j, i]
            seen[num] = i
        return []
