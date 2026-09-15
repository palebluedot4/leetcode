package leetcode

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
