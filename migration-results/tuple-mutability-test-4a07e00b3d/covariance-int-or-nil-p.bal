public function main() {
    [int, int, ()] x = [1, 2, ()];
    [int, int?, ()] y = x;
    y[0] = 5;
    y[1] = 6;
    y[1] = (); // @panic error: {ballerina/lang.array}InherentTypeViolation {"message":"incompatible types: expected 'int', found '()'"}
}
