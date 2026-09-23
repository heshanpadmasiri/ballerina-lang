import ballerina/io;

public type Foo record {
    string code?;
    string message?;
};

public type Bar record {
    string processId?;
    Qux[] reasons?;
    boolean success?;
};

public type Baz record {
    *Bar;
    string id?;
    Foo[] reasons?;
};

public type Qux record {
    string code?;
    string message?;
};

public type Bdd Node|boolean;

public type Node readonly & record {|
    *R;
    int atom;
    Bdd left;
    Bdd middle;
    Bdd right;
|};

type R record {
};

function testRecordTypeResolving() {
    Baz & readonly baz = {reasons: [{code: "22", message: "message-22"}]};
    var reasons = baz?.reasons;
    if reasons is Foo[] {
        Foo foo = reasons[0];
        assertEquality("22", foo?.code);
        assertEquality("message-22", foo?.message);
    } else {
        panic error("Assertion error: expected Foo[], found: " + (typeof reasons).toString());
    }
}

function testRecordTypeResolvingWithTypeInclusion() {
    Node node = {
        atom: 0,
        left: false,
        middle: false,
        right: {atom: 1, left: false, middle: false, right: false}
    };
    var right = node.right;
    if right is Node {
        assertEquality(1, right.atom);
    } else {
        panic error("Expected Node, found: " + (typeof right).toString());
    }
}

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }
    if expected === actual {
        return;
    }
    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error("Assertion error: expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

function suppressOutput() returns boolean {
    return false;
}

public function main() {
    if suppressOutput() {
        io:println("");
    }
    testRecordTypeResolving();
    testRecordTypeResolvingWithTypeInclusion();
}
