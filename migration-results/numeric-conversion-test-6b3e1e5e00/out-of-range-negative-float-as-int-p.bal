function testOutOfIntRangeNegativeFloatAsInt() {
    float f = -9223372036854775807.6;
    int i = <int> f; // @panic
}
public function main() {
    testOutOfIntRangeNegativeFloatAsInt();
}
