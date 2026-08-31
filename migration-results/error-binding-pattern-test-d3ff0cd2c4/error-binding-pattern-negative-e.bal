function testNegative1() {
    int v1 = 0;
    match v1 {
        var error() => {} // @error
    }

    any v2 = 0;
    match v2 {
        var error() => {} // @error
    }
}
