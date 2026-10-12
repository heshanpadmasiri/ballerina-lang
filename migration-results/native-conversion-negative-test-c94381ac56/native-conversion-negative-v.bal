import ballerina/io;
import ballerina/test;

type Person record {|
    string name = "";
    int age = 0;
    Person? parent = ();
    json info?;
    map<anydata>? address?;
    int[]? marks?;
    anydata a = ();
    float score = 0.0;
    boolean alive = false;
    Person[]? children?;
|};

type Student record {|
    string name = "";
    int age = 0;
|};

type Person2 record {|
    string name = "";
    int age = 0;
|};

type StructWithoutDefaults record {|
    string s = "";
    int a;
    float f = 0.0;
    boolean b = false;
    json j = {};
    byte[] blb = [];
|};

type T1 record {
    int x = 0;
    int y = 0;
};

type T2 record {|
    int x = 0;
    int y = 0;
    int z = 0;
|};

public type TX record {
    int x = 0;
    int y = 0;
    xml[] xmls = [xml `hello`];
};

type Manager record {
    string name = "";
    int age = 0;
    Manager? parent = ();
};

type Engineer record {
    string name = "";
    int age = 0;
    Engineer? parent = ();
};

function testIncompatibleJsonToStructWithErrors() returns Person|error {
    json j = {name: "Child", age: 25, parent: {name: "Parent", age: 50, parent: "Parent",
        address: {"city": "Colombo", "country": "SriLanka"}, info: null, marks: null},
        address: {"city": "Colombo", "country": "SriLanka"}, info: {status: "single"},
        marks: [87, 94, 72]};
    Person p = check j.cloneWithType(Person);
    return p;
}

function testEmptyJSONtoStructWithoutDefaults() returns StructWithoutDefaults|error {
    json j = {};
    var testStruct = check j.cloneWithType(StructWithoutDefaults);
    return testStruct;
}

function testEmptyMaptoStructWithoutDefaults() returns StructWithoutDefaults|error {
    map<anydata> m = {};
    var testStruct = check m.cloneWithType(StructWithoutDefaults);
    return testStruct;
}

function testArrayToJsonFail() returns json|error {
    TX[] x = [];
    TX a = {};
    TX b = {};
    a.x = 10;
    b.x = 15;
    x[0] = a;
    x[1] = b;
    return x.cloneWithType(json);
}

function testIncompatibleImplicitConversion() returns int|error {
    json operationReq = {"toInt": "abjd"};
    var abjd = check operationReq.toInt;
    return abjd.cloneWithType(int);
}

function testConvertRecordToRecordWithCyclicValueReferences() returns Engineer|error {
    Manager p = {name: "Waruna", age: 25, parent: ()};
    Manager p2 = {name: "Milinda", age: 25, parent: p};
    p.parent = p2;
    Engineer|error e = trap p.cloneWithType(Engineer);
    return e;
}

function testConvertRecordToJsonWithCyclicValueReferences() returns json|error {
    Manager p = {name: "Waruna", age: 25, parent: ()};
    Manager p2 = {name: "Milinda", age: 25, parent: p};
    p.parent = p2;
    json j = check trap p.cloneWithType(json);
    return j;
}

function testConvertRecordToMapWithCyclicValueReferences() returns map<anydata>|error {
    Manager p = {name: "Waruna", age: 25, parent: ()};
    Manager p2 = {name: "Milinda", age: 25, parent: p};
    p.parent = p2;
    map<anydata> m = check trap p.cloneWithType(AnydataMap);
    return m;
}

function testConvertFromJsonWithCyclicValueReferences() {
    json p = {name: "Waruna", age: 25, parent: ()};
    json p2 = {name: "Milinda", age: 25, parent: p};
    map<json> p3 = <map<json>> p2;
    p3["parent"] = p2;
    json p4 = p3;
    Engineer|error p5 = trap p4.fromJsonWithType(Engineer);
    error err = <error> p5;
    test:assertEquals(<string> checkpanic err.detail()["message"], "'map<json>' value has cyclic reference");
    test:assertEquals(err.message(), "{ballerina/lang.value}ConversionError");
}

type AnydataMap map<anydata>;
type T1_T2 [T1, T2];

function errorMessage(error value) returns string {
    return <string> checkpanic value.detail()["message"];
}

public function main() {
    io:println(errorMessage(<error> testIncompatibleJsonToStructWithErrors())); // @output 'map<json>' value cannot be converted to 'Person': 
    // @output 		{
    // @output 		  field 'parent.parent' in record 'Person' should be of type 'Person?', found '"Parent"'
    // @output 		}
    io:println(errorMessage(<error> testEmptyJSONtoStructWithoutDefaults())); // @output 'map<json>' value cannot be converted to 'StructWithoutDefaults': 
    // @output 		missing required field 'a' of type 'int' in record 'StructWithoutDefaults'
    io:println(errorMessage(<error> testEmptyMaptoStructWithoutDefaults())); // @output 'map<anydata>' value cannot be converted to 'StructWithoutDefaults': 
    // @output 		missing required field 'a' of type 'int' in record 'StructWithoutDefaults'
    io:println(errorMessage(<error> testArrayToJsonFail())); // @output 'TX[]' value cannot be converted to 'json'
    io:println(errorMessage(<error> testIncompatibleImplicitConversion())); // @output 'string' value cannot be converted to 'int'
    Engineer|error recordResult = testConvertRecordToRecordWithCyclicValueReferences();
    io:println(recordResult is error); // @output true
    io:println(errorMessage(<error> recordResult)); // @output 'Manager' value has cyclic reference
    json|error jsonResult = testConvertRecordToJsonWithCyclicValueReferences();
    io:println(jsonResult is error); // @output true
    map<anydata>|error mapResult = testConvertRecordToMapWithCyclicValueReferences();
    io:println(mapResult is error); // @output true
    testConvertFromJsonWithCyclicValueReferences();
}
