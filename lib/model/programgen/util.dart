// Calculate n! (factorial)
int factorial(int n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

// Calculate binomial coefficient (n choose k)
// This is the number of ways to choose k items from n items where order doesn't matter
int unorderedUniqueCombinations(int k, int n) {
  if (k > n) return 0;
  if (k == 0 || k == n) return 1;

  // Use the symmetry of Pascal's triangle to reduce the size of numbers
  if (k > n - k) k = n - k;

  // Calculate using multiplicative formula to avoid large factorials
  int result = 1;
  for (int i = 0; i < k; i++) {
    result *= (n - i);
    result ~/= (i + 1);
  }

  return result;
}

// Calculate number of ordered arrangements of k items from n items
// This is n!/(n-k)! or equivalently n * (n-1) * ... * (n-k+1)
int orderedUniqueCombinations(int k, int n) {
  if (k > n) return 0;
  if (k == 0) return 1;

  int result = 1;
  for (int i = 0; i < k; i++) {
    result *= (n - i);
  }

  return result;
}
