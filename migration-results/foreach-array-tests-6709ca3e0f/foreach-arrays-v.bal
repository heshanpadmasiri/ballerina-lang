import ballerina/io;

int[] data = [1, -3, 5, -30, 4, 11, 25, 10];
int sum = 0;
string output = "";

type Person record {| string name; int age; |};

function concatInt(int index, int value) {
    output += index.toString() + ":" + value.toString() + " ";
}

function concatFloat(int index, float value) {
    output += index.toString() + ":" + value.toString() + " ";
}

function concatString(int index, string value) {
    output += index.toString() + ":" + value + " ";
}

function concatBoolean(int index, boolean value) {
    output += index.toString() + ":" + value.toString() + " ";
}

function concatPerson(int index, Person value) {
    output += index.toString() + ":name=" + value.name + ",age=" + value.age.toString() + " ";
}

function testIntArrayWithArityOne() returns int {
    sum = 0;
    foreach int value in data {
        sum += value;
    }
    return sum;
}

function testIntArrayWithArityTwo() returns string {
    int[] values = [1, -3, 5, -30, 4, 11, 25, 10];
    output = "";
    int index = 0;
    foreach int value in values {
        concatInt(index, value);
        index += 1;
    }
    return output;
}

function testFloatArrayWithArityOne() returns string {
    float[] values = [1.123, -3.35244, 5.23, -30.45, 4.32, 11.56, 25.967, 10.345];
    output = "";
    foreach float value in values {
        concatFloat(0, value);
    }
    return output;
}

function testFloatArrayWithArityTwo() returns string {
    float[] values = [1.123, -3.35244, 5.23, -30.45, 4.32, 11.56, 25.967, 10.345];
    output = "";
    int index = 0;
    foreach float value in values {
        concatFloat(index, value);
        index += 1;
    }
    return output;
}

function testStringArrayWithArityOne() returns string {
    string[] values = ["foo", "bar", "bax", "baz"];
    output = "";
    foreach string value in values {
        concatString(0, value);
    }
    return output;
}

function testStringArrayWithArityTwo() returns string {
    string[] values = ["foo", "bar", "bax", "baz"];
    output = "";
    int index = 0;
    foreach string value in values {
        concatString(index, value);
        index += 1;
    }
    return output;
}

function testBooleanArrayWithArityOne() returns string {
    boolean[] values = [true, false, false, false, true, false];
    output = "";
    foreach boolean value in values {
        concatBoolean(0, value);
    }
    return output;
}

function testBooleanArrayWithArityTwo() returns string {
    boolean[] values = [true, false, false, false, true, false];
    output = "";
    int index = 0;
    foreach boolean value in values {
        concatBoolean(index, value);
        index += 1;
    }
    return output;
}

function testStructArrayWithArityOne() returns string {
    Person[] values = [{name: "bob", age: 10}, {name: "tom", age: 16}];
    output = "";
    foreach Person value in values {
        concatPerson(0, value);
    }
    return output;
}

function testStructArrayWithArityTwo() returns string {
    Person[] values = [{name: "bob", age: 10}, {name: "tom", age: 16}];
    output = "";
    int index = 0;
    foreach Person value in values {
        concatPerson(index, value);
        index += 1;
    }
    return output;
}

function testArrayInsertInt() returns string {
    int[] values = [0];
    values[3] = 3;
    values[6] = 6;
    output = "";
    int index = 0;
    foreach int value in values {
        concatInt(index, value);
        index += 1;
    }
    return output;
}

function testArrayInsertString() returns string {
    string[] values = ["d0"];
    values[3] = "d3";
    values[6] = "d6";
    output = "";
    int index = 0;
    foreach string value in values {
        concatString(index, value);
        index += 1;
    }
    return output;
}

function testArrayInsertInForeach() returns string {
    string[] values = ["d0", "d1", "d2"];
    output = "";
    int index = 0;
    foreach string value in values {
        int insertionIndex = index + 5;
        values[insertionIndex] = "d" + insertionIndex.toString();
        concatString(index, value);
        index += 1;
    }
    return output;
}

function testBreak() returns string {
    string[] values = ["d0", "d1", "d2"];
    output = "";
    int index = 0;
    foreach string value in values {
        if index == 1 {
            output += "break";
            break;
        }
        concatString(index, value);
        index += 1;
    }
    return output;
}

function testContinue() returns string {
    string[] values = ["d0", "d1", "d2"];
    output = "";
    int index = 0;
    foreach string value in values {
        if index == 1 {
            output += "continue ";
            index += 1;
            continue;
        }
        concatString(index, value);
        index += 1;
    }
    return output;
}

function testReturn() returns string {
    string[] values = ["d0", "d1", "d2"];
    output = "";
    int index = 0;
    foreach string value in values {
        if value == "d1" {
            return output;
        }
        concatString(index, value);
        index += 1;
    }
    return output;
}

function testArrayWithNullElements() returns string {
    output = "";
    string?[] values = ["d0", (), "d2", ()];
    int index = 0;
    foreach string? value in values {
        if value is string {
            output += index.toString() + ":" + value + " ";
        } else {
            output += index.toString() + ": ";
        }
        index += 1;
    }
    return output;
}

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    panic error("AssertionError");
}

function testQueryInsideLoop() {
    string[] values = ["a", "b", "c"];
    int total = 0;
    foreach string entity in values {
        string[] relationFields = from string each in values
            where entity + each != "foo"
            select each;
        total += relationFields.length();
    }
    assertEquality(9, total);
}

function testListConstructor() {
    int total = 0;
    foreach int value in [1, 2, 3] {
        total += value;
    }
    assertEquality(6, total);
}

function testTuple() {
    int total = 0;
    [int, int, int] values = [1, 2, 3];
    foreach int value in values {
        total += value;
    }
    assertEquality(6, total);
    total = 0;
    [int, int, int...] moreValues = [1, 2, 3, 4, 5];
    foreach int value in moreValues {
        total += value;
    }
    assertEquality(15, total);
}

function testEmptyArray() {
    output = "hello";
    foreach var _ in [] {
        output += "hello";
    }
    assertEquality(output, "hello");
}

function foo() returns int[] {
    return [1, 2, 3];
}

function testFunctionCall() {
    int total = 0;
    foreach int value in foo() {
        total += value;
    }
    assertEquality(6, total);
}

function testQueryExpressions() {
    int total = 0;
    foreach int value in from int item in [1, 2, 3] select item {
        total += value;
    }
    assertEquality(6, total);
}

function testMutatingArray() {
    int[] values = [1, 2, 3];
    int total = 0;
    foreach int _ in values {
        values = [1, ...values];
        total += values[0];
    }
    assertEquality(3, total);
    int[] prefixValues = [1, 2, 3];
    total = 0;
    foreach int value in prefixValues {
        values.push(10);
        total += value;
    }
    assertEquality(6, total);
    total = 0;
    values = [1, 2, 3];
    foreach int value in values {
        total += value;
        values = [4, 5, 6];
    }
    assertEquality(6, total);
}

public function main() {
    io:println(testIntArrayWithArityOne()); // @output 23
    io:println("[" + testIntArrayWithArityTwo() + "]"); // @output [0:1 1:-3 2:5 3:-30 4:4 5:11 6:25 7:10 ]
    io:println("[" + testFloatArrayWithArityOne() + "]"); // @output [0:1.123 0:-3.35244 0:5.23 0:-30.45 0:4.32 0:11.56 0:25.967 0:10.345 ]
    io:println("[" + testFloatArrayWithArityTwo() + "]"); // @output [0:1.123 1:-3.35244 2:5.23 3:-30.45 4:4.32 5:11.56 6:25.967 7:10.345 ]
    io:println("[" + testStringArrayWithArityOne() + "]"); // @output [0:foo 0:bar 0:bax 0:baz ]
    io:println("[" + testStringArrayWithArityTwo() + "]"); // @output [0:foo 1:bar 2:bax 3:baz ]
    io:println("[" + testBooleanArrayWithArityOne() + "]"); // @output [0:true 0:false 0:false 0:false 0:true 0:false ]
    io:println("[" + testBooleanArrayWithArityTwo() + "]"); // @output [0:true 1:false 2:false 3:false 4:true 5:false ]
    io:println("[" + testStructArrayWithArityOne() + "]"); // @output [0:name=bob,age=10 0:name=tom,age=16 ]
    io:println("[" + testStructArrayWithArityTwo() + "]"); // @output [0:name=bob,age=10 1:name=tom,age=16 ]
    io:println("[" + testArrayInsertInt() + "]"); // @output [0:0 1:0 2:0 3:3 4:0 5:0 6:6 ]
    io:println("[" + testArrayInsertString() + "]"); // @output [0:d0 1: 2: 3:d3 4: 5: 6:d6 ]
    io:println("[" + testArrayInsertInForeach() + "]"); // @output [0:d0 1:d1 2:d2 ]
    io:println(testBreak()); // @output 0:d0 break
    io:println("[" + testContinue() + "]"); // @output [0:d0 continue 2:d2 ]
    io:println("[" + testReturn() + "]"); // @output [0:d0 ]
    io:println("[" + testArrayWithNullElements() + "]"); // @output [0:d0 1: 2:d2 3: ]
    testQueryInsideLoop();
    testListConstructor();
    testTuple();
    testEmptyArray();
    testFunctionCall();
    testQueryExpressions();
    testMutatingArray();
}
