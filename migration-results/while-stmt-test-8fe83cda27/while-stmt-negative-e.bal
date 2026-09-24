function testIfStmtWithIncompatibleType() {
    while "foo" { // @error
        int a = 5;
    }
    while "bar" { // @error
        int a = 5;
    }
    while 5 { // @error
        int a = 5;
    }
    while [5, "foo"] { // @error
        int a = 5;
    }
}
