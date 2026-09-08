import ballerina/io;
import ballerina/jballerina.java;

type AnnotTupleOne record {|
    string value;
|};

type Details record {|
    string name;
    int age;
|};

annotation AnnotTupleOne annotOne on type, field;
annotation AnnotTupleOne annotTwo on type, field;
annotation Details details on field;

[@annotOne {value: "10"} int, @annotOne {value: "k"} int, string...] g1 = [1, 2, "hello", "world"];

function testAnnotationOnTupleFields() {
    string k = "chiranS";
    [@annotOne {value: "10"} int, @annotOne {value: k} int, string...] x1 = [1, 2, "hello", "world"];
    map<any> m1 = <map<any>>getAnonymousTupleAnnotations(typeof x1, "$field$.0");
    io:println(m1["annotOne"]); // @output {"value":"10"}
    map<any> m2 = <map<any>>getAnonymousTupleAnnotations(typeof x1, "$field$.1");
    io:println(m2["annotOne"]); // @output {"value":"chiranS"}
    map<any> m3 = <map<any>>getAnonymousTupleAnnotations(typeof g1, "$field$.0");
    io:println(m3["annotOne"]); // @output {"value":"10"}
    map<any> m4 = <map<any>>getAnonymousTupleAnnotations(typeof g1, "$field$.1");
    io:println(m4["annotOne"]); // @output {"value":"k"}
}

string gVar0 = "foo";

[@details {name: gVar0, age: gVar4} int, @details {name: "name", age: 0} int, string...] g4 = [1, 2, "hello", "world"];

function testAnnotationOnTupleFields2() {
    string name = "chiranS";
    int age = 26;
    [@details {name: name, age: age} int, @details {name: "name", age: 0} int, string...] x1 = [1, 2, "hello", "world"];
    map<any> m1 = <map<any>>getAnonymousTupleAnnotations(typeof x1, "$field$.0");
    io:println(m1["details"]); // @output {"name":"chiranS","age":26}
    map<any> m2 = <map<any>>getAnonymousTupleAnnotations(typeof x1, "$field$.1");
    io:println(m2["details"]); // @output {"name":"name","age":0}
    map<any> m3 = <map<any>>getAnonymousTupleAnnotations(typeof g4, "$field$.0");
    io:println(m3["details"]); // @output {"name":"foo","age":15}
    map<any> m4 = <map<any>>getAnonymousTupleAnnotations(typeof g4, "$field$.1");
    io:println(m4["details"]); // @output {"name":"name","age":0}
}

string gVar = "foo";
string gVar1 = "bar";
[@annotOne {value: gVar} int, int, string...] g2 = [1, 2, "hello", "world"];

function testAnnotationOnTupleWithGlobalVariable() {
    [@annotOne {value: gVar} int, int, string...] x1 = [1, 2, "hello", "world"];
    map<any> m1 = <map<any>>getAnonymousTupleAnnotations(typeof x1, "$field$.0");
    io:println(m1["annotOne"]); // @output {"value":"foo"}
    map<any> m2 = <map<any>>getAnonymousTupleAnnotations(typeof g2, "$field$.0");
    io:println(m2["annotOne"]); // @output {"value":"foo"}
}

[@annotOne {value: "foo"} @annotTwo {value: "bar"} int, @details {name: gVar2, age: 0} int, string...] g3 = [1, 2, "hello", "world"];

function testMultipleAnnotationsOnLocalTuple() {
    string k = "chiranS";
    [@annotOne {value: "foo"} @annotTwo {value: "bar"} int, @details {name: k, age: 0} int, string...] x1 = [1, 2, "hello", "world"];
    map<any> m1 = <map<any>>getAnonymousTupleAnnotations(typeof x1, "$field$.0");
    io:println(m1["annotOne"]); // @output {"value":"foo"}
    io:println(m1["annotTwo"]); // @output {"value":"bar"}
    map<any> m2 = <map<any>>getAnonymousTupleAnnotations(typeof x1, "$field$.1");
    io:println(m2["details"]); // @output {"name":"chiranS","age":0}
    map<any> m3 = <map<any>>getAnonymousTupleAnnotations(typeof g3, "$field$.0");
    io:println(m3["annotOne"]); // @output {"value":"foo"}
    io:println(m3["annotTwo"]); // @output {"value":"bar"}
    map<any> m4 = <map<any>>getAnonymousTupleAnnotations(typeof g3, "$field$.1");
    io:println(m4["details"]); // @output {"name":"baz","age":0}
}

function() returns [int] x = function() returns [@annotOne {value: "foo"} int] {return [1];};
function() returns [int] x2 = function() returns [@annotOne {value: gVar1} @annotTwo {value: gVar2} int] {return [1];};
function() returns [int, int] x3 = function() returns [@annotOne {value: gVar1} int, @details {name: "name", age: gVar3} int] {return [1, 1];};

function testTupleAnnotationsOnFunctionPointerReturnType() {
    map<any> m1 = <map<any>>getAnonymousTupleAnnotations(typeof x(), "$field$.0");
    io:println(m1["annotOne"]); // @output {"value":"foo"}
    map<any> m2 = <map<any>>getAnonymousTupleAnnotations(typeof x2(), "$field$.0");
    io:println(m2["annotOne"]); // @output {"value":"bar"}
    io:println(m2["annotTwo"]); // @output {"value":"baz"}
    map<any> m3 = <map<any>>getAnonymousTupleAnnotations(typeof x3(), "$field$.0");
    io:println(m3["annotOne"]); // @output {"value":"bar"}
    map<any> m4 = <map<any>>getAnonymousTupleAnnotations(typeof x3(), "$field$.1");
    io:println(m4["details"]); // @output {"name":"name","age":10}
}

string gVar2 = "baz";
int gVar3 = 10;

function func() returns [@annotOne {value: "foo"} int] {
    return [1];
}

function func1() returns [@annotOne {value: "foo"} @annotTwo {value: gVar2} int] {
    return [1];
}

function func2() returns [@details {name: "name", age: gVar4} int, @annotTwo {value: gVar2} int] {
    return [1, 1];
}

function testGlobalAnnotationsOnFunctionReturnType() {
    map<any> m1 = <map<any>>getAnonymousTupleAnnotations(typeof func(), "$field$.0");
    io:println(m1["annotOne"]); // @output {"value":"foo"}
    map<any> m2 = <map<any>>getAnonymousTupleAnnotations(typeof func1(), "$field$.0");
    io:println(m2["annotOne"]); // @output {"value":"foo"}
    io:println(m2["annotTwo"]); // @output {"value":"baz"}
    io:println(m2["annotTwo"]); // @output {"value":"baz"}
    io:println(m2["annotTwo"]); // @output {"value":"baz"}
    map<any> m3 = <map<any>>getAnonymousTupleAnnotations(typeof func2(), "$field$.0");
    io:println(m3["details"]); // @output {"name":"name","age":15}
    map<any> m4 = <map<any>>getAnonymousTupleAnnotations(typeof func2(), "$field$.1");
    io:println(m4["annotTwo"]); // @output {"value":"baz"}
}

int gVar4 = 15;

function func3([@annotOne {value: "foo"} int] a) {
    map<any> m1 = <map<any>>getAnonymousTupleAnnotations(typeof a, "$field$.0");
    io:println(m1["annotOne"]); // @output {"value":"foo"}
}

function func4([@annotOne {value: "foo"} int, @annotTwo {value: "foo"} @details {name: "name", age: gVar4} int] a) {
    map<any> m1 = <map<any>>getAnonymousTupleAnnotations(typeof a, "$field$.0");
    io:println(m1["annotOne"]); // @output {"value":"foo"}
    map<any> m2 = <map<any>>getAnonymousTupleAnnotations(typeof a, "$field$.1");
    io:println(m2["annotTwo"]); // @output {"value":"foo"}
    io:println(m2["details"]); // @output {"name":"name","age":15}
}

function testGlobalAnnotationsOnFunctionParameterType() {
    func3([10]);
    func4([10, 10]);
}

function testTupleMemberAnnotations1() returns [@annotOne {value: "foo"} int, @details {name: "name", age: gVar3} int] {
    return [1, 1];
}

function testTupleMemberAnnotations2() returns [@annotOne {value: gVar1} @annotTwo {value: gVar2} int] {
    return [1];
}

function testTupleMemberAnnotations() {
    map<any> m1 = <map<any>>getAnonymousTupleAnnotations(typeof testTupleMemberAnnotations1(), "$field$.0");
    io:println(m1["annotOne"]); // @output {"value":"foo"}
    map<any> m2 = <map<any>>getAnonymousTupleAnnotations(typeof testTupleMemberAnnotations1(), "$field$.1");
    io:println(m2["details"]); // @output {"name":"name","age":10}
    map<any> m3 = <map<any>>getAnonymousTupleAnnotations(typeof testTupleMemberAnnotations2(), "$field$.0");
    io:println(m3["annotOne"]); // @output {"value":"bar"}
    io:println(m3["annotTwo"]); // @output {"value":"baz"}
}

function getAnonymousTupleAnnotations(typedesc<any> obj, string annotName) returns any =
@java:Method {
    'class: "io/ballerina/runtime/internal/TypeChecker",
    name: "getAnnotValue"
} external;

public function main() {
    testAnnotationOnTupleFields();
    testAnnotationOnTupleFields2();
    testAnnotationOnTupleWithGlobalVariable();
    testMultipleAnnotationsOnLocalTuple();
    testTupleAnnotationsOnFunctionPointerReturnType();
    testGlobalAnnotationsOnFunctionReturnType();
    testGlobalAnnotationsOnFunctionParameterType();
    testTupleMemberAnnotations();
}
