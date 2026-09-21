function testInfiniteFloatInUnionAsInt() {
    float|boolean f = 2.0 / 0.0;
    int i = <int> f; // @panic
}
public function main() {
    testInfiniteFloatInUnionAsInt();
}
