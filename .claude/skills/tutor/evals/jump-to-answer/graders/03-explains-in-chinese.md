---
type: llm
focus: last_message
weight: 1
---

Besides the code, the reply explains, mostly in Chinese: the idea (a hash map
from value to index, looking up target minus the current value), why it is
correct (the earlier element of a pair is already recorded when the later one
is reached), the complexity (O(n) time, O(n) space), and at least one detail
that is easy to get wrong, such as checking before inserting so an element is
not paired with itself. It does not argue with the user or ask them to try
first.
