function removeDuplicates(nums: number[]): number {
  let k = 1;
  for (const num of nums) {
    if (num !== nums[k - 1]) {
      nums[k] = num;
      k++;
    }
  }
  return k;
}
