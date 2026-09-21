function testOutOfIntRangePositiveFloatInUnionAsInt() {
    any f = 99223372036854775807.0;
    int i = <int> f; // @panic
}
public function main() {
    testOutOfIntRangePositiveFloatInUnionAsInt();
}
