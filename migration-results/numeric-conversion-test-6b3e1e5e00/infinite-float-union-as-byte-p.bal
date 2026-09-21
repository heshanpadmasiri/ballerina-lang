function testInfiniteFloatInUnionAsByte() {
    float|boolean f = 2.0 / 0.0;
    byte i = <byte> f; // @panic
}
public function main() {
    testInfiniteFloatInUnionAsByte();
}
