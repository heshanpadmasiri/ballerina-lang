function testNaNFloatInUnionAsByte() {
    float|boolean f = 0.0 / 0.0;
    byte i = <byte> f; // @panic
}
public function main() {
    testNaNFloatInUnionAsByte();
}
