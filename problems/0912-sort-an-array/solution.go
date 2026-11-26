package leetcode

func sortArray(nums []int) []int {
	heapSort(nums)
	return nums
}

func heapSort(h []int) {
	for i := len(h)/2 - 1; i >= 0; i-- {
		siftDown(h, i)
	}
	for end := len(h) - 1; end > 0; end-- {
		h[0], h[end] = h[end], h[0]
		siftDown(h[:end], 0)
	}
}

func siftDown(h []int, i int) {
	for {
		c := 2*i + 1
		if c >= len(h) {
			return
		}
		if c+1 < len(h) && h[c+1] > h[c] {
			c++
		}
		if h[i] >= h[c] {
			return
		}
		h[i], h[c] = h[c], h[i]
		i = c
	}
}
