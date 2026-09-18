import ballerina/io;

type Foo record {
    string s;
    int i;
    [float, int, boolean] fib;
};

function testStructuredMatchPatternsBasic1() returns string {
    Foo foo = {s: "S", i: 23, fib: [5.6, 3, true]};

    match foo {
        var {s, i: integer, fib: [a, b, c]} => {
            integer += 1;
            a += 1f;
            b += 1;
            return "Matched Values : " + s + ", " + integer.toString() + ", " + a.toString() + ", " + b.toString() +
                    ", " + c.toString();
        }
    }

    return "Default";
}

type Foo2 record {
    string s;
    int i;
    float f;
};

type Bar record {
    byte b;
    Foo2 f;
};

function testStructuredMatchPatternsBasic2() returns string {
    Foo2 foo = {s: "S", i: 23, f: 5.6};
    Bar bar = {b: 12, f: foo};
    [Foo2, [int, Bar], byte] tuple = [foo, [100, bar], 200];
    match tuple {
        var [{s, i, f}, [i2, {b, f: {s: s2, i: i3, f: f2}}], b2] => {
            i3 += 1;
            return "Matched Values : " + s + ", " + i.toString() + ", " + f.toString() + ", " + i2.toString() + ", " +
                        b.toString() + ", " + s2 + ", " + i3.toString() + ", " + f2.toString() + ", " + b2.toString();
        }
    }
}

function testErrorShouldNotMatchWildCardPatternVarIgnore() returns string {
    any|error v = error("{UserGenError}Error");
    match v {
        0 => { return "zero"; }
        var _ => { return "other"; }
    }
    return "no-match";
}

function testErrorNotMatchingVarIgnoreAndFallThroughToErrorPattern() returns string {
    any|error v = error("{UserGenError}Error");
    match v {
        0 => { return "zero"; }
        var _ => { return "other"; }
        error(var r) => { return <string> r; }
    }
    return "no-match";
}

public function main() {
    io:println(testStructuredMatchPatternsBasic1()); // @output Matched Values : S, 24, 6.6, 4, true
    io:println(testStructuredMatchPatternsBasic2()); // @output Matched Values : S, 23, 5.6, 100, 12, S, 24, 5.6, 200
    io:println(testErrorShouldNotMatchWildCardPatternVarIgnore()); // @output no-match
    io:println(testErrorNotMatchingVarIgnoreAndFallThroughToErrorPattern()); // @output {UserGenError}Error
}
