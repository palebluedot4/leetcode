package leetcode

import "slices"

func longestCommonPrefix(strs []string) string {
	first := strs[0]
	for i := range len(first) {
		for _, s := range strs[1:] {
			if i == len(s) || s[i] != first[i] {
				return first[:i]
			}
		}
	}
	return first
}

func longestCommonPrefixMinMax(strs []string) string {
	lo, hi := slices.Min(strs), slices.Max(strs)
	for i := range len(lo) {
		if lo[i] != hi[i] {
			return lo[:i]
		}
	}
	return lo
}
