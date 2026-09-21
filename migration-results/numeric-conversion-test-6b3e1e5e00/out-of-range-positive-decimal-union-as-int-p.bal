function testOutOfIntRangePositiveDecimalInUnionAsInt() {
    decimal d = 99223372036854775807.0;
    decimal|int f = d;
    int i = <int> f; // @panic
}
public function main() {
    testOutOfIntRangePositiveDecimalInUnionAsInt();
}
