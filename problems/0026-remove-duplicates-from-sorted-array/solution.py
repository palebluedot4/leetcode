class Solution:
    def removeDuplicates(self, nums: list[int]) -> int:
        k = 1
        for num in nums:
            if num != nums[k - 1]:
                nums[k] = num
                k += 1
        return k
