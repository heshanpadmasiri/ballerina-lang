type Foo record {||};

function testAssignmentToTypeDef() {
    Foo = 5; // @error // @error
    Foo = Foo; // @error
    int a;
    [Foo, a] = [Foo, 1]; // @error
    [[Foo], a] = [[Foo], 2]; // @error
    [error(Foo), a] = [error("x"), 1]; // @error // @error
    error(Foo) = error("x"); // @error // @error
    [...Foo] = [Foo]; // @error // @error
    string b;
    error(b, Foo) = error("x", data=Foo); // @error // @error
}
