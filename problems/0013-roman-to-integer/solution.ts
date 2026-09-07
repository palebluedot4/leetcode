type Numeral = "I" | "V" | "X" | "L" | "C" | "D" | "M";

const romanValues: Record<Numeral, number> = {
  I: 1,
  V: 5,
  X: 10,
  L: 50,
  C: 100,
  D: 500,
  M: 1000,
};

function romanToInt(s: string): number {
  let total = 0;
  let prev = 0;
  for (let i = s.length - 1; i >= 0; i--) {
    const v = romanValues[s[i] as Numeral];
    total += v < prev ? -v : v;
    prev = v;
  }
  return total;
}
