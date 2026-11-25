package leetcode

import "slices"

const size = 769

type MyHashMap struct {
	buckets [size][]entry
}

type entry struct {
	key, value int
}

func Constructor() MyHashMap {
	return MyHashMap{}
}

func (m *MyHashMap) Put(key int, value int) {
	h := key % size
	i := slices.IndexFunc(m.buckets[h], func(e entry) bool { return e.key == key })
	if i < 0 {
		m.buckets[h] = append(m.buckets[h], entry{key: key, value: value})
		return
	}
	m.buckets[h][i].value = value
}

func (m *MyHashMap) Get(key int) int {
	h := key % size
	i := slices.IndexFunc(m.buckets[h], func(e entry) bool { return e.key == key })
	if i < 0 {
		return -1
	}
	return m.buckets[h][i].value
}

func (m *MyHashMap) Remove(key int) {
	h := key % size
	m.buckets[h] = slices.DeleteFunc(m.buckets[h], func(e entry) bool { return e.key == key })
}
