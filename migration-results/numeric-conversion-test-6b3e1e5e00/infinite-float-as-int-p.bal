function testInfiniteFloatAsInt() {
    float f = 1.0 / 0.0;
    int i = <int> f; // @panic
}
public function main() {
    testInfiniteFloatAsInt();
}
