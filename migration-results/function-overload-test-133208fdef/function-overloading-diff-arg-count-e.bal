function testOverloading(float a) {
    string dummy = "dummy";
}

function testOverloading(string a, int b) returns (string) { // @error
    return a + b.toString();
}
