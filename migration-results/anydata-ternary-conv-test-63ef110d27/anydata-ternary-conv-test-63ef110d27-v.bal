import ballerina/io;

type Foo record {
    int a;
};

type ClosedFoo record {|
    int ca;
|};

type ValueType int|float|string|boolean|byte;
type DataType ValueType|json|xml|ClosedFoo|Foo|map<anydata>|anydata[]|();

public function main() {
    [int, float, boolean, string] valueTypes = testAnydataToValueTypes();
    io:println(valueTypes[0]); // @output 33
    io:println(valueTypes[1]); // @output 23.45
    io:println(valueTypes[2]); // @output true
    io:println(valueTypes[3]); // @output Hello World!

    anydata jsonValue = testAnydataToJson();
    io:println(jsonValue is map<json>); // @output true
    io:println(jsonValue); // @output {"name":"apple","color":"red","price":40}

    anydata xmlValue = testAnydataToXml();
    io:println(xmlValue is xml:Element); // @output true
    io:println(xmlValue); // @output <book>The Lost World</book>

    anydata recordValues = testAnydataToRecord();
    anydata[] records = <anydata[]> recordValues;
    io:println(records[0] is Foo); // @output true
    io:println(records[0]); // @output {"a":15}

    anydata unionResult = testAnydataToUnion();
    anydata[] unionValues = <anydata[]> unionResult;
    io:println(unionValues[0] is int); // @output true
    io:println(unionValues[1] is float); // @output true
    io:println(unionValues[2] is string); // @output true
    io:println(unionValues[3] is boolean); // @output true
    io:println(unionValues[4] is byte); // @output true
    io:println(unionValues[0]); // @output 10
    io:println(unionValues[1]); // @output 23.45
    io:println(unionValues[2]); // @output hello world!
    io:println(unionValues[3]); // @output true
    io:println(unionValues[4]); // @output 255

    anydata complexUnionResult = testAnydataToUnion2();
    anydata[] complexUnionValues = <anydata[]> complexUnionResult;
    io:println(complexUnionValues[0] is map<json>); // @output true
    io:println(complexUnionValues[1] is xml:Element); // @output true
    io:println(complexUnionValues[2] is Foo); // @output true
    io:println(complexUnionValues[3] is ClosedFoo); // @output true
    io:println(complexUnionValues[0]); // @output {"name":"apple","color":"red","price":40}
    io:println(complexUnionValues[1]); // @output <book>The Lost World</book>
    io:println(complexUnionValues[2]); // @output {"a":15}
    io:println(complexUnionValues[3]); // @output {"ca":15}

    anydata tuple1 = testAnydataToTuple();
    io:println(tuple1 is [anydata, anydata, anydata, anydata, anydata]); // @output true
    io:println(typeof tuple1); // @output typedesc [int,float,boolean,string,byte]
    io:println(tuple1); // @output [123,23.45,true,"hello world!",255]

    anydata tuple2 = testAnydataToTuple2();
    io:println(tuple2 is [anydata, anydata]); // @output true
    io:println(typeof tuple2); // @output typedesc [json,xml<(lang.xml:Element|lang.xml:Comment|lang.xml:ProcessingInstruction|lang.xml:Text)>]
    io:println(tuple2); // @output [{"name":"apple","color":"red","price":40},`<book>The Lost World</book>`]

    anydata tuple3 = testAnydataToTuple3();
    io:println(tuple3 is [anydata, anydata, anydata]); // @output true
    io:println(typeof tuple3); // @output typedesc [[DataType[],string],int,float]
    io:println(tuple3); // @output [[[{"name":"apple","color":"red","price":40},`<book>The Lost World</book>`],"hello world!"],123,23.45]
    io:println(testAnydataToNil()); // @output

    anydata typeCheckedValue = testTypeCheckingOnAny();
    io:println(typeCheckedValue is anydata[]); // @output true
    anydata[] anydataValues = <anydata[]> typeCheckedValue;
    io:println(typeof typeCheckedValue); // @output typedesc anydata[]
    io:println(anydataValues[0]); // @output 10
    io:println(anydataValues[1]); // @output 23.45
    io:println(anydataValues[2]); // @output true
    io:println(anydataValues[3]); // @output hello world!
    io:println(anydataValues[4]); // @output {"name":"apple","color":"red","price":40}
    io:println(anydataValues[5]); // @output <book>The Lost World</book>
    io:println(anydataValues[6]); // @output {"a":15}
    io:println(anydataValues[7]); // @output {"ca":15}
}

function testAnydataToValueTypes() returns [int, float, boolean, string] {
    anydata ad = 33;
    int i = ad is int ? ad : -1;

    ad = 23.45;
    float f = ad is float ? ad : -1.0;

    ad = true;
    boolean bool = ad is boolean ? ad : false;

    ad = "Hello World!";
    string s = ad is string ? ad : "";

    return [i, f, bool, s];
}

function testAnydataToJson() returns json {
    json j = { name: "apple", color: "red", price: 40 };
    anydata adJ = j;
    json convertedJ = adJ is json ? adJ : ();
    return convertedJ;
}

function testAnydataToXml() returns xml {
    xml x = xml `<book>The Lost World</book>`;
    anydata adx = x;
    xml convertedX = adx is xml ? adx : xml ` `;
    return convertedX;
}

function testAnydataToRecord() returns [Foo, ClosedFoo] {
    Foo foo = {a: 15};
    anydata adr = foo;
    Foo convertedFoo = adr is Foo ? adr : {a: -1};

    ClosedFoo cFoo = {ca: 20};
    adr = cFoo;
    ClosedFoo convertedCFoo = adr is ClosedFoo ? adr : {ca: -1};

    return [convertedFoo, convertedCFoo];
}

function testAnydataToUnion() returns ValueType?[] {
    anydata ad = 10;
    ValueType?[] vt = [];
    int i = 0;

    vt[i] = ad is ValueType ? ad : -1;
    i += 1;

    ad = 23.45;
    vt[i] = ad is ValueType ? ad : -1.0;
    i += 1;

    ad = "hello world!";
    vt[i] = ad is ValueType ? ad : "";
    i += 1;

    ad = true;
    vt[i] = ad is ValueType ? ad : false;
    i += 1;

    byte b = 255;
    ad = b;
    vt[i] = ad is ValueType ? ad : 0;

    return vt;
}

function testAnydataToUnion2() returns DataType[] {
    anydata ad;
    DataType[] dt = [];
    int i = 0;

    json j = { name: "apple", color: "red", price: 40 };
    ad = j;
    dt[i] = ad is DataType ? ad : ();
    i += 1;

    xml x = xml `<book>The Lost World</book>`;
    ad = x;
    dt[i] = ad is DataType ? ad : xml ` `;
    i += 1;

    Foo foo = {a: 15};
    Foo invFoo = {a: -1};
    ad = foo;
    dt[i] = ad is DataType ? ad : invFoo;
    i += 1;

    ClosedFoo cfoo = {ca: 15};
    ClosedFoo invCFoo = {ca: -1};
    ad = cfoo;
    dt[i] = ad is DataType ? ad : invCFoo;

    return dt;
}

function testAnydataToTuple() returns [int, float, boolean, string, byte]? {
    byte b = 255;
    [int, float, boolean, string, byte] vt = [123, 23.45, true, "hello world!", b];
    anydata ad = vt;

    return ad is [int, float, boolean, string, byte] ? ad : ();
}

function testAnydataToTuple2() returns [json, xml]? {
    json j = { name: "apple", color: "red", price: 40 };
    xml x = xml `<book>The Lost World</book>`;
    [json, xml] jxt = [j, x];
    anydata ad = jxt;

    return ad is [json, xml] ? ad : ();
}

function testAnydataToTuple3() returns [[DataType[], string], int, float]? {
    json j = { name: "apple", color: "red", price: 40 };
    xml x = xml `<book>The Lost World</book>`;
    DataType[] dt = [j, x];
    [DataType[], string] ct = [dt, "hello world!"];
    [[DataType[], string], int, float] nt = [ct, 123, 23.45];
    anydata ad = nt;

    return ad is [[DataType[], string], int, float] ? ad : ();
}

function testAnydataToNil() returns int? {
    () nil = ();
    anydata ad = nil;
    return ad is () ? ad : -1;
}

function testTypeCheckingOnAny() returns anydata {
    any a = 10;
    anydata[] ad = [];
    int i = 0;

    ad[i] = a is anydata ? a : ();
    i += 1;

    a = 23.45;
    ad[i] = typeCheck(a);
    i += 1;

    a = true;
    ad[i] = typeCheck(a);
    i += 1;

    a = "hello world!";
    ad[i] = typeCheck(a);
    i += 1;

    json j = { name: "apple", color: "red", price: 40 };
    a = j;
    ad[i] = a is anydata ? a : ();
    i += 1;

    a = xml `<book>The Lost World</book>`;
    ad[i] = typeCheck(a);
    i += 1;

    Foo foo = {a: 15};
    a = foo;
    ad[i] = typeCheck(a);
    i += 1;

    ClosedFoo cfoo = {ca: 15};
    a = cfoo;
    ad[i] = typeCheck(a);

    return ad;
}

function typeCheck(any a) returns anydata {
    return a is anydata ? a : ();
}
