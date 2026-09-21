function testOutOfIntRangePositiveFloatAsInt() {
    float f = 9223372036854775807.5;
    int i = <int> f; // @panic
}
public function main() {
    testOutOfIntRangePositiveFloatAsInt();
}
