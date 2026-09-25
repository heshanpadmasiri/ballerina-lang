import ballerina/io;

type PersonCM record {| string name; int age; string address = ""; |};
type EmployeeCM record { string name; int age; };
type Student record {| int index; int age; |};

function testConstrainedMapValueTypePositive() returns string { map<string> m = {name: "kevin"}; return <string>m["name"]; }
function testConstrainedMapValueTypeIndexBasedPositive() returns string { map<string> m = {name: "kevin"}; var x = m["name"]; return x is string ? x : ""; }
function testConstrainedMapValueTypeIndexBasedNegative() returns string? { map<string> m = {name: "kevin"}; return m["names"]; }
function testConstrainedMapStructTypePositive() returns [string, int] { map<PersonCM> m = {}; m["item"] = {name: "Jack", age: 25}; PersonCM p = <PersonCM>m["item"]; return [p.name, p.age]; }
function testConstrainedMapValueTypeAssignWithMemberAccessPositive() returns [string?, string?] {
    map<string> m = {};
    m["name"] = "kevin";
    m["sname"] = "ratnasekera";
    return [m["name"], m["sname"]];
}
function testConstrainedMapConstrainedWithConstrainedMap() returns [string, string] { map<map<string>> m = {item: {name: "kevin", sname: "ratnasekera"}}; map<string> x = <map<string>>m["item"]; return [<string>x["name"], <string>x["sname"]]; }
function testConstrainedMapConstrainedWithValueTypeArray() returns [int, int] { map<int[]> m = {item: [25, 30]}; int[] x = <int[]>m["item"]; return [x[0], x[1]]; }
function testConstrainedMapIntTypePositive() returns [int, int] { map<int> m = {item_1: 36, item_2: 63}; return [<int>m["item_1"], <int>m["item_2"]]; }
function testConstrainedMapIntTypeNegative() returns [int, int] { map<int> m = {item_1: 36, item_2: 63}; var a = m["item_1_n"]; var b = m["item_2_n"]; return [a is int ? a : 0, b is int ? b : 0]; }
function testConstrainedMapFloatTypePositive() returns [float, float] { map<float> m = {item_1: 3.6, item_2: 6.3}; return [<float>m["item_1"], <float>m["item_2"]]; }
function testConstrainedMapFloatTypeNegative() returns [float, float] { map<float> m = {item_1: 3.6, item_2: 6.3}; var a = m["item_1_n"]; var b = m["item_2_n"]; return [a is float ? a : 0.0, b is float ? b : 0.0]; }
function testConstrainedMapBooleanTypePositive() returns [boolean, boolean] { map<boolean> m = {item_1: true, item_2: false}; return [<boolean>m["item_1"], <boolean>m["item_2"]]; }
function testConstrainedMapBooleanTypeNegative() returns [boolean, boolean] { map<boolean> m = {item_1: true, item_2: false}; var a = m["item_1_n"]; var b = m["item_2_n"]; return [a is boolean ? a : false, b is boolean ? b : false]; }
function testConstrainedMapBlobTypePositive() returns [byte[], byte[]] { map<byte[]> m = {item_1: "hi".toBytes(), item_2: "ballerina".toBytes()}; return [<byte[]>m["item_1"], <byte[]>m["item_2"]]; }
function testConstrainedMapBlobTypeNegative() returns [byte[], byte[]] {
    map<byte[]> m = {item_1: "hi".toBytes(), item_2: "ballerina".toBytes()};
    byte[] item1 = [];
    var value = m["item_1"];
    if value is byte[] {
        item1 = value;
    }
    byte[] item2 = [];
    value = m["item_2"];
    if value is byte[] {
        item2 = value;
    }
    return [item1, item2];
}
function genericMap(map<any> m) returns map<any> { return m; }
function testConstrainedMapValueTypeCast() returns string { map<string> original = {name: "kevin"}; map<any> m = genericMap(original); map<string> x = <map<string>>m; return <string>x["name"]; }
function testConstrainedMapValueTypeCastNegative() returns map<int>|error { map<string> original = {name: "kevin"}; map<any> m = genericMap(original); return check trap <map<int>>m; }
function testConstrainedMapRefTypeCast() returns [string, int] { map<PersonCM> original = {item: {name: "Jack", age: 25}}; map<any> m = genericMap(original); map<PersonCM> x = <map<PersonCM>>m; PersonCM p = <PersonCM>x["item"]; return [p.name, p.age]; }
function testConstrainedMapRefTypeCastNegative() returns map<int>|error { map<PersonCM> original = {item: {name: "Jack", age: 25}}; map<any> m = genericMap(original); return check trap <map<int>>m; }
function testUpdateStringMap() returns string {
    map<string> m = {};
    map<any> a = updateGenericMap(m);
    map<string> x = <map<string>>a;
    return <string>x["item"];
}
function updateGenericMap(map<any> m) returns map<any> {
    m["item"] = "update";
    return m;
}
function testStructConstrainedMapRuntimeCast() returns [string, int] {
    map<PersonCM> testMap = {item: {name: "Jack", age: 25, address: "Usa"}};
    map<any> m = genericMap(testMap);
    map<EmployeeCM> castMap = m is map<EmployeeCM> ? m : {};
    EmployeeCM p = <EmployeeCM>castMap["item"];
    return [p.name, p.age];
}
function testStructConstrainedMapStaticCast() returns [string, int] {
    map<PersonCM> testMap = {item: {name: "Jack", age: 25, address: "Usa"}};
    map<EmployeeCM> castMap = testMap;
    EmployeeCM p = <EmployeeCM>castMap["item"];
    return [p.name, p.age];
}
function testStructEquivalentMapUpdate() returns [string, int] {
    map<PersonCM> testMap = {item: {name: "Jack", age: 25, address: "Usa"}};
    map<EmployeeCM> m = testMap;
    map<EmployeeCM> castMap = m;
    EmployeeCM p = <EmployeeCM>castMap["item"];
    return [p.name, p.age];
}
function testStructEquivalentMapAccess() returns [string, int] {
    map<PersonCM> testMap = {item: {name: "Mervin", age: 25, address: "Usa"}};
    return equivalentMapAccess(testMap);
}
function equivalentMapAccess(map<EmployeeCM> m) returns [string, int] {
    EmployeeCM p = <EmployeeCM>m["item"];
    return [p.name, p.age];
}
function testStructMapUpdate() returns [string, int] {
    map<PersonCM> testMap = {item: {name: "Jack", age: 25, address: "Usa"}};
    map<any> m = updateStructMap(testMap);
    map<EmployeeCM> castMap = m is map<EmployeeCM> ? m : {};
    EmployeeCM p = <EmployeeCM>castMap["update"];
    return [p.name, p.age];
}
function updateStructMap(map<any> m) returns map<any> {
    PersonCM p = {name: "Arnold", age: 45, address: "UK"};
    m["update"] = p;
    return m;
}
function testStructNotEquivalentRuntimeCast() returns map<PersonCM>|error { map<EmployeeCM> original = {item: {name: "Jack", age: 25}}; map<any> m = genericMap(original); return check trap <map<PersonCM>>m; }
function testAnyMapToValueTypeRuntimeCast() returns map<int>|error { map<any> m = {item: 5}; return check trap <map<int>>m; }
function testAnyMapToRefTypeRuntimeCast() returns map<EmployeeCM>|error { map<any> m = {item: {name: "Jack", age: 25}}; return check trap <map<EmployeeCM>>m; }
function testMapToStructConversion() returns [int, int]|error { map<int> m = {index: 100, age: 63}; Student s = check m.cloneWithType(Student); return [s.index, s.age]; }
function testMapFunctionsOnConstrainedMaps() returns string[] { return {index: "100", age: "63"}.keys(); }
function testForEachOnConstrainedMaps() returns [string, string] { map<string> m = {name: "Ronnie", sname: "Cale"}; string[] a = []; int i = 0; foreach var v in m { a[i] = v[1]; i += 1; } return [a[0], a[1]]; }
function testMapOfElementTypeArray() returns [string, string] { map<string[]> m = {a2: ["Kollupitiya", "Ja-Ela"]}; string[] a = <string[]>m["a2"]; return [a[0], a[1]]; }
function testMapOfElementTypeRefArray() returns [string, int] { map<EmployeeCM[]> m = {e1: [{name: "Jack", age: 25}]}; EmployeeCM p = (<EmployeeCM[]>m["e1"])[0]; return [p.name, p.age]; }
type PersonComplex record {|
    string name = "";
    int age = 0;
    PersonComplex? parent = ();
    json info = ();
    map<string> address = {};
    int[] marks = [];
    anydata a = ();
    float score = 0.0;
    boolean alive = false;
|};
function testJsonToStructConversionStructWithConstrainedMap() returns [string, string] {
    json j = {name: "Child", age: 25, parent: {name: "Parent", age: 50, parent: (), address: {}, info: {}, marks: [], a: {}, score: 4.57, alive: false}, address: {city: "Colombo", country: "SriLanka"}, info: {status: "single"}, marks: [56, 79], a: "anydata value", score: 5.67, alive: true};
    var result = j.cloneWithType(PersonComplex);
    if result is PersonComplex {
        map<string> address = result.address;
        return [<string>address["city"], <string>address["country"]];
    }
    panic result;
}
type PersonComplexTwo record {|
    string name = "";
    int age = 0;
    PersonComplexTwo? parent = ();
    json info = ();
    map<int> address = {};
    int[] marks = [];
    anydata a = ();
    float score = 0.0;
    boolean alive = false;
|};
function testJsonToStructConversionStructWithConstrainedMapNegative() returns PersonComplexTwo|error {
    json j = {name: "Child", age: 25, parent: {name: "Parent", age: 50, parent: (), address: {}, info: {}, marks: [], a: {}, score: 4.57, alive: false}, address: {city: "Colombo", country: "SriLanka"}, info: {status: "single"}, marks: [56, 79], a: "any value", score: 5.67, alive: true};
    return check j.cloneWithType(PersonComplexTwo);
}
function testConstrainedUnionRetrieveString() returns string { return {name: "kevin"}.get("name"); }
function testConstrainedUnionRetrieveInt() returns int { return {id: 3}.get("id"); }
function testMapConstrainedEquivalentMapInsert() returns [string?, int?] { map<EmployeeCM> m = {}; PersonCM p = {name: "Jack", age: 25, address: "Usa"}; m["jack"] = p; return [m["jack"]["name"], m["jack"]["age"]]; }
type Transaction record {
    string transactionId;
    string coordinationType;
    map<Participant> participants?;
    Protocol[] coordinatorProtocols?;
};
type Participant record {|
    string participantId;
    Protocol[] participantProtocols;
|};
type Protocol record {|
    string name;
    string url;
    int transactionBlockId;
    (function (string transactionId, int transactionBlockId, string protocolAction) returns boolean)|() protocolFn;
|};
type TwoPhaseCommitTransaction record {|
    string transactionId;
    string coordinationType;
    map<Participant> participants?;
    Protocol[] coordinatorProtocols?;
    boolean possibleMixedOutcome?;
|};
function testRuntimeStructEquivalencyWithNestedConstrainedMaps() returns string? {
    map<Transaction> initiatedTransactions = {};
    TwoPhaseCommitTransaction tpc = {transactionId: "TR-ID", coordinationType: "2pc"};
    initiatedTransactions["Foo"] = tpc;
    return initiatedTransactions["Foo"]["transactionId"];
}
function testMapConstrainedToUnion() returns string|int? { map<string|int> m = {test: "test-value"}; return m["test"]; }
function testMapConstrainedToUnionCaseTwo() returns string|int? { map<string|int> m = {test: 2}; return m["test"]; }
function testMapConstrainedToNullableUnion() returns string? { map<string?> m = {test: "test-nullable-union"}; return m["test"]; }
function testMapConstrainedToNullableUnionNonExistingKeyWithIndexAccess() returns string? { map<string?> m = {}; return m["nonexist"]; }
function testMapAnyDataClosedRecordAssignment() returns anydata { PersonCM p = {name: "Jack", age: 25, address: "Usa"}; map<anydata> m = p; return m["name"]; }

public function main() {
    io:println(testConstrainedMapValueTypePositive()); // @output kevin
    io:println(testConstrainedMapValueTypeIndexBasedPositive()); // @output kevin
    io:println(testConstrainedMapValueTypeIndexBasedNegative()); // @output
    var a = testConstrainedMapStructTypePositive(); io:println(a[0]); // @output Jack
    io:println(a[1]); // @output 25
    var strings = testConstrainedMapValueTypeAssignWithMemberAccessPositive(); io:println(strings[0]); // @output kevin
    io:println(strings[1]); // @output ratnasekera
    var strings2 = testConstrainedMapConstrainedWithConstrainedMap(); io:println(strings2[0]); // @output kevin
    io:println(strings2[1]); // @output ratnasekera
    var b = testConstrainedMapConstrainedWithValueTypeArray(); io:println(b[0]); // @output 25
    io:println(b[1]); // @output 30
    b = testConstrainedMapIntTypePositive(); io:println(b[0]); // @output 36
    io:println(b[1]); // @output 63
    b = testConstrainedMapIntTypeNegative(); io:println(b[0]); // @output 0
    io:println(b[1]); // @output 0
    var f = testConstrainedMapFloatTypePositive(); io:println(f[0]); // @output 3.6
    io:println(f[1]); // @output 6.3
    f = testConstrainedMapFloatTypeNegative(); io:println(f[0]); // @output 0.0
    io:println(f[1]); // @output 0.0
    var c = testConstrainedMapBooleanTypePositive(); io:println(c[0]); // @output true
    io:println(c[1]); // @output false
    c = testConstrainedMapBooleanTypeNegative(); io:println(c[0]); // @output false
    io:println(c[1]); // @output false
    var bytes = testConstrainedMapBlobTypePositive(); io:println(bytes[0]); // @output [104,105]
    io:println(bytes[1]); // @output [98,97,108,108,101,114,105,110,97]
    bytes = testConstrainedMapBlobTypeNegative(); io:println(bytes[0]); // @output [104,105]
    io:println(bytes[1]); // @output [98,97,108,108,101,114,105,110,97]
    io:println(testConstrainedMapValueTypeCast()); // @output kevin
    var e = testConstrainedMapValueTypeCastNegative(); if e is error { io:println(e.detail()["message"]); // @output incompatible types: 'map<string>' cannot be cast to 'map<int>'
    }
    a = testConstrainedMapRefTypeCast(); io:println(a[0]); // @output Jack
    io:println(a[1]); // @output 25
    var e2 = testConstrainedMapRefTypeCastNegative(); if e2 is error { io:println(e2.detail()["message"]); // @output incompatible types: 'map<PersonCM>' cannot be cast to 'map<int>'
    }
    io:println(testUpdateStringMap()); // @output update
    a = testStructConstrainedMapRuntimeCast(); io:println(a[0]); // @output Jack
    io:println(a[1]); // @output 25
    a = testStructConstrainedMapStaticCast(); io:println(a[0]); // @output Jack
    io:println(a[1]); // @output 25
    a = testStructEquivalentMapUpdate(); io:println(a[0]); // @output Jack
    io:println(a[1]); // @output 25
    a = testStructEquivalentMapAccess(); io:println(a[0]); // @output Mervin
    io:println(a[1]); // @output 25
    a = testStructMapUpdate(); io:println(a[0]); // @output Arnold
    io:println(a[1]); // @output 45
    var e3 = testStructNotEquivalentRuntimeCast(); if e3 is error { io:println(e3.detail()["message"]); // @output incompatible types: 'map<EmployeeCM>' cannot be cast to 'map<PersonCM>'
    }
    e = testAnyMapToValueTypeRuntimeCast(); if e is error { io:println(e.detail()["message"]); // @output incompatible types: 'map' cannot be cast to 'map<int>'
    }
    var er = testAnyMapToRefTypeRuntimeCast(); if er is error { io:println(er.detail()["message"]); // @output incompatible types: 'map' cannot be cast to 'map<EmployeeCM>'
    }
    b = checkpanic testMapToStructConversion(); io:println(b[0]); // @output 100
    io:println(b[1]); // @output 63
    io:println(testMapFunctionsOnConstrainedMaps().length()); // @output 2
    var strings3 = testForEachOnConstrainedMaps(); io:println(strings3[0]); // @output o
    io:println(strings3[1]); // @output a
    var strings4 = testMapOfElementTypeArray(); io:println(strings4[0]); // @output Kollupitiya
    io:println(strings4[1]); // @output Ja-Ela
    a = testMapOfElementTypeRefArray(); io:println(a[0]); // @output Jack
    io:println(a[1]); // @output 25
    var strings5 = testJsonToStructConversionStructWithConstrainedMap(); io:println(strings5[0]); // @output Colombo
    io:println(strings5[1]); // @output SriLanka
    var jsonError = testJsonToStructConversionStructWithConstrainedMapNegative();
    if jsonError is error {
        var message = jsonError.detail()["message"];
        if message is string {
            io:println(message.substring(0, 60)); // @output 'map<json>' value cannot be converted to 'PersonComplexTwo':
            io:println(message.substring(62, 131)); // @output 		map field 'address.city' should be of type 'int', found '"Colombo"'
            io:println(message.substring(132)); // @output 		map field 'address.country' should be of type 'int', found '"SriLanka"'
        }
    }
    io:println(testConstrainedUnionRetrieveString()); // @output kevin
    io:println(testConstrainedUnionRetrieveInt()); // @output 3
    var optionalValues = testMapConstrainedEquivalentMapInsert(); io:println(optionalValues[0]); // @output Jack
    io:println(optionalValues[1]); // @output 25
    io:println(testRuntimeStructEquivalencyWithNestedConstrainedMaps()); // @output TR-ID
    io:println(testMapConstrainedToUnion()); // @output test-value
    io:println(testMapConstrainedToUnionCaseTwo()); // @output 2
    io:println(testMapConstrainedToNullableUnion()); // @output test-nullable-union
    io:println(testMapConstrainedToNullableUnionNonExistingKeyWithIndexAccess()); // @output
    io:println(testMapAnyDataClosedRecordAssignment()); // @output Jack
}
