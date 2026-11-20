package leetcode

import "slices"

func removeElement(nums []int, val int) int {
	return len(slices.DeleteFunc(nums, func(n int) bool { return n == val }))
}
