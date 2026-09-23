function overflowBySubtraction() {
    int num1 = -9223372036854775807 - 1;
    int num2 = 1;
    int ans = num1 - num2; // @panic
}

public function main() {
    overflowBySubtraction();
}
