function longestCommonPrefix(strs: string[]): string {
  const [first = ""] = strs;
  for (let i = 0; i < first.length; i++) {
    if (!strs.every((s) => s[i] === first[i])) {
      return first.slice(0, i);
    }
  }
  return first;
}
