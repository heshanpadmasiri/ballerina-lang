function testOutOfIntRangeNegativeDecimalInUnionAsInt() {
    decimal d = -81223372036854775807.0;
    anydata f = d;
    int i = <int> f; // @panic
}
public function main() {
    testOutOfIntRangeNegativeDecimalInUnionAsInt();
}
