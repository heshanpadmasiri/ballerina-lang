import ballerina/io;

public function main() {
    io:println(jsonReturnTest().toString()); // @output {"PropertyName":"Value"}
    tableReturnTestAsAny();
    inputAnyAsTableTest();
    io:println(anyMethodParameter()); // @output 9
    io:println(anyInStructTest()); // @output true
    io:println(successfulIntCasting()); // @output 5
    io:println(anyToAnyExplicitCasting().toString()); // @output {"PropertyName":"Value"}
    [any, int] multipleValues = multipleReturnWithAny();
    io:println(multipleValues[0].toString()); // @output {"PropertyName":"Value"}
    io:println(multipleValues[1]); // @output 7
    io:println(multipleParamWithAny()); // @output 5
    io:println(variableDefTest()); // @output 5
    io:println(assignmentTest()); // @output 44.3
    requireAnyArray(anyArrayWithMapArray());
}

function jsonReturnTest() returns any {
    any abc = jsonReturnFunction();
    return abc;
}

function jsonReturnFunction() returns json {
    json val = {"PropertyName": "Value"};
    return val;
}

function tableReturnTestAsAny() {
    any abc = tableReturnFunction();
    assertEquality("[{\"id\":1,\"name\":\"Jane\"},{\"id\":2,\"name\":\"Anne\"}]", abc.toString());
}

function inputAnyAsTableTest() {
    table<map<any>>? t = anyToTableFunction(tableReturnFunction());
    assertEquality("[{\"id\":1,\"name\":\"Jane\"},{\"id\":2,\"name\":\"Anne\"}]", t.toString());
}

function anyToTableFunction(any aTable) returns table<map<any>>? {
    if aTable is table<map<any>> {
        return aTable;
    }
    return ();
}

function tableReturnFunction() returns table<map<any>> {
    table<Employee> tb = table [
        {id: 1, name: "Jane"},
        {id: 2, name: "Anne"}
    ];
    return tb;
}

type Employee record {
    int id;
    string name;
};

function anyMethodParameter() returns any|error {
    int i = 9;
    return anyParam(i);
}

function anyParam(any val) returns int|error {
    int|error m = <int> val;
    return m;
}

function anyInStructTest() returns any {
    Sample sample = {i: 1, val: true, msg: "sampleVal"};
    return sample.val;
}

type Sample record {
    int i;
    any val;
    string msg;
};

function successfulIntCasting() returns int|error {
    any abc = floatReturn();
    float floatVal = <float> abc;
    int intVal = <int> floatVal;
    return intVal;
}

function floatReturn() returns float {
    float val = 5.4;
    return val;
}

function anyToAnyExplicitCasting() returns any {
    any abc = jsonReturnFunction();
    any val = abc;
    return val;
}

function multipleReturnWithAny() returns [any, int] {
    any abc = jsonReturnFunction();
    return [abc, 7];
}

function multipleParamWithAny() returns int {
    any abc = jsonReturnFunction();
    return multipleParam(abc, 5);
}

function multipleParam(any val, int sam) returns int {
    return sam;
}

function variableDefTest() returns any {
    any val = 5;
    return val;
}

function assignmentTest() returns any {
    any val;
    val = 44.3;
    return val;
}

function anyArrayWithMapArray() returns any[] {
    map<any>[] ma = [];
    any[] a = ma;
    return a;
}

function requireAnyArray(any[] value) {
    if value.length() == 0 {
        return;
    }
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }

    if expected === actual {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error(ASSERTION_ERROR_REASON,
        message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}
