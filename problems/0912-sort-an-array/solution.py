class Solution:
    def sortArray(self, nums: list[int]) -> list[int]:
        def sift_down(root: int, size: int) -> None:
            while (c := 2 * root + 1) < size:
                if c + 1 < size and nums[c + 1] > nums[c]:
                    c += 1
                if nums[root] >= nums[c]:
                    return
                nums[root], nums[c] = nums[c], nums[root]
                root = c

        n = len(nums)
        for i in reversed(range(n // 2)):
            sift_down(i, n)
        for end in reversed(range(1, n)):
            nums[0], nums[end] = nums[end], nums[0]
            sift_down(0, end)
        return nums
