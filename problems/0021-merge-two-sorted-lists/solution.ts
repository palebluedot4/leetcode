class ListNode {
  constructor(
    public val: number = 0,
    public next: ListNode | null = null,
  ) {}
}

function mergeTwoLists(
  list1: ListNode | null,
  list2: ListNode | null,
): ListNode | null {
  const dummy = new ListNode();
  let tail = dummy;
  while (list1 !== null && list2 !== null) {
    if (list1.val <= list2.val) {
      tail.next = list1;
      list1 = list1.next;
    } else {
      tail.next = list2;
      list2 = list2.next;
    }
    tail = tail.next;
  }
  tail.next = list1 ?? list2;
  return dummy.next;
}

function mergeTwoListsRecursive(
  list1: ListNode | null,
  list2: ListNode | null,
): ListNode | null {
  if (list1 === null) {
    return list2;
  }
  if (list2 === null) {
    return list1;
  }
  if (list1.val <= list2.val) {
    list1.next = mergeTwoListsRecursive(list1.next, list2);
    return list1;
  }
  list2.next = mergeTwoListsRecursive(list1, list2.next);
  return list2;
}
