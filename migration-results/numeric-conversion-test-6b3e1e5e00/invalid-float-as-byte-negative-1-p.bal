function testFloatAsByte(float value) {
    byte converted = <byte> value; // @panic
}
public function main() {
    testFloatAsByte(-1.0);
}
