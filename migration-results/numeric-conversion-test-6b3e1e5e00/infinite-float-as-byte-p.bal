function testInfiniteFloatAsByte() {
    float f = 1.0 / 0.0;
    byte i = <byte> f; // @panic
}
public function main() {
    testInfiniteFloatAsByte();
}
