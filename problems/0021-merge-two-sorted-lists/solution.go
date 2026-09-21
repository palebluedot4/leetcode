package leetcode

type ListNode struct {
	Val  int
	Next *ListNode
}

func mergeTwoLists(list1 *ListNode, list2 *ListNode) *ListNode {
	dummy := &ListNode{}
	tail := dummy
	for list1 != nil && list2 != nil {
		if list1.Val <= list2.Val {
			tail.Next = list1
			list1 = list1.Next
		} else {
			tail.Next = list2
			list2 = list2.Next
		}
		tail = tail.Next
	}
	if list1 != nil {
		tail.Next = list1
	} else {
		tail.Next = list2
	}
	return dummy.Next
}

func mergeTwoListsRecursive(list1 *ListNode, list2 *ListNode) *ListNode {
	switch {
	case list1 == nil:
		return list2
	case list2 == nil:
		return list1
	case list1.Val <= list2.Val:
		list1.Next = mergeTwoListsRecursive(list1.Next, list2)
		return list1
	default:
		list2.Next = mergeTwoListsRecursive(list1, list2.Next)
		return list2
	}
}
