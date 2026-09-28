import ballerina/io;

type Department record {
    string dptName = "";
    PersonSE[] employees = [];
};

type PersonSE record {
    string name = "default first name";
    string lname = "";
    map<any> adrs = {};
    int age = 999;
    FamilySE family = {};
};

type FamilySE record {
    string spouse = "";
    int noOfChildren = 0;
    string[] children = [];
};

function testCreateStructSt() returns [string?, map<any>?, int?] {
    map<any> address = {"country": "USA", "state": "CA"};
    PersonSE emp = {name: "Jack", adrs: address, age: 25};
    return [emp["name"], emp["adrs"], emp["age"]];
}

function testExpressionAsIndex() returns string {
    FamilySE family = {spouse: "Kate"};
    int a = 2;
    int b = 5;
    family.children = ["Emma", "Rose", "Jane"];
    return family.children[a * b - 8];
}

function testStructOfStruct() returns string {
    map<any> address = {"country": "USA", "state": "CA"};
    PersonSE emp1 = {name: "Jack", adrs: address, age: 25};
    PersonSE emp2 = {};
    Department dpt = {employees: [emp1, emp2]};
    var result = dpt["employees"][0]["adrs"]["country"];
    return result is () ? "" : <string>result;
}

function testReturnStructAttributes() returns string? {
    map<any> address = {"country": "USA", "state": "CA"};
    FamilySE fmly = {children: []};
    PersonSE emp1 = {name: "Jack", adrs: address, age: 25, family: fmly};
    PersonSE emp2 = {};
    Department dpt = {employees: [emp1, emp2]};
    dpt["employees"][0]["family"]["children"][0] = "emily";
    return dpt["employees"][0]["family"]["children"][0];
}

function testStructExpressionAsIndex() returns string? {
    Department dpt = {};
    FamilySE fmly = {children: []};
    PersonSE emp2 = {};
    map<any> address = {"country": "USA", "state": "CA"};
    PersonSE emp1 = {name: "Jack", adrs: address, age: 25, family: fmly};
    emp1["adrs"]["street"] = "20";
    emp1["age"] = 0;
    dpt["employees"] = [emp1, emp2];
    dpt["employees"][0]["family"]["children"][0] = "emily";
    dpt["employees"][0]["family"]["noOfChildren"] = 1;
    return dpt["employees"][0]["family"]["children"][(dpt["employees"][0]["family"]["noOfChildren"]) - 1];
}

function testDefaultVal() returns [string?, string?, int?] {
    PersonSE p = {};
    return [p["name"], p["lname"], p["age"]];
}

function testNestedFieldDefaultVal() returns [string?, string?, int?] {
    Department dpt = {};
    dpt["employees"] = [];
    dpt["employees"][0] = {lname: "Smith"};
    return [dpt["employees"][0]["name"], dpt["employees"][0]["lname"], dpt["employees"][0]["age"]];
}

function testSetFieldOfNonInitChildStruct() {
    PersonSE pse = {name: "Jack"};
    pse.family.spouse = "Jane";
}

function testSetFieldOfNonInitStruct() {
    Department dpt = {};
    dpt.dptName = "HR";
}

public function main() {
    var basic = testCreateStructSt();
    io:println(basic[0]); // @output Jack
    map<any>? address = basic[1];
    if address is map<any> {
        io:println(address["country"]); // @output USA
        io:println(address["state"]); // @output CA
    }
    io:println(basic[2]); // @output 25
    io:println(testExpressionAsIndex()); // @output Jane
    io:println(testStructOfStruct()); // @output USA
    io:println(testReturnStructAttributes()); // @output emily
    io:println(testStructExpressionAsIndex()); // @output emily
    var defaults = testDefaultVal();
    io:println(defaults[0]); // @output default first name
    io:println(defaults[1]); // @output
    io:println(defaults[2]); // @output 999
    var nestedDefaults = testNestedFieldDefaultVal();
    io:println(nestedDefaults[0]); // @output default first name
    io:println(nestedDefaults[1]); // @output Smith
    io:println(nestedDefaults[2]); // @output 999
    testSetFieldOfNonInitChildStruct();
    testSetFieldOfNonInitStruct();
}
