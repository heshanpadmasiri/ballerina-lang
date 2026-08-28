function testNegativeTests() {
    int nanVal = 0 / 0;
    int infinityVal = 7 / 0;
    int finiteVal = 10 / 5;
    boolean isNaN = nanVal.isNaN(); // @error
    boolean isInf = infinityVal.isInfinite(); // @error
    boolean isFin = nanVal.isFinite(); // @error

    string nan = nanVal.isNaN(); // @error
    boolean[] arr = infinityVal.isInfinite(); // @error
}
