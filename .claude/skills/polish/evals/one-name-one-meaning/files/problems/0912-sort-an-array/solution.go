package leetcode

func sortArray(nums []int) []int {
	for i := len(nums)/2 - 1; i >= 0; i-- {
		siftDown(nums, i)
	}
	for end := len(nums) - 1; end > 0; end-- {
		nums[0], nums[end] = nums[end], nums[0]
		siftDown(nums[:end], 0)
	}
	return nums
}

func siftDown(h []int, i int) {
	for {
		c := 2*i + 1
		if c >= len(h) {
			return
		}
		if c+1 < len(h) && h[c+1] > h[c] {
			c++
		}
		if h[i] >= h[c] {
			return
		}
		h[i], h[c] = h[c], h[i]
		i = c
	}
}
