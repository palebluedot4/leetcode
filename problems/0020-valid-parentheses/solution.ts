const closers: Record<string, string> = { "(": ")", "[": "]", "{": "}" };

function isValid(s: string): boolean {
  if (s.length % 2 !== 0) {
    return false;
  }
  const stack: string[] = [];
  for (const c of s) {
    const closer = closers[c];
    if (closer !== undefined) {
      stack.push(closer);
    } else if (c !== stack.pop()) {
      return false;
    }
  }
  return stack.length === 0;
}
