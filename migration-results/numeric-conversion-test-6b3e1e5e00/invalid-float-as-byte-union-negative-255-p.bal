type Employee record {| string name; |};
function testFloatAsByteInUnions(float value) {
    Employee|string|float f2 = value;
    byte s6 = <byte> f2; // @panic
}
public function main() {
    testFloatAsByteInUnions(-255.0);
}
