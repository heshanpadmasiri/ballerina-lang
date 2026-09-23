import ballerina/io;

type Person record {
    string name;
};

type Employee record {
    string name;
    boolean intern;
};

Person person1 = { name: "Person 1" };
Employee employee1 = { name: "Employee 1", intern: true };
Employee employee2 = { name: "Employee 2", intern: false };

function tupleDestructureTest1() returns [int, string] {
	[int, string] x = [1, "a"];
    int a;
    string b;
    [a, b] = x;
    return [a, b];
}

function tupleDestructureTest2() returns [int, int[]] {
    [int, int, int, int] x = [1, 2, 3, 4];
    int a;
    int[] b;
    [a, ...b] = x;
    return [a, b];
}

function tupleDestructureTest3() returns [int, int[]] {
    [int, int, int...] x = [1, 2, 3, 4];
    int a;
    int[] b;
    [a, ...b] = x;
    return [a, b];
}

function tupleDestructureTest4() returns int[] {
    [int...] x = [1, 2, 3, 4];
    int[] a;
    [...a] = x;
    return a;
}

function tupleDestructureTest5() returns [int, int[]] {
    [int, int, int...] x = [1, 2, 3, 4];
    int a;
    int[] b;
    [a, ...b] = x;
    return [a, b];
}

function tupleDestructureTest6() returns [int, string[]] {
    [int, string, string] x = [1, "a", "b"];
    int a;
    string[] b;
    [a, ...b] = x;
    return [a, b];
}

function tupleDestructureTest7() returns [int, string[]] {
    [int, string...] x = [1, "a", "b"];
    int a;
    string[] b;
    [a, ...b] = x;
    return [a, b];
}

function tupleDestructureTest8() returns [int, string, string[]] {
    [int, string, string, string...] x = [1, "a", "b"];
    int a;
    string b;
    string[] c;
    [a, b, ...c] = x;
    return [a, b, c];
}

type FooRecord record {|
    string field1;
    [int, float] field2;
|};

function tupleDestructureTest9() returns [boolean, string, [int, float]] {
    FooRecord foo = {
        field1: "string value",
        field2: [25, 12.5]
    };

    boolean a;
    string b;
    [int, float] c;
    [a, { field1: b, field2: c }] = [true, foo];

    return [a, b, c];
}

function tupleDestructureTest10() {
    Employee[2] employees = [employee1, employee2];

    Employee e1;
    Employee e2;
    [e1, e2] = [...employees];
    assertEquality(true, e1.intern);

    Employee e3;
    Employee e4;
    [e3, e4] = [...[employee1, employee2]];
    assertEquality(true, e3.intern);

    Employee e5;
    Employee e6;
    [[e5, e6]] = [...[...[employees]]];
    assertEquality(false, e6.intern);

    Employee e7;
    Employee e8;
    [[e7, e8]] = [[...[...[employee1, employee2]]]];
    assertEquality(false, e8.intern);
}

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }

    panic error("expected '" + expected.toBalString() + "', found '" + actual.toBalString() + "'");
}

public function main() {
    var returns1 = tupleDestructureTest1();
    io:println(returns1.length()); // @output 2
    io:println(returns1[0]); // @output 1
    io:println(returns1[1]); // @output a

    var returns2 = tupleDestructureTest2();
    io:println(returns2.length()); // @output 2
    io:println(returns2[0]); // @output 1
    io:println(returns2[1]); // @output [2,3,4]

    var returns3 = tupleDestructureTest3();
    io:println(returns3.length()); // @output 2
    io:println(returns3[0]); // @output 1
    io:println(returns3[1]); // @output [2,3,4]

    var returns4 = tupleDestructureTest4();
    io:println(returns4.length()); // @output 4
    io:println(returns4); // @output [1,2,3,4]

    var returns5 = tupleDestructureTest5();
    io:println(returns5.length()); // @output 2
    io:println(returns5[0]); // @output 1
    io:println(returns5[1]); // @output [2,3,4]

    var returns6 = tupleDestructureTest6();
    io:println(returns6.length()); // @output 2
    io:println(returns6[0]); // @output 1
    io:println(returns6[1]); // @output ["a","b"]

    var returns7 = tupleDestructureTest7();
    io:println(returns7.length()); // @output 2
    io:println(returns7[0]); // @output 1
    io:println(returns7[1]); // @output ["a","b"]

    var returns8 = tupleDestructureTest8();
    io:println(returns8.length()); // @output 3
    io:println(returns8[0]); // @output 1
    io:println(returns8[1]); // @output a
    io:println(returns8[2]); // @output ["b"]

    var returns9 = tupleDestructureTest9();
    io:println(returns9.length()); // @output 3
    io:println(returns9[0]); // @output true
    io:println(returns9[1]); // @output string value
    io:println(returns9[2]); // @output [25,12.5]

    tupleDestructureTest10();
}
