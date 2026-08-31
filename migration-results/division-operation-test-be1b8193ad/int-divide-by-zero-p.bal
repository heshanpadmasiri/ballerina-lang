public function main() {
    _ = intDivide(2000, 0);
}

function intDivide(int a, int b) returns int {
    return a / b; // @panic
}
