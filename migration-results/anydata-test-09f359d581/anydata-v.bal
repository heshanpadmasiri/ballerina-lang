import ballerina/io;
import ballerina/lang.regexp;

type Foo record { int a = 0; };
type ClosedFoo record {| int ca = 0; |};
type Employee record {| readonly int id; string name; float salary; |};
type Person record {|
    string name = "";
    int age = 0;
    Person? parent = ();
    json info = ();
    map<anydata>? address = ();
    int[]? marks = ();
    anydata a = ();
    float score = 0.0;
    boolean alive = false;
    Person[]? children = ();
|};
type ValueType int|float|string|boolean|byte|decimal;
type DataType ValueType|table<map<anydata>>|json|xml|regexp:RegExp|ClosedFoo|Foo|map<anydata>|anydata[]|();
type FiniteT "A"|"Z"|123|23.45|true;

function testLiteralValueAssignment() returns [anydata, anydata, anydata, anydata] {
    anydata i = 10; anydata f = 23.45; anydata b = true; anydata s = "Hello World!";
    return [i, f, b, s];
}

function testValueTypesAssignment() returns [anydata, anydata, anydata, anydata] {
    int i = 10; float f = 23.45; boolean b = true; string s = "Hello World!";
    return [i, f, b, s];
}

function testRecordAssignment() returns [anydata, anydata] {
    Foo f = {a: 20}; ClosedFoo cf = {ca: 35}; return [f, cf];
}

function testCyclicRecordAssignment() returns anydata {
    Person p = {name: "Child", age: 25, parent: {name: "Parent", age: 50},
        address: {"city": "Colombo", "country": "SriLanka"}, info: {status: "single"}, marks: [67, 38, 91]};
    anydata adp = p;
    any p2 = <Person> adp;
    return p2 is anydata ? p2 : ();
}

function testXMLAssignment() returns [anydata, anydata] {
    anydata x1 = xml `<book>The Lost World</book>`;
    xml x = xml `<book>Count of Monte Cristo</book>`;
    return [x1, x];
}

function testJSONAssignment() returns anydata {
    json j = {name: "apple", color: "red", price: 40}; return j;
}

function employees() returns table<Employee> {
    return table key(id) [
        {id: 1, name: "Mary", salary: 300.5},
        {id: 2, name: "John", salary: 200.5},
        {id: 3, name: "Jim", salary: 330.5}
    ];
}

function testTableAssignment() {
    anydata t = employees();
    assertEquality("[{\"id\":1,\"name\":\"Mary\",\"salary\":300.5},{\"id\":2,\"name\":\"John\",\"salary\":200.5},{\"id\":3,\"name\":\"Jim\",\"salary\":330.5}]", t.toString());
}

function testMapAssignment() {
    anydata ad;
    map<int> mi = {}; ad = mi; map<float> mf = {}; ad = mf; map<boolean> mb = {}; ad = mb;
    map<byte> mby = {}; ad = mby; map<string> ms = {}; ad = ms; map<json> mj = {}; ad = mj;
    map<xml> mx = {}; ad = mx; map<Foo> mr = {}; ad = mr; map<ClosedFoo> mcr = {}; ad = mcr;
    map<table<map<anydata>>> mt = {}; ad = mt; map<map<anydata>> mmad = {}; ad = mmad;
    map<anydata[]> madr = {}; ad = madr; map<DataType> mu = {}; ad = mu;
    map<[[DataType, string], int, float]> mtup = {}; ad = mtup; map<()> mnil = {}; ad = mnil;
    assertTrue(ad is map<()>);
}

function testConstrainedMaps() {
    byte b = 10; Foo foo = {a: 15}; json j = {name: "apple", color: "red", price: 40};
    xml x = xml `<book>The Lost World</book>`; map<string> smap = {foo: "foo", bar: "bar"};
    map<anydata> adm = {"byte": b, "json": j, "record": foo, "xml": x, "string": "Hello World", "int": 1234,
        "float": 23.45, "boolean": true, "map": smap, "nil": (), "table": employees()};
    assertEquality(1234, adm["int"]); assertEquality(23.45, adm["float"]); assertEquality(true, adm["boolean"]);
    assertEquality("Hello World", adm["string"]); assertEquality("10", adm["byte"].toString());
    assertEquality("<book>The Lost World</book>", adm["xml"].toString()); assertEquality(foo, adm["record"]);
    assertEquality(smap, adm["map"]); assertEquality(j, adm["json"]);
    assertEquality("[{\"id\":1,\"name\":\"Mary\",\"salary\":300.5},{\"id\":2,\"name\":\"John\",\"salary\":200.5},{\"id\":3,\"name\":\"Jim\",\"salary\":330.5}]", adm["table"].toString());
}

function testArrayAssignment() {
    anydata ad;
    int[] ai = [10, 20, 30]; ad = ai; float[] af = [1.2, 2.3, 3.4]; ad = af;
    boolean[] ab = [true, false, true]; ad = ab; byte[] aby = [1, 2, 3]; ad = aby;
    string[] ast = ["foo", "bar"]; ad = ast; json[] aj = ["foo", "bar"]; ad = aj;
    xml[] ax = [xml `<book>The Lost World</book>`]; ad = ax; Foo[] ar = [{a: 10}, {a: 20}]; ad = ar;
    ClosedFoo[] acr = [{ca: 10}, {ca: 20}]; ad = acr; table<Employee>[] at = [employees()]; ad = at;
    map<anydata>[] amad = [{}]; ad = amad; anydata[] aad = []; ad = aad; anydata[][] a2ad = []; ad = a2ad; ()[] an = []; ad = an;
    assertTrue(ad is ()[]);
}

function testAnydataArray() returns anydata[] {
    Foo f = {a: 15}; json j = {name: "apple", color: "red", price: 40}; xml x = xml `<book>The Lost World</book>`; byte b = 10;
    return [1234, 23.45, true, "Hello World!", b, f, j, x];
}

function testUnionAssignment() returns anydata[] {
    ValueType a = "hello world!"; ValueType b = 123; ValueType c = 23.45; ValueType d = true; byte e = 255;
    return [a, b, c, d, e];
}

function testUnionAssignment2() {
    anydata[] rets = []; int i = 0; DataType dt = "hello world!"; rets[i] = dt; i += 1;
    table<Employee> t = employees(); dt = t; rets[i] = dt; i += 1;
    json j = {name: "apple", color: "red", price: 40}; dt = j; rets[i] = dt; i += 1;
    dt = xml `<book>The Lost World</book>`; rets[i] = dt; i += 1; Foo f = {a: 15}; dt = f; rets[i] = dt; i += 1;
    ClosedFoo cf = {ca: 15}; dt = cf; rets[i] = dt; i += 1; map<anydata> m = {foo: f}; dt = m; rets[i] = dt; i += 1;
    anydata[] ar = []; ar[0] = "hello world!"; dt = ar; rets[i] = dt;
    assertEquality("hello world!", rets[0].toString());
    assertEquality("[{\"id\":1,\"name\":\"Mary\",\"salary\":300.5},{\"id\":2,\"name\":\"John\",\"salary\":200.5},{\"id\":3,\"name\":\"Jim\",\"salary\":330.5}]", rets[1].toString());
    assertEquality("{\"name\":\"apple\",\"color\":\"red\",\"price\":40}", rets[2].toString());
    assertEquality("<book>The Lost World</book>", rets[3].toString());
    assertEquality(f, rets[4]); assertEquality(cf, rets[5]); assertEquality(m, rets[6]);
}

function testTupleAssignment() {
    anydata[] rets = []; int i = 0;
    byte b = 255; [int, float, boolean, string, byte] vt = [123, 23.45, true, "hello world!", b]; rets[i] = vt; i += 1;
    json j = {name: "apple", color: "red", price: 40}; xml x = xml `<book>The Lost World</book>`; [json, xml] jxt = [j, x];
    rets[i] = jxt; i += 1;
    DataType[] dt = [j, x]; [DataType[], string] ct = [dt, "hello world!"]; rets[i] = ct; i += 1;
    [[DataType[], string], int, float] nt = [ct, 123, 23.45]; rets[i] = nt;
    assertEquality("[123,23.45,true,\"hello world!\",255]", rets[0].toString()); assertEquality(jxt, rets[1]); assertEquality(ct, rets[2]); assertEquality(nt, rets[3]);
}

function testNilAssignment() returns anydata { return (); }

function testFiniteTypeAssignment() returns anydata[] {
    FiniteT a = "A"; FiniteT b = "Z"; FiniteT c = 123; FiniteT d = 23.45; FiniteT e = true; return [a, b, c, d, e];
}

function testAnydataToValueTypes() returns [int, float, boolean, string] {
    anydata ad = 33; int i = ad is int ? ad : 0; ad = 23.45; float f = ad is float ? ad : 0.0;
    ad = true; boolean b = ad is boolean ? ad : false; ad = "Hello World!"; string s = ad is string ? ad : ""; return [i, f, b, s];
}

function testAnydataToJson() returns json {
    json j = {name: "apple", color: "red", price: 40};
    anydata a = j;
    if a is json { return a; }
    return null;
}
function testAnydataToXml() returns xml {
    anydata a = xml `<book>The Lost World</book>`;
    if a is xml { return a; }
    return xml ` `;
}

function testAnydataToRecord() returns [Foo, ClosedFoo] {
    Foo originalFoo = {a: 15};
    anydata a = originalFoo;
    Foo f = a is Foo ? a : {};
    ClosedFoo originalClosedFoo = {ca: 20};
    a = originalClosedFoo;
    ClosedFoo cf = a is ClosedFoo ? a : {};
    return [f, cf];
}

function testAnydataToMap() {
    anydata a = <map<int>>{}; assertTrue(a is map<int>);
    a = <map<float>>{}; assertTrue(a is map<float>);
    a = <map<boolean>>{}; assertTrue(a is map<boolean>);
    a = <map<byte>>{}; assertTrue(a is map<byte>);
    a = <map<string>>{}; assertTrue(a is map<string>);
    a = <map<json>>{}; assertTrue(a is map<json>);
    a = <map<xml>>{}; assertTrue(a is map<xml>);
    a = <map<Foo>>{}; assertTrue(a is map<Foo>);
    a = <map<ClosedFoo>>{}; assertTrue(a is map<ClosedFoo>);
    a = <map<anydata[]>>{}; assertTrue(a is map<anydata[]>);
    a = <map<table<map<anydata>>>>{};
    if a is map<table<map<anydata>>> {
        map<table<map<any>>> convertedTableMap = a;
        assertEquality(a, convertedTableMap);
    }
    a = <map<map<anydata>>>{};
    if a is map<map<anydata>> {
        map<map<anydata>> convertedMapMap = a;
        assertEquality(a, convertedMapMap);
    }
    a = <map<DataType>>{};
    if a is map<DataType> {
        map<DataType> convertedDataTypeMap = a;
        assertEquality(a, convertedDataTypeMap);
    }
    a = <map<[[DataType, string], int, float]>>{};
    if a is map<[[DataType, string], int, float]> {
        map<[[DataType, string], int, float]> convertedTupleMap = a;
        assertEquality(a, convertedTupleMap);
    }
    a = <map<()>>{};
    if a is map<()> {
        map<()> convertedNilMap = a;
        assertEquality(a, convertedNilMap);
    }
}

function testAnydataToTable() { anydata a = employees(); if a is table<Employee> { table<Employee> t = a; assertEquality(employees(), t); } }

function testAnydataToUnion() returns ValueType?[] {
    anydata a = 10; ValueType?[] r = []; int i = 0; if a is ValueType { r[i] = a; i += 1; }
    a = 23.45; if a is ValueType { r[i] = a; i += 1; } a = "hello world!"; if a is ValueType { r[i] = a; i += 1; }
    a = true; if a is ValueType { r[i] = a; i += 1; } byte b = 255; a = b; if a is ValueType { r[i] = a; } return r;
}

function testAnydataToUnion2() {
    json j = {name: "apple", color: "red", price: 40}; anydata a = j; DataType[] r = []; int i = 0; r[i] = a; i += 1;
    xml x = xml `<book>The Lost World</book>`; a = x; r[i] = a; i += 1;
    table<Employee> t = employees(); a = t; r[i] = a; i += 1; Foo f = {a: 15}; a = f; r[i] = a; i += 1;
    ClosedFoo cf = {ca: 15}; a = cf; r[i] = a; i += 1; map<anydata> m = {foo: f}; a = m; r[i] = a; i += 1;
    anydata[] ar = [f]; a = ar; r[i] = a;
    assertEquality(j, r[0]); assertEquality(x, r[1]); assertEquality(t, r[2]); assertEquality(f, r[3]);
    assertEquality(cf, r[4]); assertEquality(m, r[5]); assertEquality(ar, r[6]);
}

function testAnydataToTuple() returns [int, float, boolean, string, byte]? {
    byte b = 255;
    [int, float, boolean, string, byte] tuple = [123, 23.45, true, "hello world!", b];
    anydata a = tuple;
    return a is [int, float, boolean, string, byte] ? a : ();
}
function testAnydataToTuple2() returns [json, xml]? {
    json j = {name: "apple", color: "red", price: 40}; xml x = xml `<book>The Lost World</book>`;
    [json, xml] tuple = [j, x]; anydata a = tuple;
    return a is [json, xml] ? a : ();
}
function testAnydataToTuple3() {
    json j = {name: "apple", color: "red", price: 40}; xml x = xml `<book>The Lost World</book>`; DataType[] d = [j, x];
    [DataType[], string] c = [d, "hello world!"];
    [[DataType[], string], int, float] n = [c, 123, 23.45]; anydata a = n;
    if a is [[DataType[], string], int, float] { assertEquality("[[{\"name\":\"apple\",\"color\":\"red\",\"price\":40},`<book>The Lost World</book>`],\"hello world!\"]", a[0].toString()); }
}
function testAnydataToNil() returns int? { anydata a = (); return a is () ? a : -1; }
function testAnydataToFiniteType() returns FiniteT?[] {
    FiniteT?[] r = []; int i = 0; FiniteT a = "A"; anydata d = a; if d is FiniteT { r[i] = d; i += 1; }
    a = "Z"; d = a; if d is FiniteT { r[i] = d; i += 1; } a = 123; d = a; if d is FiniteT { r[i] = d; i += 1; }
    a = 23.45; d = a; if d is FiniteT { r[i] = d; i += 1; } a = true; d = a; if d is FiniteT { r[i] = d; } return r;
}

function testTypeCheckingOnAny() returns anydata {
    anydata[] r = []; any a = 10; r[0] = a is anydata ? a : (); a = 23.45; r[1] = a is anydata ? a : ();
    a = true; r[2] = a is anydata ? a : (); a = "hello world!"; r[3] = a is anydata ? a : ();
    json j = {name: "apple", color: "red", price: 40}; a = j; r[4] = a is anydata ? a : (); a = xml `<book>The Lost World</book>`; r[5] = a is anydata ? a : ();
    a = <Foo>{a: 15}; r[6] = a is DataType ? a : (); a = <ClosedFoo>{ca: 15}; r[7] = a is DataType ? a : (); return r;
}

function testRuntimeIsAnydata() {
    any a = <(anydata|error)[]> [1, error("error!")]; any b = <(anydata|error)[]> [1]; any c = <[int, error]> [1, error("error!")];
    any d = <[int, error...]> [1, error("error!")]; any e = <map<anydata|error>> {a: 1, b: error("error!")}; any f = <map<anydata|error>> {a: 1, b: "hello"};
    any g = <record {anydata a; error e;}> {a: 1, e: error("error!")}; any h = <record {|anydata a; error...;|}> {a: 1}; any i = <record {anydata a; error e?;}> {a: 1};
    any j = table [{"e": error("Message")}]; any k = table [{"a": {"x": error("Message")}}];
    assertFalse(a is anydata); assertFalse(b is anydata); assertFalse(c is anydata); assertFalse(d is anydata); assertFalse(e is anydata); assertFalse(f is anydata); assertFalse(g is anydata); assertFalse(h is anydata); assertFalse(i is anydata); assertFalse(j is anydata); assertFalse(k is anydata);
    any a2 = <(anydata|error)[] & readonly> [1, 2]; any b2 = <anydata[]> [1]; any c2 = <[int]> [1]; any d2 = <[int, error...] & readonly> [1]; any e2 = <map<anydata|error> & readonly> {a: 1}; any f2 = <map<anydata>> {a: 1, b: "hello"}; any g2 = <record {anydata a; error e?;} & readonly> {a: 1}; any h2 = <record {|anydata a; error...;|} & readonly> {a: 1};
    assertTrue(a2 is anydata); assertTrue(b2 is anydata); assertTrue(c2 is anydata); assertTrue(d2 is anydata); assertTrue(e2 is anydata); assertTrue(f2 is anydata); assertTrue(g2 is anydata); assertTrue(h2 is anydata);
}

function testMapOfCharIsAnydata() { map<string:Char> x = {}; any a = x; assertTrue(a is anydata); }
function testCharArrayIsAnydata() { string:Char[] x = ["a", "b"]; any a = x; assertTrue(a is anydata); }
function testMapOfIntSubtypeIsAnydata() { map<int:Signed32> x = {}; any a = x; assertTrue(a is anydata); }
function testArrayOfIntSubtypeIsAnydata() { int:Signed32[] x = []; any a = x; assertTrue(a is anydata); }
function testMapOfNeverTypeIsAnydata() { map<never> x = {}; any a = x; assertTrue(a is anydata); }

function testAnytoAnydataTypeCast() returns error? {
    any v = {a: 23}; anydata|error r = trap <anydata>v;
    assertTrue(r is error); error err = <error>r;
    assertEquality("{ballerina}TypeCastError", err.message());
    assertEquality("incompatible types: 'map<(any|error)>' cannot be cast to 'anydata'", <string>checkpanic err.detail()["message"]);
    any[] arr = [1, "2", 3.4]; r = trap <anydata>arr;
    assertTrue(r is error); err = <error>r;
    assertEquality("{ballerina}TypeCastError", err.message());
    assertEquality("incompatible types: 'any[]' cannot be cast to 'anydata'", <string>checkpanic err.detail()["message"]);
    map<any> anyMap = {"a": 2, "b": 3}; r = trap <anydata>anyMap;
    assertTrue(r is error); err = <error>r;
    assertEquality("{ballerina}TypeCastError", err.message());
    assertEquality("incompatible types: 'map' cannot be cast to 'anydata'", <string>checkpanic err.detail()["message"]);
    table<map<any>> tab = table [{id: 12, name: "abc"}, {id: 34, name: "def"}]; r = trap <anydata>tab;
    assertTrue(r is error); err = <error>r;
    assertEquality("{ballerina}TypeCastError", err.message());
    assertEquality("incompatible types: 'table<map>' cannot be cast to 'anydata'", <string>checkpanic err.detail()["message"]);
    any & readonly readonlyValue = {a: 23}; v = readonlyValue; r = trap <anydata>v;
    assertTrue(r is anydata); anydata anyDataValue = check r; assertEquality("{\"a\":23}", anyDataValue.toString());
    any[] & readonly readonlyArray = [1, "2", 3.4]; arr = readonlyArray; r = trap <anydata>arr;
    assertTrue(r is anydata); anyDataValue = check r; assertEquality("[1,\"2\",3.4]", anyDataValue.toString());
    map<any> & readonly readonlyMap = {a: 23}; anyMap = readonlyMap; r = trap <anydata>anyMap;
    assertTrue(r is anydata); anyDataValue = check r; assertEquality("{\"a\":23}", anyDataValue.toString());
    table<map<any>> & readonly readonlyTable = table [{id: 12, name: "abc"}, {id: 34, name: "def"}]; tab = readonlyTable; r = trap <anydata>tab;
    assertTrue(r is anydata); anyDataValue = check r; assertEquality("[{\"id\":12,\"name\":\"abc\"},{\"id\":34,\"name\":\"def\"}]", anyDataValue.toString());
    return ();
}

function assertTrue(any|error actual) { assertEquality(true, actual); }
function assertFalse(any|error actual) { assertEquality(false, actual); }
function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual { return; }
    if expected === actual { return; }
    string e = expected is error ? expected.toString() : expected.toString();
    string a = actual is error ? actual.toString() : actual.toString();
    panic error("AssertionError", message = "expected '" + e + "', found '" + a + "'");
}

public function main() {
    [anydata, anydata, anydata, anydata] literals = testLiteralValueAssignment();
    io:println(literals[0]); // @output 10
    io:println(literals[1]); // @output 23.45
    io:println(literals[2]); // @output true
    io:println(literals[3]); // @output Hello World!
    [anydata, anydata, anydata, anydata] values = testValueTypesAssignment();
    io:println(values[0]); // @output 10
    io:println(values[1]); // @output 23.45
    io:println(values[2]); // @output true
    io:println(values[3]); // @output Hello World!
    [anydata, anydata] records = testRecordAssignment();
    io:println(records[0] is Foo); // @output true
    io:println((<Foo>records[0]).a); // @output 20
    io:println(records[1] is ClosedFoo); // @output true
    io:println((<ClosedFoo>records[1]).ca); // @output 35
    Person cyclic = <Person>testCyclicRecordAssignment();
    anydata cyclicValue = cyclic;
    io:println(cyclicValue is Person); // @output true
    io:println(cyclic.name); // @output Child
    io:println(cyclic.age); // @output 25
    io:println((<Person>cyclic.parent).name); // @output Parent
    [anydata, anydata] xmls = testXMLAssignment();
    io:println(xmls[0] is xml); // @output true
    io:println(xmls[0]); // @output <book>The Lost World</book>
    io:println(xmls[1] is xml); // @output true
    io:println(xmls[1]); // @output <book>Count of Monte Cristo</book>
    json jsonValue = <json>testJSONAssignment();
    anydata jsonTypeValue = jsonValue;
    io:println(jsonTypeValue is map<json>); // @output true
    io:println(jsonValue); // @output {"name":"apple","color":"red","price":40}
    anydata[] union = testUnionAssignment();
    io:println(union[0]); // @output hello world!
    io:println(union[1]); // @output 123
    io:println(union[2]); // @output 23.45
    io:println(union[3]); // @output true
    io:println(union[4]); // @output 255
    io:println(testNilAssignment()); // @output
    anydata[] finite = testFiniteTypeAssignment();
    io:println(finite[0]); // @output A
    io:println(finite[1]); // @output Z
    io:println(finite[2]); // @output 123
    io:println(finite[3]); // @output 23.45
    io:println(finite[4]); // @output true
    anydata[] array = testAnydataArray();
    anydata arrayTypeValue = array;
    io:println(arrayTypeValue is anydata[]); // @output true
    io:println(array[0]); // @output 1234
    io:println(array[1]); // @output 23.45
    io:println(array[2]); // @output true
    io:println(array[3]); // @output Hello World!
    io:println(array[4]); // @output 10
    io:println(array[5]); // @output {"a":15}
    io:println(array[6]); // @output {"name":"apple","color":"red","price":40}
    io:println(array[7]); // @output <book>The Lost World</book>
    [int, float, boolean, string] converted = testAnydataToValueTypes();
    io:println(converted[0]); // @output 33
    io:println(converted[1]); // @output 23.45
    io:println(converted[2]); // @output true
    io:println(converted[3]); // @output Hello World!
    json convertedJson = testAnydataToJson();
    anydata convertedJsonTypeValue = convertedJson;
    io:println(convertedJsonTypeValue is map<json>); // @output true
    io:println(convertedJson); // @output {"name":"apple","color":"red","price":40}
    xml convertedXml = testAnydataToXml();
    anydata convertedXmlTypeValue = convertedXml;
    io:println(convertedXmlTypeValue is xml:Element); // @output true
    io:println(convertedXml); // @output <book>The Lost World</book>
    [Foo, ClosedFoo] convertedRecords = testAnydataToRecord();
    anydata convertedRecordTypeValue = convertedRecords[0];
    io:println(convertedRecordTypeValue is Foo); // @output true
    io:println(convertedRecords[0]); // @output {"a":15}
    ValueType?[] convertedUnion = testAnydataToUnion();
    io:println(convertedUnion[0] is int); // @output true
    io:println(convertedUnion[1] is float); // @output true
    io:println(convertedUnion[2] is string); // @output true
    io:println(convertedUnion[3] is boolean); // @output true
    io:println(convertedUnion[4] is byte); // @output true
    io:println(convertedUnion[0]); // @output 10
    io:println(convertedUnion[1]); // @output 23.45
    io:println(convertedUnion[2]); // @output hello world!
    io:println(convertedUnion[3]); // @output true
    io:println(convertedUnion[4]); // @output 255
    [int, float, boolean, string, byte]? convertedTuple = testAnydataToTuple();
    io:println(convertedTuple is [int, float, boolean, string, byte]); // @output true
    io:println(convertedTuple); // @output [123,23.45,true,"hello world!",255]
    [json, xml]? convertedTuple2 = testAnydataToTuple2();
    io:println(convertedTuple2 is [json, xml]); // @output true
    io:println(convertedTuple2); // @output [{"name":"apple","color":"red","price":40},`<book>The Lost World</book>`]
    io:println(testAnydataToNil()); // @output
    FiniteT?[] convertedFinite = testAnydataToFiniteType();
    io:println(convertedFinite[0]); // @output A
    io:println(convertedFinite[1]); // @output Z
    io:println(convertedFinite[2]); // @output 123
    io:println(convertedFinite[3]); // @output 23.45
    io:println(convertedFinite[4]); // @output true
    anydata[] checked = <anydata[]>testTypeCheckingOnAny();
    anydata checkedTypeValue = checked;
    io:println(checkedTypeValue is anydata[]); // @output true
    io:println(checked[0]); // @output 10
    io:println(checked[1]); // @output 23.45
    io:println(checked[2]); // @output true
    io:println(checked[3]); // @output hello world!
    io:println(checked[4]); // @output {"name":"apple","color":"red","price":40}
    io:println(checked[5]); // @output <book>The Lost World</book>
    io:println(checked[6]); // @output {"a":15}
    io:println(checked[7]); // @output {"ca":15}
    testMapOfCharIsAnydata(); testCharArrayIsAnydata(); testMapOfIntSubtypeIsAnydata(); testArrayOfIntSubtypeIsAnydata();
    testMapOfNeverTypeIsAnydata(); testRuntimeIsAnydata(); testAnydataToTuple3(); testAnydataToUnion2(); testAnydataToTable();
    testTupleAssignment(); testUnionAssignment2(); testTableAssignment(); testMapAssignment(); testConstrainedMaps(); testArrayAssignment();
    checkpanic testAnytoAnydataTypeCast();
}
