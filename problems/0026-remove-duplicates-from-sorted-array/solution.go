package leetcode

func removeDuplicates(nums []int) int {
	k := 1
	for _, num := range nums[1:] {
		if num != nums[k-1] {
			nums[k] = num
			k++
		}
	}
	return k
}
