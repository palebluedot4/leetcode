package leetcode

import "sort"

func topKFrequent(nums []int, k int) []int {
	countMap := make(map[int]int)
	for i := 0; i < len(nums); i++ {
		countMap[nums[i]] = countMap[nums[i]] + 1
	}
	keys := []int{}
	for key, _ := range countMap {
		keys = append(keys, key)
	}
	sort.Slice(keys, func(a, b int) bool {
		if countMap[keys[a]] > countMap[keys[b]] {
			return true
		} else {
			return false
		}
	})
	return keys[:k]
}
