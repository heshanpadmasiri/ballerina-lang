function testOutOfIntRangeNegativeFloatInUnionAsInt() {
    anydata f = -81223372036854775807.0;
    int i = <int> f; // @panic
}
public function main() {
    testOutOfIntRangeNegativeFloatInUnionAsInt();
}
