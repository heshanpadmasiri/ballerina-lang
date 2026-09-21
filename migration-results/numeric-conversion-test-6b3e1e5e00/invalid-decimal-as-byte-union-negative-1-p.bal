type Employee record {| string name; |};
function testDecimalAsByteInUnions(decimal value) {
    Employee|string|decimal boxed = value;
    byte|Employee converted = <byte|Employee> boxed; // @panic
}
public function main() {
    testDecimalAsByteInUnions(-1.0);
}
