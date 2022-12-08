void main() {
  print("Result of 3 + 6 = ${addTwoNumbers(3, 6)}");
  print("Result of 7 + 9 = ${addTwoNumbersWithTypes(7, 9)}");
  print("Result of 1 + 5 = ${addTwoNumbers(1, 5)}");
}

int addTwoNumbers(a, b) {
  return a + b;
}

int addTwoNumbersWithTypes(int a, int b) {
  return a + b;
}

int addTwoNumbersShorter(a, b) => a + b;
