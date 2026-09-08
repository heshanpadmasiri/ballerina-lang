import ballerina/io;

type ClosedPerson record {|
    string name = "";
    int age = 0;
    Address address = {};
|};

type ClosedAddress record {|
    string street = "";
    string city = "";
|};

type Address record {
    string street = "";
    string city = "";
};

type ClosedFoo record {|
    string a = "";
    string b = "";
    string c = "";
    string d = "";
    string e = "";
|};

type ClosedGrades record {|
    int maths = 0;
    int physics = 0;
    int chemistry = 0;
|};

type ClosedBar record {|
    float x = 0.0;
    float y = 0.0;
    float z = 0.0;
|};

function testForeachWithClosedRecords() returns [string[], any[]] {
    ClosedPerson p = {name: "John Doe", age: 25, address: {street: "Palm Grove", city: "Colombo 3"}};
    string[] fields = [];
    any[] values = [];
    int i = 0;
    foreach var [f, v] in p.entries() {
        fields[i] = f;
        values[i] = v;
        i += 1;
    }
    return [fields, values];
}

function testForeachWithOpenRecords2() returns any[] {
    ClosedPerson p = {name: "John Doe", age: 25, address: {street: "Palm Grove", city: "Colombo 3"}};
    any[] values = [];
    int i = 0;
    foreach var v in p {
        values[i] = v;
        i += 1;
    }
    return values;
}

function testForeachOpWithClosedRecords() returns any[] {
    ClosedPerson p = {name: "John Doe", age: 25, address: {street: "Palm Grove", city: "Colombo 3"}};
    any[] values = [];
    p.forEach(function (any value) {
        values.push(value);
    });
    return values;
}

function testMapOpWithClosedRecords() returns map<any> {
    ClosedPerson p = {name: "John Doe", age: 25, address: {street: "Palm Grove", city: "Colombo 3"}};
    map<any> newp = p.'map(function (any value) returns any {
        if value is string {
            return value.toLowerAscii();
        }
        return value;
    });
    return newp;
}

function testFilterOpWithClosedRecords() returns map<string> {
    ClosedFoo f = {a: "A", b: "B", c: "C", d: "D", e: "E"};
    return f.filter(function (string value) returns boolean {
        return value == "A" || value == "E";
    });
}

function testReduceOpWithClosedRecords() returns int {
    ClosedFoo f = {a: "A", b: "B", c: "C", d: "D", e: "E"};
    return f.reduce(function (int count, string value) returns int { return count + 1; }, 0);
}

function testChainedOpsWithClosedRecords() returns map<string> {
    ClosedFoo f = {a: "AA", b: "BB", c: "CC", d: "DD", e: "EE"};
    return f.'map(function (string value) returns string {
        return value.toLowerAscii();
    }).filter(function (string value) returns boolean {
        return value != "aa" && value != "ee";
    });
}

function testMapWithAllStringClosedRecord() returns map<string> {
    ClosedFoo f = {a: "AA", b: "BB", c: "CC", d: "DD", e: "EE"};
    return f.'map(function (string value) returns string {
        return value.toLowerAscii();
    });
}

function testMapWithAllIntClosedRecord(int m, int p, int c) returns map<int> {
    ClosedGrades grades = {maths: m, physics: p, chemistry: c};
    return grades.'map(function (int grade) returns int {
        return grade + 10;
    });
}

function testMapWithAllFloatClosedRecord(float a, float b, float c) returns map<float> {
    ClosedBar bar = {x: a, y: b, z: c};
    return bar.'map(function (float val) returns float {
        return val + 10.0;
    });
}

function testFilterWithAllStringClosedRecord() returns map<string> {
    ClosedFoo f = {a: "AA", b: "BB", c: "CC", d: "DD", e: "EE"};
    return f.filter(function (string v) returns boolean {
        return v == "AA" || v == "EE";
    });
}

function testFilterWithAllIntClosedRecord() returns map<int> {
    ClosedGrades grades = {maths: 80, physics: 75, chemistry: 65};
    return grades.filter(function (int grade) returns boolean {
        return grade > 70;
    });
}

function testFilterWithAllFloatClosedRecord(float a, float b, float c) returns map<float> {
    ClosedBar bar = {x: a, y: b, z: c};
    return bar.filter(function (float val) returns boolean {
        return val > 6.0;
    });
}

function testTerminalOpsOnAllIntClosedRecord(int m, int p, int c) returns [int, int, int, int, float] {
    ClosedGrades grades = {maths: m, physics: p, chemistry: c};
    int counta = grades.reduce(function (int count, int value) returns int { return count + 1; }, 0);
    int maxa = grades.reduce(function (int max, int v) returns int { return v > max ? v : max; }, 0);
    int mina = grades.reduce(function (int min, int v) returns int { return v < min ? v : min; }, 1000000);
    int suma = grades.reduce(function (int sum, int v) returns int { return sum + v; }, 0);
    float avga = grades.reduce(function (float avg, int v) returns float {
        return avg + <float>v / <float>grades.length();
    }, 0.0);
    return [counta, maxa, mina, suma, avga];
}

function testTerminalOpsOnAllIntClosedRecord2(int m, int p) returns [int, int, int, int, float] {
    ClosedGrades grades = {maths: m, physics: p};
    int counta = grades.reduce(function (int count, int value) returns int { return count + 1; }, 0);
    int maxa = grades.reduce(function (int max, int v) returns int { return v > max ? v : max; }, 0);
    int mina = grades.reduce(function (int min, int v) returns int { return v < min ? v : min; }, 1000000);
    int suma = grades.reduce(function (int sum, int v) returns int { return sum + v; }, 0);
    float avga = grades.reduce(function (float avg, int v) returns float {
        return avg + <float>v / <float>grades.length();
    }, 0.0);
    return [counta, maxa, mina, suma, avga];
}

function testChainedOpsWithClosedRecords2() returns map<float> {
    ClosedGrades f = {maths: 80, physics: 75, chemistry: 65};
    return f.'map(function (int grade) returns int {
        return grade + 10;
    }).'map(function (int grade) returns string {
        return grade > 75 ? "PASS" : "FAIL";
    }).filter(function (string status) returns boolean {
        return status == "PASS";
    }).'map(function (string status) returns float {
        return status == "PASS" ? 4.2 : 0.0;
    });
}

function testOpChainsWithTerminalOps(int m, int p, int c) returns [int, int, int, int, float] {
    ClosedGrades f = {maths: m, physics: p, chemistry: c};
    int counta = f.'map(mapTo).filter(filter).reduce(function (int count, int value) returns int { return count + 1; }, 0);
    int suma = f.'map(mapTo).filter(filter).reduce(function (int sum, int v) returns int { return sum + v; }, 0);
    int maxa = f.'map(mapTo).filter(filter).reduce(function (int max, int v) returns int { return v > max ? v : max; }, 0);
    int mina = f.'map(mapTo).filter(filter).reduce(function (int min, int v) returns int { return v < min ? v : min; }, 100000);
    int length = f.'map(mapTo).filter(filter).length();
    float avga = f.'map(mapTo).filter(filter).reduce(function (float avg, int v) returns float {
        return avg + <float>v / <float>length;
    }, 0.0);
    return [counta, suma, maxa, mina, avga];
}

function mapTo(int grade) returns int {
    return grade + 10;
}

function filter(int grade) returns boolean {
    return grade > 75;
}

function testMutability() returns ClosedGrades {
    ClosedGrades grades = {maths: 80, physics: 75, chemistry: 65};
    map<float> _ = grades.'map(function (int grade) returns int {
        return grade + 10;
    }).'map(function (int grade) returns string {
        return grade > 75 ? "PASS" : "FAIL";
    }).filter(function (string status) returns boolean {
        return status == "PASS";
    }).'map(function (string status) returns float {
        return status == "PASS" ? 4.2 : 0.0;
    });
    return grades;
}

public function main() {
    var foreachClosed = testForeachWithClosedRecords();
    io:println(foreachClosed[0][0]); // @output name
    io:println(foreachClosed[0][1]); // @output age
    io:println(foreachClosed[0][2]); // @output address
    io:println(foreachClosed[1][0]); // @output John Doe
    io:println(foreachClosed[1][1]); // @output 25
    Address foreachClosedAddress = <Address>foreachClosed[1][2];
    io:println(foreachClosedAddress is Address); // @output true
    io:println(foreachClosedAddress.street); // @output Palm Grove
    io:println(foreachClosedAddress.city); // @output Colombo 3

    any[] foreachOpen = testForeachWithOpenRecords2();
    io:println(foreachOpen[0]); // @output John Doe
    io:println(foreachOpen[1]); // @output 25
    Address foreachOpenAddress = <Address>foreachOpen[2];
    io:println(foreachOpenAddress is Address); // @output true
    io:println(foreachOpenAddress.street); // @output Palm Grove
    io:println(foreachOpenAddress.city); // @output Colombo 3

    any[] foreachOp = testForeachOpWithClosedRecords();
    io:println(foreachOp[0]); // @output John Doe
    io:println(foreachOp[1]); // @output 25
    Address foreachOpAddress = <Address>foreachOp[2];
    io:println(foreachOpAddress is Address); // @output true
    io:println(foreachOpAddress.street); // @output Palm Grove
    io:println(foreachOpAddress.city); // @output Colombo 3

    map<any> mappedPerson = testMapOpWithClosedRecords();
    io:println(mappedPerson["name"]); // @output john doe
    io:println(mappedPerson["age"]); // @output 25
    Address mappedAddress = <Address>mappedPerson["address"];
    io:println(mappedAddress is Address); // @output true
    io:println(mappedAddress.street); // @output Palm Grove
    io:println(mappedAddress.city); // @output Colombo 3

    map<string> filteredFoo = testFilterOpWithClosedRecords();
    io:println(filteredFoo.get("a")); // @output A
    io:println(filteredFoo.hasKey("b") ? filteredFoo["b"] : "()"); // @output ()
    io:println(filteredFoo.hasKey("c") ? filteredFoo["c"] : "()"); // @output ()
    io:println(filteredFoo.hasKey("d") ? filteredFoo["d"] : "()"); // @output ()
    io:println(filteredFoo.get("e")); // @output E

    io:println(testReduceOpWithClosedRecords()); // @output 5

    map<string> chainedFoo = testChainedOpsWithClosedRecords();
    io:println(chainedFoo.hasKey("a") ? chainedFoo["a"] : "()"); // @output ()
    io:println(chainedFoo.get("b")); // @output bb
    io:println(chainedFoo.get("c")); // @output cc
    io:println(chainedFoo.get("d")); // @output dd
    io:println(chainedFoo.hasKey("e") ? chainedFoo["e"] : "()"); // @output ()

    map<string> mappedStrings = testMapWithAllStringClosedRecord();
    io:println(mappedStrings["a"]); // @output aa
    io:println(mappedStrings["b"]); // @output bb
    io:println(mappedStrings["c"]); // @output cc
    io:println(mappedStrings["d"]); // @output dd
    io:println(mappedStrings["e"]); // @output ee

    map<int> mappedInts = testMapWithAllIntClosedRecord(80, 75, 65);
    io:println(mappedInts["maths"]); // @output 90
    io:println(mappedInts["physics"]); // @output 85
    io:println(mappedInts["chemistry"]); // @output 75

    map<float> mappedFloats = testMapWithAllFloatClosedRecord(20.15, 7.89, 5.15);
    io:println(mappedFloats["x"]); // @output 30.15
    io:println(mappedFloats["y"]); // @output 17.89
    io:println(mappedFloats["z"]); // @output 15.15

    map<string> filteredStrings = testFilterWithAllStringClosedRecord();
    io:println(filteredStrings.get("a")); // @output AA
    io:println(filteredStrings.hasKey("b") ? filteredStrings["b"] : "()"); // @output ()
    io:println(filteredStrings.hasKey("c") ? filteredStrings["c"] : "()"); // @output ()
    io:println(filteredStrings.hasKey("d") ? filteredStrings["d"] : "()"); // @output ()
    io:println(filteredStrings.get("e")); // @output EE

    map<int> filteredInts = testFilterWithAllIntClosedRecord();
    io:println(filteredInts.get("maths")); // @output 80
    io:println(filteredInts.get("physics")); // @output 75
    io:println(filteredInts.hasKey("chemistry") ? filteredInts["chemistry"] : "()"); // @output ()

    map<float> filteredFloats = testFilterWithAllFloatClosedRecord(20.15, 7.89, 5.15);
    io:println(filteredFloats.get("x")); // @output 20.15
    io:println(filteredFloats.get("y")); // @output 7.89
    io:println(filteredFloats.hasKey("z") ? filteredFloats["z"] : "()"); // @output ()

    var terminalInts = testTerminalOpsOnAllIntClosedRecord(80, 76, 66);
    io:println(terminalInts[0]); // @output 3
    io:println(terminalInts[1]); // @output 80
    io:println(terminalInts[2]); // @output 66
    io:println(terminalInts[3]); // @output 222
    io:println(terminalInts[4]); // @output 74.0

    var terminalInts2 = testTerminalOpsOnAllIntClosedRecord2(80, 76);
    io:println(terminalInts2[0]); // @output 3
    io:println(terminalInts2[1]); // @output 80
    io:println(terminalInts2[2]); // @output 0
    io:println(terminalInts2[3]); // @output 156
    io:println(terminalInts2[4]); // @output 52.0

    map<float> chainedGrades = testChainedOpsWithClosedRecords2();
    io:println(chainedGrades.get("maths")); // @output 4.2
    io:println(chainedGrades.get("physics")); // @output 4.2
    io:println(chainedGrades.hasKey("chemistry") ? chainedGrades["chemistry"] : "()"); // @output ()

    var chainedTerminal = testOpChainsWithTerminalOps(80, 75, 65);
    io:println(chainedTerminal[0]); // @output 2
    io:println(chainedTerminal[1]); // @output 175
    io:println(chainedTerminal[2]); // @output 90
    io:println(chainedTerminal[3]); // @output 85
    io:println(chainedTerminal[4]); // @output 87.5

    ClosedGrades grades = testMutability();
    io:println(grades.length()); // @output 3
    io:println(grades.maths); // @output 80
    io:println(grades.physics); // @output 75
    io:println(grades.chemistry); // @output 65
}
