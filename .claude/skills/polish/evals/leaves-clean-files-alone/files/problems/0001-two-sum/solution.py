class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        seen: dict[int, int] = {}
        for i, x in enumerate(nums):
            if (j := seen.get(target - x)) is not None:
                return [j, i]
            seen[x] = i
        return []
