function overflowByMultiplication() {
    int num1 = -1;
    int num2 = -9223372036854775807 - 1;
    int ans = num1 * num2; // @panic
}

public function main() {
    overflowByMultiplication();
}
