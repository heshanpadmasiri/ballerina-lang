import ballerina/io;

function narrowTypeInCaptureBindingPattern1(int|string v) returns string {
    match v {
        var a if a is int => { return a.toString(); }
        _ => { return v; }
    }
}

function testNarrowTypeInCaptureBindingPattern1() {
    io:println(narrowTypeInCaptureBindingPattern1(2)); // @output 2
    io:println(narrowTypeInCaptureBindingPattern1("str")); // @output str
}

function narrowTypeInCaptureBindingPattern2(int|string|boolean v) returns string {
    match v {
        var a if a is int => { return a.toString(); }
        var a if a is boolean => { return a.toString(); }
        _ => { return v; }
    }
}

function testNarrowTypeInCaptureBindingPattern2() {
    io:println(narrowTypeInCaptureBindingPattern2("str")); // @output str
}

function narrowTypeInListBindingPattern1([int|string, int] v) returns string {
    match v {
        [var a, var b] if a is int => { return ""; }
        _ => { return v[0]; }
    }
}

function testNarrowTypeInListBindingPattern1() {
    io:println(narrowTypeInListBindingPattern1(["str", 2])); // @output str
}

function narrowTypeInListBindingPattern2([int|string|boolean, int] v) returns string {
    match v {
        [var a, var b] if a is int => { return "int"; }
        [var a, var b] if a is boolean => { return "boolean"; }
        _ => { return v[0]; }
    }
}

function testNarrowTypeInListBindingPattern2() {
    io:println(narrowTypeInListBindingPattern2(["str", 2])); // @output str
}

function narrowTypeInListBindingPattern3([int|string, int|string] v) returns string {
    match v {
        [var a, var b] if a is int && b is int => { return "match1"; }
        [var a, var b] if a is int && b is string => { return "match2"; }
        [var a, var b] if a is string && b is int => { return "match3"; }
        _ => { return v[0] + v[1]; }
    }
}

function testNarrowTypeInListBindingPattern3() {
    io:println(narrowTypeInListBindingPattern3(["Hello ", "World"])); // @output Hello World
}

function testMatchClauseWithQuery() {
    int|string i = 3;
    int|int[] result;
    match i {
        var _ if i is int => {
            result = from var _ in [1, 2]
                where i + 2 == 5
                select 2;
        }
        _ => { result = 2; }
    }
    io:println(result); // @output [2,2]
}

type Insn record { string op; };

function getValidInsn(Insn insn) returns string? {
    match insn {
        var {op} if op is "+" => { return "+"; }
        var {op} if op is "-" => { return "-"; }
        var {op} if op is "%" => { return "%"; }
    }
    return ();
}

function testMatchClauseWithTypeGuard1() {
    io:println(getValidInsn({op: "+"})); // @output +
    io:println(getValidInsn({op: "-"})); // @output -
    io:println(getValidInsn({op: "="})); // @output
}

const ONE = 1;
const ONE2 = 1;

function testMatchClauseWithTypeGuard2() {
    int value = 2;
    string matched = "Not Matched";
    match value {
        var a if a is 2 => { matched = "Two"; }
        var a if a is 1 => { matched = "One"; }
    }
    io:println(matched); // @output Two
}

function testMatchClauseWithTypeGuard3() {
    int value = 2;
    string matched = "Not Matched";
    match value {
        var a if a is 1|2 => { matched = "One or Two"; }
        var a if a is 3|4 => { matched = "Three or Four"; }
    }
    io:println(matched); // @output One or Two
}

type A_MSN 3|4;
type B_MSN 1|2;
type BB_MSN 3;

function testMatchClauseWithTypeGuard4() {
    int value = 2;
    string matched = "Not Matched";
    match value {
        var a if a is A_MSN => { matched = "Three or Four"; }
        var a if a is B_MSN => { matched = "One or Two"; }
    }
    io:println(matched); // @output One or Two
    match value {
        var a if a is B_MSN => { matched = "One or Two"; }
        var a if a is BB_MSN => { matched = "Three"; }
    }
    io:println(matched); // @output One or Two
}

function testMatchClauseWithTypeGuard5() {
    int|float value = 2;
    string matched = "Not Matched";
    match value {
        var a if a is boolean|float => { matched = "Boolean or Float"; }
        var a if a is int|string => { matched = "Int or String"; }
    }
    io:println(matched); // @output Int or String
    match value {
        var a if a is int|string => { matched = "Int or String"; }
        var a if a is boolean|int|float => { matched = "Boolean or Int or Float"; }
    }
    io:println(matched); // @output Int or String
}

type C int|string;
type D boolean|float;

function testMatchClauseWithTypeGuard6() {
    int|float value = 2;
    string matched = "Not Matched";
    match value {
        var a if a is C => { matched = "Int or String"; }
        var a if a is D => { matched = "Boolean or Float"; }
    }
    io:println(matched); // @output Int or String
}

type PersonMtStmt record {|
    string name;
    int age;
    AddressMtStmt address;
|};
type AddressMtStmt record { string street; int houseNo; string city; };
type AddressWithProvinceMtStmt record { string street; int houseNo; string city; string province; };
type E 100|200;

function testMatchClauseWithTypeGuard7() {
    PersonMtStmt person = {name: "John", age: 12, address: {street: "Main Street", houseNo: 10, city: "Colombo",
                    "country": "Sri Lanka"}};
    string matched = "Not Matched";
    int age = 0;
    string street = "";
    PersonMtStmt newPerson = person;
    match person {
        {name: var a, ...var b} if a is string && b is record {|int age; AddressWithProvinceMtStmt address;|} => {
            matched = "Pattern1";
            age = b.age;
            street = b.address.street;
        }
        {name: var a, ...var b} if a is string && b is record {|int age; AddressMtStmt address;|} => {
            matched = "Pattern2";
            age = b.age;
            street = b.address.street;
            match b {
                {age: var c, address: var d} if age is 10 && d.houseNo is E => {
                    matched += " Pattern3";
                    newPerson = {name: a, age: c, address: d};
                }
                {age: var c, address: var d} if age is 12 && d.houseNo is C => {
                    matched += " Pattern4";
                    string newName = a + " Smith";
                    newPerson = {name: newName, age: c + 10, address: d};
                }
            }
        }
    }
    io:println(matched); // @output Pattern2 Pattern4
    io:println(age); // @output 12
    io:println(street); // @output Main Street
    io:println(street); // @output Main Street
    io:println(newPerson.name); // @output John Smith
    io:println(newPerson.age); // @output 22
    io:println(newPerson.address); // @output {"street":"Main Street","houseNo":10,"city":"Colombo","country":"Sri Lanka"}
}

function testMatchClauseWithTypeGuard8() {
    [int, string, float] t1 = [12, "ABC", 20.34];
    string matched = "Not Matched";
    match t1 {
        var [a, b, ...c] if a is 12 && b is "DEF" => { matched = "Pattern1"; }
        [var a, var b, ...var c] if a is 12 && b is "ABC" => { matched = "Pattern2"; }
    }
    io:println(matched); // @output Pattern2
}

function testMatchClauseWithTypeGuard9() {
    [int, string, [int...]] t1 = [12, "ABC", [10, 20, 30, 40]];
    string matched = "Not Matched";
    match t1 {
        var [a, b, c] if a is 12 && c[0] is 20 => { matched = "Pattern1"; }
        [var a, var b, var c] if a is 12 && c[0] is 10 => { matched = "Pattern2"; }
    }
    io:println(matched); // @output Pattern2
    matched = "Not Matched";
    match t1 {
        var [a, b, c] if c is [1, 2] => { matched = "Pattern1"; }
        [var a, var b, var c] if c is [10, 20, 30] => { matched = "Pattern2"; }
    }
    io:println(matched); // @output Not Matched
    match t1 {
        var [a, b, c] if c is [1, 2, 3] => { matched = "Pattern1"; }
        [var a, var b, var c] if c is [10, 20, 30] => { matched = "Pattern2"; }
    }
    io:println(matched); // @output Not Matched
}

function testMatchClauseWithTypeGuard10() {
    int[] t1 = [10, 20, 30, 40];
    string matched = "Not Matched";
    match t1 {
        var a if a[0] is 10 && a[1] is int|string && a[2] is A_MSN => { matched = "Pattern1"; }
        var a if a[0] is 10 && a[1] is int|string && a[2] is 30|40 => { matched = "Pattern2"; }
    }
    io:println(matched); // @output Pattern2
}

function testMatchClauseWithTypeGuard11() {
    [int, string[], map<string>] t1 = [1, ["A", "B", "C", "D"], {name: "John"}];
    string matched = "Not Matched";
    match t1 {
        [var a, var b, var c] if a is ONE && b is string[] && c is map<string> => {
            matched = "Pattern1";
            match b {
                var [...d] if d[2] is "A"|"B" => { matched += " Pattern2"; }
                var [...d] if d[2] is "C"|"D" => { matched += " Pattern3"; }
            }
            match c {
                {name: var e} if e is "Anne"|"Mike" => { matched += " Pattern4"; }
                {name: var e} if e is "Frank"|"John" => { matched += " Pattern5"; }
            }
        }
    }
    io:println(matched); // @output Pattern1 Pattern3 Pattern5
}

function testMatchClauseWithTypeGuard12() {
    error err = error("Transaction Error", error("Internal Error", cause={reason: "Connection failure", level: 3},
                retryCount=5), flag=true, commitCount=2, reportTo="John");
    string matched = "Not Matched";
    match err {
        var error(a, b, flag=c, ...d) if a is "Internal Error" || a is "Transaction Error" => {
            matched = "Pattern1";
            match b {
                error("Internal Error", cause=var e, retryCount=var f) if e is map<string> && f is float => {
                    matched += " Pattern3";
                }
                error("Internal Error", cause=var e, retryCount=var f) if e is map<anydata> && f is 5 => {
                    matched += " Pattern4 with error retry count:" + f.toString();
                    match e {
                        {reason: var g, ...var h} if g is "Connection failure" || g is "Database failure" &&
                                             h is record {int level;} => {
                            matched += " Pattern5 with reason:" + g;
                        }
                    }
                }
            }
        }
        var error(a, b, flag=c, ...d) if a is "Transaction Error" => { matched = "Pattern2"; }
    }
    io:println(matched); // @output Pattern1 Pattern4 with error retry count:5 Pattern5 with reason:Connection failure
}

public function main() {
    testNarrowTypeInCaptureBindingPattern1();
    testNarrowTypeInCaptureBindingPattern2();
    testNarrowTypeInListBindingPattern1();
    testNarrowTypeInListBindingPattern2();
    testNarrowTypeInListBindingPattern3();
    testMatchClauseWithQuery();
    testMatchClauseWithTypeGuard1();
    testMatchClauseWithTypeGuard2();
    testMatchClauseWithTypeGuard3();
    testMatchClauseWithTypeGuard4();
    testMatchClauseWithTypeGuard5();
    testMatchClauseWithTypeGuard6();
    testMatchClauseWithTypeGuard7();
    testMatchClauseWithTypeGuard8();
    testMatchClauseWithTypeGuard9();
    testMatchClauseWithTypeGuard10();
    testMatchClauseWithTypeGuard11();
    testMatchClauseWithTypeGuard12();
}
