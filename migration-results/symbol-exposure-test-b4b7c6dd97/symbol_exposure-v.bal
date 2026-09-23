import ballerina/io;

public type Foo record {
    string name;
    Foo[] x?;
}[];

public function getFooName(Foo f) returns string => f[0].name;

public function testPublicFunctionWithRecursiveArrayTypedParam() {
    Foo foo = [{name: "Foo"}];
    assertEquality("Foo", getFooName(foo));
}

public function main() {
    io:println(testPublicFunctionWithRecursiveArrayTypedParam()); // @output
}

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    panic error(string `expected '${expected.toString()}', found '${actual.toString()}'`);
}
