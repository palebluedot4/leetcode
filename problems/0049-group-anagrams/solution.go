package leetcode

import (
	"maps"
	"slices"
)

func groupAnagrams(strs []string) [][]string {
	groups := make(map[[26]int][]string)
	for _, s := range strs {
		var count [26]int
		for _, c := range s {
			count[c-'a']++
		}
		groups[count] = append(groups[count], s)
	}
	return slices.Collect(maps.Values(groups))
}
