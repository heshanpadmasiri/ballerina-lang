function testIntAsByteInUnions(int value) {
    int|boolean boxed = value;
    byte|boolean converted = <byte|boolean> boxed; // @panic
}
public function main() {
    testIntAsByteInUnions(-1);
}
