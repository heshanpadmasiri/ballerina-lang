function testStaticTypeNotNil() {
    check 3; // @error @error
    check check 3; // @error @error @error
    check string `str ${check foo()}`; // @error @error
    check [1, 2, 3]; // @error @error
    check { i: 2, s: 3 }; // @error @error
    check new Obj(); // @error @error
    int|error x = 3;
    check x; // @error
    int? y = ();
    check y; // @error @error
}

function foo() returns string|error  {
    return error("MSG");
}

class Obj {
    function init() {
    }

    function foo() {
    }
}
