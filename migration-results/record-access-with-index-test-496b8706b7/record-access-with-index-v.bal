import ballerina/io;

type Department record {
    string dptName = "";
    Person[] employees = [];
};

type Person record {
    string name = "default first name";
    string lname = "";
    map<any> adrs = {};
    int age = 999;
    Family family = {};
};

type Family record {
    string spouse = "";
    int noOfChildren?;
    string[] children = [];
};

function testCreateStruct() returns [string?, map<any>?, int?] {
    map<any> address = {"country": "USA", "state": "CA"};
    Person emp = {name: "Jack", adrs: address, age: 25};
    return [emp["name"], emp["adrs"], emp["age"]];
}

function testStructOfStruct() returns string {
    map<any> address = {"country": "USA", "state": "CA"};
    Person emp1 = {name: "Jack", adrs: address, age: 25};
    Person emp2 = {};
    Department dpt = {employees: [emp1, emp2]};
    var result = dpt["employees"][0]["adrs"]["country"];
    return <string>result;
}

function testReturnStructAttributes() returns string? {
    Family fmly = {children: []};
    Person emp1 = {name: "Jack", adrs: {"country": "USA", "state": "CA"}, age: 25, family: fmly};
    Person emp2 = {};
    Department dpt = {employees: [emp1, emp2]};
    dpt["employees"][0]["family"]["children"][0] = "emily";
    return dpt["employees"][0]["family"]["children"][0];
}

function testExpressionAsIndex() returns string {
    Family family = {spouse: "Kate", children: ["Emma", "Rose", "Jane"]};
    int a = 2;
    int b = 5;
    return family.children[a * b - 8];
}

function testStructExpressionAsIndex() returns string? {
    Department dpt = {};
    Family fmly = {children: []};
    Person emp2 = {};
    Person emp1 = {name: "Jack", adrs: {"country": "USA", "state": "CA"}, age: 25, family: fmly};
    emp1["adrs"]["street"] = "20";
    emp1["age"] = 0;
    dpt["employees"] = [emp1, emp2];
    dpt["employees"][0]["family"]["children"][0] = "emily";
    dpt["employees"][0]["family"]["noOfChildren"] = 1;
    return dpt["employees"][0]["family"]["children"][(dpt["employees"][0]["family"]["noOfChildren"] ?: 1) - 1];
}

function testDefaultVal() returns [string?, string?, int?] {
    Person p = {};
    return [p["name"], p["lname"], p["age"]];
}

function testNestedFieldDefaultVal() returns [string?, string?, int?] {
    Department dpt = {};
    dpt["employees"] = [];
    dpt["employees"][0] = {lname: "Smith"};
    return [dpt["employees"][0]["name"], dpt["employees"][0]["lname"], dpt["employees"][0]["age"]];
}

type StructField record {|
    string key;
|};

function testExpressionAsStructIndex() returns string {
    StructField nameField = {key: "name"};
    Person emp = {name: "Jack", adrs: {"country": "USA", "state": "CA"}, age: 25};
    var result = emp[nameField.key];
    if result is string {
        return result;
    }
    return "fail";
}

type Foo record {|
    string fieldOne;
    int fieldTwo;
    boolean fieldThree;
    () fieldFour;
    float fieldFive;
    decimal fieldSix;
|};

function testDynamicIndexAccessTypes() returns string {
    Foo f = {fieldOne: "string", fieldTwo: 100, fieldThree: true, fieldFour: (), fieldFive: 25.5, fieldSix: 96.9};
    string result = "";
    string index = "fieldOne";
    var res1 = f[index];
    if res1 is string {
        result += "string:" + res1;
    }
    index = "fieldTwo";
    string|int|boolean|()|float|decimal res2 = f[index];
    if res2 is int {
        result += ":int:" + res2.toString();
    }
    index = "fieldThree";
    res2 = f[index];
    if res2 is boolean {
        result += ":boolean:" + res2.toString();
    }
    index = "fieldFour";
    string|int|boolean|()|float|decimal res4 = f[index];
    if res4 is () {
        result += ":():" + res4.toString();
    }
    index = "fieldFive";
    var res5 = f[index];
    if res5 is float {
        result += ":float:" + res5.toString();
    }
    index = "fieldSix";
    res5 = f[index];
    if res5 is decimal {
        result += ":decimal:" + res5.toString();
    }
    return result;
}

type Bar record {|
    int fieldOne;
    string|float fieldTwo;
    boolean...;
|};

function testDynamicIndexAccessTypesWithRestParam(string arg) returns string {
    Bar f = {fieldOne: 50, fieldTwo: "string", "fieldThree": true};
    string result = "";
    int|string|float|boolean? res1 = f[arg];
    if res1 is int {
        result += ":int:" + res1.toString();
    }
    if res1 is string {
        result += ":string:" + res1.toString();
    }
    if res1 is boolean {
        result += ":boolean:" + res1.toString();
    }
    if res1 is () {
        result += "()";
    }
    return result;
}

class Obj {
    private int intField;
    function init() {
        self.intField = 10;
    }
    function getIntField() returns int {
        return self.intField;
    }
}

type FooBar record {
    Obj fieldOne?;
    function (int) returns int fieldTwo;
    json fieldThree;
};

function testDynamicIndexAccessTypesWithOpenRecord() returns string {
    Obj obj = new;
    function (int) returns int aFn = x => x * 2;
    json jVal = "json-string";
    string result = "";
    FooBar fb = {fieldOne: obj, fieldTwo: aFn, fieldThree: jVal, "fieldFour": true};
    int[5] indexArr = [1, 2, 3, 4, 5];
    foreach var index in indexArr {
        Obj|(function (int) returns int)|json|anydata|error res = fb[getIndex(index)];
        if res is Obj {
            result += ":object:" + res.getIntField().toString();
            continue;
        }
        if res is function (int) returns int {
            result += ":function:" + res(8).toString();
            continue;
        }
        if res is () {
            result += ":():";
            continue;
        }
        if res is boolean {
            result += ":boolean:" + res.toString();
            continue;
        }
        if res is json {
            result += ":json:" + res.toString();
        }
    }
    return result;
}

function getIndex(int index) returns string {
    match index {
        1 => {return "fieldOne";}
        2 => {return "fieldTwo";}
        3 => {return "fieldThree";}
        4 => {return "fieldFour";}
        _ => {return "fieldFive";}
    }
}

type Qux record {|
    int fieldOne?;
    int fieldTwo;
    int...;
|};

function testDynamicIndexAccessWithSingleType() returns int {
    Qux q = {fieldOne: 95, fieldTwo: 96, "fieldThree": 100};
    string[] index = ["fieldOne", "fieldTwo", "fieldThree"];
    int marks = 0;
    int? 'field = q[index[0]];
    if 'field is int {
        marks += 'field * 2;
    }
    'field = q[index[1]];
    if 'field is int {
        marks += 'field * 2;
    }
    'field = q[index[2]];
    if 'field is int {
        marks += 'field * 2;
    }
    return marks;
}

type Quux record {|
    Qux fieldOne;
|};

function testDynamicIndexAccessWithRecordInsideRecord() returns [int?, int?] {
    Qux q = {fieldOne: 95, fieldTwo: 96, "fieldThree": 100};
    Quux qu = {fieldOne: q};
    string index = "fieldOne";
    int? r1 = qu["fieldOne"]["fieldOne"];
    int? r2 = qu[index][index];
    return [r1, r2];
}

type Finite "fieldOne"|"fieldTwo"|"fieldThree"|"fieldFive";

type FooQux record {
    string|boolean fieldOne;
    Bar fieldTwo;
    float|Obj fieldThree;
    int fieldFour;
};

function testFiniteTypeAsIndex() returns string {
    Finite index1 = "fieldOne";
    Finite index2 = "fieldTwo";
    Finite index3 = "fieldThree";
    Finite index4 = "fieldFive";
    Bar bar = {fieldOne: 50, fieldTwo: "barField", "fieldThree": true};
    Qux q = {fieldOne: 95, fieldTwo: 96, "fieldThree": 100};
    FooQux foo = {fieldOne: "string", fieldTwo: bar, fieldThree: 98.9, fieldFour: 12, "fieldFive": q};
    string|boolean|Bar|float|Obj|anydata|error r1 = foo[index1];
    var r2 = foo[index2];
    string|boolean|Bar|float|Obj|anydata|error r3 = foo[index3];
    string|boolean|Bar|float|Obj|anydata|error r4 = foo[index4];
    string result = "";
    if r1 is string {
        result += r1;
    }
    if r2 is Bar {
        int|string|float|boolean? r2s = r2[index2];
        if r2s is string {
            result += r2s;
        }
    }
    if r3 is float {
        result += r3.toString();
    }
    if r4 is Qux {
        int? r5 = r4[index1];
        result += r5.toString();
    }
    return result;
}

const string FIELD_FOUR = "fieldFour";
type FiniteOne "fieldOne"|"fieldTwo";
type FiniteTwo "fieldTwo"|"fieldThree";
type FiniteThree FiniteOne|FiniteTwo|FIELD_FOUR;

function testUnionInFiniteTypeAsIndex() returns string {
    FiniteThree index1 = "fieldOne";
    FiniteThree index2 = "fieldTwo";
    FiniteThree index3 = "fieldThree";
    FiniteThree index4 = "fieldFour";
    Foo foo = {fieldOne: "string", fieldTwo: 100, fieldThree: true, fieldFour: (), fieldFive: 25.5, fieldSix: 96.9};
    string|int|boolean|() r1 = foo[index1];
    var r2 = foo[index2];
    string|int|boolean? r3 = foo[index3];
    string|int|boolean|() r4 = foo[index4];
    string result = "";
    if r1 is string {
        result += r1;
    }
    if r2 is int {
        result += r2.toString();
    }
    if r3 is boolean {
        result += r3.toString();
    }
    if r4 is () {
        result += "()";
    }
    return result;
}

function testUnionInFiniteTypeAsIndexNoField() returns string {
    FiniteThree index = "fieldFour";
    Bar f = {fieldOne: 50, fieldTwo: "string", "fieldThree": true};
    var r1 = f[index];
    if r1 is () {
        return "Passed";
    }
    return "Failed";
}

function testSetFieldOfNonInitChildStruct() {
    Person person = {name: "Jack"};
    person.family.spouse = "Jane";
}

function testSetFieldOfNonInitStruct() {
    Department dpt = {};
    dpt.dptName = "HR";
}

public function main() {
    var basic = testCreateStruct();
    io:println(basic[0]); // @output Jack
    map<any> address = <map<any>>basic[1];
    io:println(address["country"]); // @output USA
    io:println(address["state"]); // @output CA
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
    io:println(testExpressionAsStructIndex()); // @output Jack
    io:println(testDynamicIndexAccessTypes()); // @output string:string:int:100:boolean:true:()::float:25.5:decimal:96.9
    io:println(testDynamicIndexAccessTypesWithRestParam("fieldOne")); // @output :int:50
    io:println(testDynamicIndexAccessTypesWithRestParam("fieldTwo")); // @output :string:string
    io:println(testDynamicIndexAccessTypesWithRestParam("fieldThree")); // @output :boolean:true
    io:println(testDynamicIndexAccessTypesWithRestParam("fieldFour")); // @output ()
    io:println(testDynamicIndexAccessTypesWithOpenRecord()); // @output :object:10:function:16:json:json-string:boolean:true:():
    io:println(testDynamicIndexAccessWithSingleType()); // @output 582
    var recordInside = testDynamicIndexAccessWithRecordInsideRecord();
    io:println(recordInside[0]); // @output 95
    io:println(recordInside[1]); // @output 95
    io:println(testFiniteTypeAsIndex()); // @output stringbarField98.995
    io:println(testUnionInFiniteTypeAsIndex()); // @output string100true()
    io:println(testUnionInFiniteTypeAsIndexNoField()); // @output Passed
    testSetFieldOfNonInitChildStruct();
    testSetFieldOfNonInitStruct();
}
