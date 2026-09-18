type ClosedFoo record {|
    string s;
    int i;
|};

type OpenedFoo record {
    string s;
    int i;
};

function testRecordInvalidPattern() returns string {
    ClosedFoo foo = {s: "S", i: 23};
    match foo {
        var {s, i: integer, f: [a, b, c]} => {return "A";} // @error
        var {s, i: integer, f} => {return "A";} // @error
        var {s, i: integer} => {return "A";} // @error
        var {s} => {return "A";} // @error
        var {a} => {return "A";} // @error
        "12" => {return "A";} // @error
        var [s, i] => {return "A";} // @error
    }

    OpenedFoo foo1 = {s: "S", i: 23};
    match foo1 {
        var {s, i: integer, f: [a, b, c]} => {return "A";} // @error
        var {s, i: integer, f} => {return "A";} // @error
        var {s, i: integer} => {return "A";} // @error
        var {s} => {return "A";} // @error
        var {a} => {return "A";} // @error
        "12" => {return "A";} // @error
        var [s, i] => {return "A";} // @error
    }

    return "Default";
}

function testTupleInvalidPattern() returns string {
    ClosedFoo foo = {s: "S", i: 23};
    [string, int, ClosedFoo] t = ["A", 12, foo];
    match t {
        var [a, b] => {return "A";} // @error
        var {s, i} => {return "A";} // @error
        "12" => {return "A";} // @error
        var [a, b, [d, e]] => {return "A";} // @error
        var [a, b, {s}] => {return "A";} // @error
        var [a, b, {s, i, f}] => {return "A";} // @error
        var [a, b, {s, i}] => {return "A";} // @error
        var [a, b, c] => {return "A";} // @error
    }
    return "Default"; // @error
}

function singleMatchStmt() returns string {
    any k = 1;
    match k {
        var x => {return "A";} // @error
    }
}
