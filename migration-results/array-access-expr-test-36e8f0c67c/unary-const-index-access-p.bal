function testUnaryConstExpressionInIndexAccess() {
    int[2] a = [1, 2];
    int _ = a[~1]; // @panic
}

public function main() {
    testUnaryConstExpressionInIndexAccess();
}
