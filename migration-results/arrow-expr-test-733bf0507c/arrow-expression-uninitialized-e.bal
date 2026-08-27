function testArrowExprWithUninitializedClosureVars() {
    int i;
    int m;
    function (int) returns int addFunc1 = a => a + // @error
        i + // @error
        m; // @error
}
