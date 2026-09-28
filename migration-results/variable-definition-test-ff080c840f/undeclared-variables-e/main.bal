function testUndeclaredVariables() returns int {
    return a; // @error
}
