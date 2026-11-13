class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        seen: dict[int, int] = {}
        for i, n in enumerate(nums):
            if (j := seen.get(target - n)) is not None:
                return [j, i]
            seen[n] = i
        return []
