function testCodeAnalysingNegative() {
    int x = 2;
    error er = error("Message", i = x is int); // @error @error
}
