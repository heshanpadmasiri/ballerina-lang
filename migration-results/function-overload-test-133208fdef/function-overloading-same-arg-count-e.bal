function testOverloading(string a, int b) returns (string) {
    return a + b.toString();
}

function testOverloading(int a, int b) returns (int) { // @error
    return a + b;
}
