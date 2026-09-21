import ballerina/io;

type Person record { string name = ""; int age = 0; Address address = {}; };
type Address record { string street = ""; string city = ""; };
type Foo record { string a = ""; string b = ""; string c = ""; string d = ""; string e = ""; };
type RestrictedFoo record {| string a = ""; string b = ""; string c = ""; string d = ""; string e = ""; string...; |};
type Grades record { int maths = 0; int physics = 0; int chemistry = 0; };
type RestrictedGrades record {| int maths = 0; int physics = 0; int chemistry = 0; int...; |};
type RestrictedBar record {| float x = 0.0; float y = 0.0; float z = 0.0; float...; |};

function testForeachWithOpenRecords() returns [string[], any[]] {
    Person p = {name: "John Doe", age: 25, address: {street: "Palm Grove", city: "Colombo 3"}};
    string[] fields = []; any[] values = [];
    foreach var [f, v] in p.entries() { fields.push(f); values.push(v); }
    return [fields, values];
}
function testForeachWithOpenRecords2() returns [string[], any[]] {
    Person p = {name: "John Doe", age: 25, address: {street: "Palm Grove", city: "Colombo 3"}, "height": 5.9};
    string[] fields = []; any[] values = [];
    foreach var [f, v] in p.entries() { fields.push(f); values.push(v); }
    return [fields, values];
}
function testForeachWithOpenRecords3() returns any[] {
    Person p = {name: "John Doe", age: 25, address: {street: "Palm Grove", city: "Colombo 3"}}; any[] values = [];
    foreach var v in p { values.push(v); }
    return values;
}
function testForeachOpWithOpenRecords() returns any[] {
    Person p = {name: "John Doe", age: 25, address: {street: "Palm Grove", city: "Colombo 3"}, "height": 5.9}; any[] values = [];
    p.forEach(function (any value) { values.push(value); });
    return values;
}
function testMapOpWithOpenRecords() returns map<anydata> {
    Person p = {name: "John Doe", age: 25, address: {street: "Palm Grove", city: "Colombo 3"}, "profession": "Software Engineer"};
    return p.'map(function (anydata value) returns anydata { if value is string { return value.toLowerAscii(); } return value; });
}
function testFilterOpWithOpenRecords() returns map<anydata> {
    Foo f = {a: "A", b: "B", c: "C", d: "D", e: "E", "f": "F"};
    return f.filter(function (anydata value) returns boolean { return value !== "A" && value !== "E"; });
}
function testCountOpWithOpenRecords() returns int {
    Foo f = {a: "A", b: "B", c: "C", d: "D", e: "E", "f": "F"};
    return f.reduce(function (int count, anydata value) returns int { return count + 1; }, 0);
}
function testChainedOpsWithOpenRecords() returns map<anydata> {
    Foo f = {a: "AA", b: "BB", c: "CC", d: "DD", e: "EE", "f": "FF"};
    return f.'map(function (anydata value) returns anydata { if value is string { return value.toLowerAscii(); } return value; })
        .filter(function (anydata value) returns boolean { return value !== "aa" && value !== "ee"; });
}
function testMapWithAllStringOpenRecord() returns map<string> {
    RestrictedFoo f = {a: "AA", b: "BB", c: "CC", d: "DD", e: "EE", "f": "FF"};
    return f.'map(function (string value) returns string { return value.toLowerAscii(); });
}
function testMapWithAllIntOpenRecord(int m, int p, int c, int e) returns map<int> {
    RestrictedGrades grades = {maths: m, physics: p, chemistry: c, "english": e};
    return grades.'map(function (int grade) returns int { return grade + 10; });
}
function testMapWithAllFloatOpenRecord(float a, float b, float c) returns map<float> {
    RestrictedBar bar = {x: a, y: b, z: c, "p": 9.9};
    return bar.'map(function (float value) returns float { return value + 10.0; });
}
function testFilterWithAllStringOpenRecord() returns map<string> {
    RestrictedFoo f = {a: "AA", b: "BB", c: "CC", d: "DD", e: "EE", "f": "FF"};
    return f.filter(function (string value) returns boolean { return value == "AA" || value == "EE" || value == "FF"; });
}
function testFilterWithAllIntOpenRecord() returns map<int> {
    RestrictedGrades grades = {maths: 80, physics: 75, chemistry: 65, "english": 78};
    return grades.filter(function (int grade) returns boolean { return grade > 70; });
}
function testFilterWithAllFloatOpenRecord(float a, float b, float c) returns map<float> {
    RestrictedBar bar = {x: a, y: b, z: c, "p": 9.9};
    return bar.filter(function (float value) returns boolean { return value > 6.0; });
}
function testTerminalOpsOnAllIntOpenRecord(int m, int p, int c, int e) returns [int, int, int, int, float] {
    RestrictedGrades grades = {maths: m, physics: p, chemistry: c, "english": e};
    int count = grades.reduce(function (int total, int value) returns int { return total + 1; }, 0);
    int max = grades.reduce(function (int current, int value) returns int { return value > current ? value : current; }, 0);
    int min = grades.reduce(function (int current, int value) returns int { return value < current ? value : current; }, 1000000);
    int sum = grades.reduce(function (int total, int value) returns int { return total + value; }, 0);
    float average = grades.reduce(function (float total, int value) returns float { return total + <float>value / <float>grades.length(); }, 0.0);
    return [count, max, min, sum, average];
}
function testTerminalOpsOnAllIntOpenRecord2(int m, int p, int e) returns [int, int, int, int, float] {
    RestrictedGrades grades = {maths: m, physics: p, "english": e};
    int count = grades.reduce(function (int total, int value) returns int { return total + 1; }, 0);
    int max = grades.reduce(function (int current, int value) returns int { return value > current ? value : current; }, 0);
    int min = grades.reduce(function (int current, int value) returns int { return value < current ? value : current; }, 1000000);
    int sum = grades.reduce(function (int total, int value) returns int { return total + value; }, 0);
    float average = grades.reduce(function (float total, int value) returns float { return total + <float>value / <float>grades.length(); }, 0.0);
    return [count, max, min, sum, average];
}
function mapTo(int grade) returns int => grade + 10;
function filter(int grade) returns boolean => grade > 75;
function testChainedOpsWithOpenRecords2() returns map<float> {
    RestrictedGrades grades = {maths: 80, physics: 75, chemistry: 65, "english": 78};
    return grades.'map(function (int grade) returns int { return grade + 10; })
        .'map(function (int grade) returns string { return grade > 75 ? "PASS" : "FAIL"; })
        .filter(function (string status) returns boolean { return status == "PASS"; })
        .'map(function (string status) returns float { return 4.2; });
}
function testChainedOpsWithOpenRecords3() returns map<float> {
    Grades grades = {maths: 80, physics: 75, chemistry: 65, "english": 78};
    return grades.'map(function (anydata grade) returns int { if grade is int { return grade + 10; } return -1; })
        .'map(function (int grade) returns string { return grade > 75 ? "PASS" : "FAIL"; })
        .filter(function (string status) returns boolean { return status == "PASS"; })
        .'map(function (string status) returns float { return 4.2; });
}
function testOpChainsWithTerminalOps(int m, int p, int c) returns [int, int, int, int, float] {
    RestrictedGrades grades = {maths: m, physics: p, chemistry: c, "english": 78};
    int count = grades.'map(mapTo).filter(filter).reduce(function (int total, int value) returns int { return total + 1; }, 0);
    int sum = grades.'map(mapTo).filter(filter).reduce(function (int total, int value) returns int { return total + value; }, 0);
    int max = grades.'map(mapTo).filter(filter).reduce(function (int current, int value) returns int { return value > current ? value : current; }, 0);
    int min = grades.'map(mapTo).filter(filter).reduce(function (int current, int value) returns int { return value < current ? value : current; }, 100000);
    int length = grades.'map(mapTo).filter(filter).length();
    float average = grades.'map(mapTo).filter(filter).reduce(function (float total, int value) returns float { return total + <float>value / <float>length; }, 0.0);
    return [count, sum, max, min, average];
}
function testMutability() returns RestrictedGrades {
    RestrictedGrades grades = {maths: 80, physics: 75, chemistry: 65, "english": 78};
    map<float> _ = grades.'map(function (int grade) returns int { return grade + 10; })
        .'map(function (int grade) returns string { return grade > 75 ? "PASS" : "FAIL"; })
        .filter(function (string status) returns boolean { return status == "PASS"; })
        .'map(function (string status) returns float { return 4.2; });
    return grades;
}

public function main() {
    var first = testForeachWithOpenRecords();
    io:println(first[0][0]); // @output name
    io:println(first[0][1]); // @output age
    io:println(first[0][2]); // @output address
    io:println(first[1][0]); // @output John Doe
    io:println(first[1][1]); // @output 25
    any firstAddress = first[1][2];
    if firstAddress is Address { io:println(firstAddress.street); // @output Palm Grove
        io:println(firstAddress.city); // @output Colombo 3
    }
    var second = testForeachWithOpenRecords2();
    io:println(second[0][0]); // @output name
    io:println(second[0][1]); // @output age
    io:println(second[0][2]); // @output address
    io:println(second[0][3]); // @output height
    io:println(second[1][0]); // @output John Doe
    io:println(second[1][1]); // @output 25
    io:println(second[1][3]); // @output 5.9
    any secondAddress = second[1][2];
    if secondAddress is Address { io:println(secondAddress.street); // @output Palm Grove
        io:println(secondAddress.city); // @output Colombo 3
    }
    any[] third = testForeachWithOpenRecords3();
    io:println(third[0]); // @output John Doe
    io:println(third[1]); // @output 25
    any thirdAddress = third[2];
    if thirdAddress is Address { io:println(thirdAddress.street); // @output Palm Grove
        io:println(thirdAddress.city); // @output Colombo 3
    }
    any[] foreachOp = testForeachOpWithOpenRecords();
    io:println(foreachOp[0]); // @output John Doe
    io:println(foreachOp[1]); // @output 25
    any foreachAddress = foreachOp[2];
    if foreachAddress is Address { io:println(foreachAddress.street); // @output Palm Grove
        io:println(foreachAddress.city); // @output Colombo 3
    }
    io:println(foreachOp[3]); // @output 5.9
    map<anydata> mapped = testMapOpWithOpenRecords();
    io:println(mapped["name"]); // @output john doe
    io:println(mapped["age"]); // @output 25
    io:println(mapped["profession"]); // @output software engineer
    anydata mappedAddress = mapped["address"];
    if mappedAddress is Address { io:println(mappedAddress.street); // @output Palm Grove
        io:println(mappedAddress.city); // @output Colombo 3
    }
    map<anydata> filtered = testFilterOpWithOpenRecords();
    io:println(filtered.hasKey("a") ? filtered["a"] : ()); // @output
    io:println(filtered["b"]); // @output B
    io:println(filtered["c"]); // @output C
    io:println(filtered["d"]); // @output D
    io:println(filtered.hasKey("e") ? filtered["e"] : ()); // @output
    io:println(filtered["f"]); // @output F
    io:println(testCountOpWithOpenRecords()); // @output 6
    map<anydata> chained = testChainedOpsWithOpenRecords();
    io:println(chained.hasKey("a") ? chained["a"] : ()); // @output
    io:println(chained["b"]); // @output bb
    io:println(chained["c"]); // @output cc
    io:println(chained["d"]); // @output dd
    io:println(chained.hasKey("e") ? chained["e"] : ()); // @output
    io:println(chained["f"]); // @output ff
    map<string> stringMap = testMapWithAllStringOpenRecord();
    io:println(stringMap["a"]); // @output aa
    io:println(stringMap["b"]); // @output bb
    io:println(stringMap["c"]); // @output cc
    io:println(stringMap["d"]); // @output dd
    io:println(stringMap["e"]); // @output ee
    map<string> stringFilter = testFilterWithAllStringOpenRecord();
    io:println(stringFilter["a"]); // @output AA
    io:println(stringFilter.hasKey("b") ? stringFilter["b"] : ()); // @output
    io:println(stringFilter.hasKey("c") ? stringFilter["c"] : ()); // @output
    io:println(stringFilter.hasKey("d") ? stringFilter["d"] : ()); // @output
    io:println(stringFilter["e"]); // @output EE
    io:println(stringFilter["f"]); // @output FF
    map<int> intFilter = testFilterWithAllIntOpenRecord();
    io:println(intFilter["maths"]); // @output 80
    io:println(intFilter["physics"]); // @output 75
    io:println(intFilter.hasKey("chemistry") ? intFilter["chemistry"] : ()); // @output
    io:println(intFilter["english"]); // @output 78
    map<float> chained2 = testChainedOpsWithOpenRecords2();
    io:println(chained2["maths"]); // @output 4.2
    io:println(chained2["physics"]); // @output 4.2
    io:println(chained2["english"]); // @output 4.2
    io:println(chained2.hasKey("chemistry") ? chained2["chemistry"] : ()); // @output
    map<float> chained3 = testChainedOpsWithOpenRecords3();
    io:println(chained3["maths"]); // @output 4.2
    io:println(chained3["physics"]); // @output 4.2
    io:println(chained3["english"]); // @output 4.2
    io:println(chained3.hasKey("chemistry") ? chained3["chemistry"] : ()); // @output
    RestrictedGrades original = testMutability();
    io:println(original.length()); // @output 4
    io:println(original.maths); // @output 80
    io:println(original.physics); // @output 75
    io:println(original.chemistry); // @output 65
    io:println(original["english"]); // @output 78
}
