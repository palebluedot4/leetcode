package leetcode

import "slices"

const size = 769

type MyHashMap struct {
	b [size][]entry
}

type entry struct {
	key, val int
}

func Constructor() MyHashMap {
	return MyHashMap{}
}

func (m *MyHashMap) Put(key int, value int) {
	h := key % size
	i := slices.IndexFunc(m.b[h], func(e entry) bool { return e.key == key })
	if i < 0 {
		m.b[h] = append(m.b[h], entry{key: key, val: value})
		return
	}
	m.b[h][i].val = value
}

func (m *MyHashMap) Get(key int) int {
	h := key % size
	i := slices.IndexFunc(m.b[h], func(e entry) bool { return e.key == key })
	if i < 0 {
		return -1
	}
	return m.b[h][i].val
}

func (m *MyHashMap) Remove(key int) {
	h := key % size
	m.b[h] = slices.DeleteFunc(m.b[h], func(e entry) bool { return e.key == key })
}
