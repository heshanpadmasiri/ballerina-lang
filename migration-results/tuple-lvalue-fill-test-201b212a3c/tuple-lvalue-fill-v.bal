import ballerina/io;

public function main() {
    testBasicLValueFillRead();
    testRestMemberFill();
    testNillableTupleType();
    testTupleInUnionTypes();
}

function preserveIoImport() {
    io:println();
}

function testBasicLValueFillRead() {
    [string, int[][]] itup = ["int"];
    itup[1][2][4] = 10;

    [string, float[][]] ftup = ["float"];
    ftup[1][4][3] = 12.34;
    ftup[1][2][2] = 45.67;
    ftup[1][2][5] = 6.78;

    [string, decimal[][]] dtup = ["decimal"];
    dtup[1][1][3] = 12.34;
    dtup[1][2][2] = 45.67;
    dtup[1][2][5] = 6.78;

    [string, boolean[][]] btup = ["boolean"];
    btup[1][3][3] = true;

    [string, string[][]] stup = ["string"];
    stup[1][3][3] = "foo";

    assert(<[string, int[][]]>["int", [[], [], [0, 0, 0, 0, 10]]], itup);
    assert(<[string, float[][]]>["float", [[], [], [0, 0, 45.67, 0, 0, 6.78], [], [0, 0, 0, 12.34]]], ftup);
    assert(<[string, decimal[][]]>["decimal", [[], [0, 0, 0, 12.34], [0, 0, 45.67, 0, 0, 6.78]]], dtup);
    assert(<[string, boolean[][]]>["boolean", [[], [], [], [false, false, false, true]]], btup);
    assert(<[string, string[][]]>["string", [[], [], [], ["", "", "", "foo"]]], stup);
}

type Person record {|
    string name = "Pubudu";
|};

function testRestMemberFill() {
    [string, int, Person[]...] tup = ["records", 100];
    tup[3][1] = {name: "John Doe"};
    tup[3][2].name = "Jane Doe";

    assert(<[string, int, Person[]...]>["records", 100, [], [{name: "Pubudu"}, {name: "John Doe"}, {name: "Jane Doe"}]], tup);
}

type Foo record {
    int id;
};

type Bar record {
    string name;
};

function myfunc1() returns Foo|[Foo[], Bar] {
    Foo[] arr = [];
    arr.push({id: 34});
    Bar bar = {name: "ABC"};
    return [arr, bar];
}

function testTupleInUnionTypes() {
    Foo|[Foo[], Bar] f = myfunc1();
    if (f is [Foo[], Bar]) {
        Foo[] x = f[0];
        Foo y = x[0];
        assert(y.id, 34);
    } else {
        panic error("f is not a tuple");
    }
}

function myfunc2() returns [Foo[], Bar]? {
    Foo[] arr = [];
    arr.push({id: 34});
    Bar bar = {name: "XYZ"};
    return [arr, bar];
}

function testNillableTupleType() {
    [Foo[], Bar]? f = myfunc2();
    if (f is [Foo[], Bar]) {
        Foo[] x = f[0];
        Foo y = x[0];
        assert(y.id, 34);
    } else {
        panic error("f is not a tuple");
    }
}

function assert(anydata expected, anydata actual) {
    if (expected == actual) {
        return;
    }
    typedesc<anydata> expT = typeof expected;
    typedesc<anydata> actT = typeof actual;
    string msg = "expected [" + expected.toString() + "] of type [" + expT.toString()
                        + "], but found [" + actual.toString() + "] of type [" + actT.toString() + "]";
    panic error("{AssertionError}", message = msg);
}
