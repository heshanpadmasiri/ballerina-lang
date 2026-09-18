type ClosedFoo record {|
    string s;
    int i;
|};

type OpenedFoo record {
    string s;
    int i;
};

function testRecordUnreachablePattern() returns string {
    OpenedFoo k = {s: "A", i: 12};
    any _ = k;
    match k {
        var{x: name, y: age} => {return "A";} // @error
        var{x: name, y: [p, q]} => {return "A";} // @error
        var{x: name} => {return "A";} // @error
        var{x: name} => {return "A";} // @error
    }

    return "Default";
}

function testTupleUnreachablePattern() returns string {
    any an = 112;
    match an {
        var [a, b, {s, i}] => {return "A";} // @error
        var [a, b, c] => {return "A";} // @error
        var [a, b, c, d] => {return "A";} // @error
        var [a, b, c, {e, f}] => {return "A";} // @error
        var [a, b, c, [s, i]] => {return "A";} // @error

        var [a, {b}] => {return "A";} // @error
        var [a, {b, c}] => {return "A";} // @error
    }

    return "Default";
}

function testSimpleRules() returns string {
    any k = 1;
    match k {
        var {a} => {return "A";} // @error
        var {a, b} => {return "A";} // @error
        var {a} => {return "A";} // @error
    }

    match k {
        var [a, b] => {return "A";} // @error
        var [a, b, c] => {return "A";} // @error
        var [a, b] => {return "A";} // @error
    }

    match k {
        var x => {return "A";} // @error
        var y => {return "A";} // @error
        var {a, b} => {return "A";} // @error
        var [a, b] => {return "A";} // @error
        var y => {return "A";} // @error
    }

    return "Default"; // @error
}

function testMixedVariables() returns string {
    any k = 1;
    match k {
        var {x: name, y: [p, q]} => {return "A";} // @error
        var [a, b, c, {e, f}] => {return "A";} // @error
        var {x: name, y: age} => {return "A";} // @error
        var [a, b, c, d] => {return "A";} // @error
        var x => {return "A";} // @error
    }

    match k {
        var {x: name, y: age} => {return "A";} // @error
        var [a, b, c, d] => {return "A";} // @error
        var {x: name, y: [p, q]} => {return "A";} // @error
        var [a, b, c, {e, f}] => {return "A";} // @error
        var x => {return "A";} // @error
    }

    return "Default"; // @error
}

function testClosedRecordPatterns() returns string {
    any k = 1;
    match k {
        var { var1: name } => {return "A";} // @error
        var { var1: name2 } => {return "B";} // @error
        var { var3: name } => {return "C";} // @error
        var { var3: name } => {return "D";} // @error
        var [a, b, {var1, var2: [d, {var2}]}, c] => {return "E";} // @error
        var [a, b, {var1, var2: [d, { var2 }]}, c] => {return "D";} // @error
    }

    return "Default";
}

function testWithTypeGuard() returns string {
    any k = 1;
    match k {
        var [a, b] if a is string => {return "A";} // @error
        var [a, b] => {return "A";} // @error
        var [a, b] if a is int => {return "A";} // @error
        var [a, b, c] if a is boolean => {return "A";} // @error
        var [a, b, c] if a is boolean => {return "A";} // @error
        var [a, b] if a is string => {return "A";} // @error
    }

    return "A";
}

function testUnreachableReturnStmt() returns string {
    any k = 1;
    match k {
        var [a, b] if a is string => {return "A";} // @error
        var x => {x = "A";} // @error
    }

    match k {
        var [a, b] if a is string => {return "A";} // @error
        var x => {return  "B";} // @error
    }

    return "A"; // @error
}

function testUnreachableCode() returns string {
    any k = 1;
    match k {
        var x => {return "A";} // @error
        _ => {return "A";} // @error
    }
}

function testUnreachableCode2() returns string {
    any k = 1;
    match k {
        var x => {x = "A";} // @error
        _ => {k = "A";} // @error
    }
} // @error

function testUnreachableCode3() returns string {
    any k = 1;
    match k {
        var x => {return "A";} // @error
        _ => {return "A";} // @error
        "12" => {return "A";} // @error
        var [a, b] => {return "A";} // @error
    }

    return "A"; // @error
}
