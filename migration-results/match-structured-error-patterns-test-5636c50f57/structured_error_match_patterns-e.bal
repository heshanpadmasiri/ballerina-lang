type ClosedFoo record {|
    string s;
    string message?;
    error cause?;
|};

function testErrorPattern1() returns string {
    any|error a = 13;
    match a {
        var error (reason, ... rest) => {return "A";} // @error // @error
        var error (reason, detail = detail) => {return "A";} // @error // @error // @error
    }

    match a {
        var error (reason, detail = detail) => {return "A";} // @error // @error
        var error (reason) => {return "A";} // @error
    }
    return "Default";
}

function testErrorPattern2() returns string {
    error <ClosedFoo> err = error("Err Code 1", s = "error");
    any|error a = err;
    match a {
        var error (reason, ...rest) => {return "A";} // @error // @error
        var error (reason, s = s) => {return "A";} // @error // @error // @error
    }

    match a {
        var error (reason, s = s) => {return "A";} // @error // @error
        var error (reason, s = s, ...rest) => {return "A";} // @error // @error // @error // @error
        var error (reason, s = s) => {return "A";} // @error // @error // @error
    }
    return "Default";
}

function testErrorPattern3() returns string {
    error <ClosedFoo> err = error("Err Code 1", s = "error");
    any|error a = err;
    match a {
        var error (reason, ...rest) => {return "A";} // @error // @error
        var error (reason, s = _) => {return "A";} // @error // @error
    }

    match a {
        var error (reason, ...rest) => {return "A";} // @error // @error
        var error (reason) => {return "A";} // @error // @error
    }
    return "Default";
}

type OpenedFoo record {
    string message;
    error cause?;
};

function testErrorPattern5() returns string {
    error <OpenedFoo> err = error("Err Code 1", message = "error");
    any|error a = err;
    match a {
        var error (reason, message = message, ...rest) => {return "A";} // @error // @error // @error
        var error (reason, extra = extra) => {return "A";} // @error // @error
    }

    match a {
        var error (reason, message = message, ...rest) => {return "A";} // @error // @error // @error
        var error (reason, message = message) => {return "A";} // @error // @error // @error
    }
    return "Default";
}
