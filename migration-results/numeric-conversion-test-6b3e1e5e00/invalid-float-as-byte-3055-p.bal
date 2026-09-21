function testFloatAsByte(float value) {
    byte converted = <byte> value; // @panic
}
public function main() {
    testFloatAsByte(3055.0);
}
