function testNegative2() {
    error error myError(b) = error("1"); // @error
}

function testNegativeVar() {
    var error myError(b) = error("1"); // @error
}
