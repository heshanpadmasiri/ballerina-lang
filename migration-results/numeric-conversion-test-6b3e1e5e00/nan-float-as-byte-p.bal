function testNaNFloatAsByte() {
    float f = 0.0 / 0.0;
    byte i = <byte> f; // @panic
}
public function main() {
    testNaNFloatAsByte();
}
