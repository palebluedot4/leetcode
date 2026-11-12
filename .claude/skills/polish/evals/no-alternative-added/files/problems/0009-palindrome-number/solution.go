package leetcode

func isPalindrome(x int) bool {
	if x < 0 || (x%10 == 0 && x != 0) {
		return false
	}
	reversedHalf := 0
	for x > reversedHalf {
		reversedHalf = reversedHalf*10 + x%10
		x = x / 10
	}
	if x == reversedHalf || x == reversedHalf/10 {
		return true
	} else {
		return false
	}
}
