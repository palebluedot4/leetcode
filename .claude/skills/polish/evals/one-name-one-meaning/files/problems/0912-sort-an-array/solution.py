class Solution:
    def sortArray(self, nums: list[int]) -> list[int]:
        def sift_down(i: int, n: int) -> None:
            while (c := 2 * i + 1) < n:
                if c + 1 < n and nums[c + 1] > nums[c]:
                    c += 1
                if nums[i] >= nums[c]:
                    return
                nums[i], nums[c] = nums[c], nums[i]
                i = c

        n = len(nums)
        for i in range(n // 2 - 1, -1, -1):
            sift_down(i, n)
        for end in range(n - 1, 0, -1):
            nums[0], nums[end] = nums[end], nums[0]
            sift_down(0, end)
        return nums
