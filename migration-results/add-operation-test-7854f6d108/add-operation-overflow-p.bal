function overflowByAddition() {
    int num1 = 9223372036854775807;
    int num2 = 1;
    _ = num1 + num2; // @panic
}

public function main() {
    overflowByAddition();
}
