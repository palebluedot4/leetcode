package leetcode

func isAnagram(s string, t string) bool {
	var count [26]int
	for i := range len(s) {
		count[s[i]-'a']++
	}
	for i := range len(t) {
		count[t[i]-'a']--
	}
	for _, c := range count {
		if c < 0 {
			return false
		}
	}
	return true
}
