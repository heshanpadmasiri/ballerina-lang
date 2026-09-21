function testIntAsByte(int value) {
    byte converted = <byte> value; // @panic
}
public function main() {
    testIntAsByte(3055);
}
