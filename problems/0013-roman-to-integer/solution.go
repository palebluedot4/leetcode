package leetcode

var romanValues = map[byte]int{
	'I': 1,
	'V': 5,
	'X': 10,
	'L': 50,
	'C': 100,
	'D': 500,
	'M': 1000,
}

func romanToInt(s string) int {
	total, prev := 0, 0
	for i := len(s) - 1; i >= 0; i-- {
		v := romanValues[s[i]]
		if v < prev {
			total -= v
		} else {
			total += v
		}
		prev = v
	}
	return total
}
