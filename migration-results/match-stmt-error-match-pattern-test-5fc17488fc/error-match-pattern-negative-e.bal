type MyError1 error<record { int x; }>;
type MyError2 error<record { int y; }>;
type MyError3 error;
type MyError4 error;
type MyError5 distinct error;
type MyError6 distinct error;
type MyError7 distinct error & readonly;
type MyError8 distinct error & readonly;
type MyError9 distinct error|int;
type MyError10 distinct error|int;

function testNegative1() {
    int v1 = 0;
    match v1 {
        error() => {} // @error
    }

    any v2 = 0;
    match v2 {
        error() => {} // @error
    }

    MyError1 v3 = error MyError1("Message", x = 2);
    match v3 {
        error MyError2(y = 4) => {} // @error
    }
}

function testNegative2() {
    any|error v = 2;
    match v {
        error() | error() => {} // @error
        error("Message") | error("Message") => {} // @error
        error(_) | error(_) => {} // @error
        error(var a) | error(var b) => {} // @error
        error("Message", error("foo")) | error("Message", error("foo")) => {} // @error
        error("Message", error("Msg"), x = 2) | error("Message", error("Msg"), x = 2) => {} // @error
        error("Message", error("Msg"), x = 4) | error("Message", error("Msg"), x = 3) => {}
        error MyError1("Message", x = 4) | error MyError1("Message", x = 4) => {} // @error
    }
}

function testNegative3() {
    error v1 = getCustomError();
    match v1 {
        var errorA if v1 is MyError1 => { } // @error
        var errorB if v1 is MyError2 => { } // @error
    }

    error? v2 = getCustomError();
    match v2 {
        var errorC if v2 is MyError1 => { } // @error
        var errorD if v2 is MyError2 => { } // @error
    }
}

function testNegative4() {
    error v1 = getCustomError();
    match v1 {
        var errorA if v1 is MyError3 => { } // @error
        var errorB if v1 is MyError4 => { } // @error
    }

    error? v2 = getCustomError();
    match v2 {
        var errorC if v2 is MyError3 => { } // @error
        var errorD if v2 is MyError4 => { } // @error
    }
}

function testNegative5() {
    error v1 = getCustomError();
    match v1 {
        var errorA if v1 is MyError5 => { } // @error
        var errorB if v1 is MyError6 => { } // @error
    }

    error? v2 = getCustomError();
    match v2 {
        var errorC if v2 is MyError5 => { } // @error
        var errorD if v2 is MyError6 => { } // @error
    }
}

function testNegative6() {
    error v1 = getCustomError();
    match v1 {
        var errorA if v1 is MyError7 => { } // @error
        var errorB if v1 is MyError8 => { } // @error
    }

    error? v2 = getCustomError();
    match v2 {
        var errorC if v2 is MyError7 => { } // @error
        var errorD if v2 is MyError8 => { } // @error
    }
}

function testNegative7() {
    error v1 = getCustomError();
    match v1 {
        var errorA if v1 is MyError9 => { } // @error
        var errorB if v1 is MyError10 => { } // @error
    }

    error? v2 = getCustomError();
    match v2 {
        var errorC if v2 is MyError9 => { } // @error
        var errorD if v2 is MyError10 => { } // @error
    }
}

function getCustomError() returns error {
    return error MyError1("Message", x = 2);
}
