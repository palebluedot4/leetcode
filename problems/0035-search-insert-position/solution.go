package leetcode

import "slices"

func searchInsert(nums []int, target int) int {
	i, _ := slices.BinarySearch(nums, target)
	return i
}
