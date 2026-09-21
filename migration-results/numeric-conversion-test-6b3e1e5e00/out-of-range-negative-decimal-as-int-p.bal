function testOutOfIntRangeNegativeDecimalAsInt() {
    decimal f = -9323372036854775807.6;
    int i = <int> f; // @panic
}
public function main() {
    testOutOfIntRangeNegativeDecimalAsInt();
}
