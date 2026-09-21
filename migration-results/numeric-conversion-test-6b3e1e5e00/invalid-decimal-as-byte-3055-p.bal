function testDecimalAsByte(decimal value) {
    byte converted = <byte> value; // @panic
}
public function main() {
    testDecimalAsByte(3055.0);
}
