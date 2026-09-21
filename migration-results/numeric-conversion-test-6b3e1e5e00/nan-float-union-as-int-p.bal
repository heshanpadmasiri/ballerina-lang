function testNaNFloatInUnionAsInt() {
    float|int f = 0.0 / 0.0;
    int i = <int> f; // @panic
}
public function main() {
    testNaNFloatInUnionAsInt();
}
