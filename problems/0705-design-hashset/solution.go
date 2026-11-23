package leetcode

import "slices"

const size = 769

type MyHashSet struct {
	buckets [size][]int
}

func Constructor() MyHashSet {
	return MyHashSet{}
}

func (s *MyHashSet) Add(key int) {
	h := key % size
	if !slices.Contains(s.buckets[h], key) {
		s.buckets[h] = append(s.buckets[h], key)
	}
}

func (s *MyHashSet) Remove(key int) {
	h := key % size
	s.buckets[h] = slices.DeleteFunc(s.buckets[h], func(k int) bool { return k == key })
}

func (s *MyHashSet) Contains(key int) bool {
	return slices.Contains(s.buckets[key%size], key)
}
