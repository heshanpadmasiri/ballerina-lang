import ballerina/io;

type RecType0 record { string name; };

class Obj0 {
    string a;
    int b;
    function init(string a, int b) { self.a = a; self.b = b; }
}

public function main() returns error? {
    typeDescOfExpressionsOfLiterals();
    passTypeofToAFunction();
    typeDescOfARecord();
    typeDescOrAObject();
    passTypeofAsRestParams();
    compareTypeOfValues();
    typeDescOfLiterals();
    typeOfImmutableStructuralValues();
    typeOfWithCloneReadOnly();
    check typeOfWithCloneWithTypeOnSameValue();
    check typeOfWithCloneWithTypeOnDifferentValue();
    check typeOfWithEnsureTypeOnSameValue();
    check typeOfTypeReferenceTypeValues();
}

function typeDescOfExpressionsOfLiterals() {
    int i = 0;
    int j = 4;
    int k = 4;
    float f = 0.0;
    float ff = 22.0;
    var r1 = typeof (i + j * k);
    io:println(r1.toString()); // @output typedesc 16
    var r2 = typeof (f * ff);
    io:println(r2.toString()); // @output typedesc 0.0
}

function takesATypedescParam(typedesc<any> param) returns typedesc<any> => param;

function passTypeofToAFunction() {
    typedesc<any> t = typeof 22;
    var t1 = takesATypedescParam(t);
    var t2 = takesATypedescParam(typeof 33);
    io:println(t1.toString()); // @output typedesc 22
    io:println(t2.toString()); // @output typedesc 33
}

function typeDescOfARecord() {
    RecType0 i = {name: "theName"};
    typedesc<any> td0 = typeof i;
    io:println(td0.toString()); // @output typedesc RecType0
}

function typeDescOrAObject() {
    Obj0 o = new ("name", 42);
    io:println((typeof o).toString()); // @output typedesc Obj0
}

function takeTypeofAsRestParams(typedesc<any>... xs) returns typedesc<any>[] => xs;

function passTypeofAsRestParams() {
    typedesc<any>[] result = takeTypeofAsRestParams(typeof 22, typeof 33, typeof 33.33);
    io:println(result[0].toString()); // @output typedesc 22
    io:println(result[1].toString()); // @output typedesc 33
    io:println(result[2].toString()); // @output typedesc 33.33
}

function compareTypeOfValues() {
    int i = 34;
    io:println(typeof i === typeof i); // @output false
    xml xmlValue = xml `<data>test</data>`;
    io:println(typeof xmlValue === typeof xmlValue); // @output true
    int[] arr = [1, 2, 3];
    io:println(typeof arr === typeof arr); // @output true
    [string, int] tuple = ["ballerina", 123];
    io:println(typeof tuple === typeof tuple); // @output true
    RecType0 rec = {name: "test"};
    io:println(typeof rec === typeof rec); // @output true
    io:println(typeof rec === RecType0); // @output true
    map<string> mapVal = {s: "test"};
    io:println(typeof mapVal === typeof mapVal); // @output true
    table<map<string>> tableVal = table [{s: "test"}];
    io:println(typeof tableVal === typeof tableVal); // @output true
    Obj0 obj = new ("abc", 123);
    io:println(typeof obj === typeof obj); // @output true
    error err = error("This is an error!");
    io:println(typeof err === typeof err); // @output true
}

function typeDescOfLiterals() {
    io:println(checkTypeDescLiteral(1)); // @output typedesc 1
    io:println(checkTypeDescLiteral(2.0d)); // @output typedesc 2.0
    io:println(checkTypeDescLiteral(2.1)); // @output typedesc 2.1
    io:println(checkTypeDescLiteral("str-literal")); // @output typedesc str-literal
    io:println(checkTypeDescLiteral(true)); // @output typedesc true
    io:println(checkTypeDescLiteral(false)); // @output typedesc false
    io:println(checkTypeDescLiteral(())); // @output typedesc ()
}

function checkTypeDescLiteral(any value) returns string {
    var valueType = typeof value;
    return valueType.toString();
}

function typeOfImmutableStructuralValues() {
    xml & readonly xmlValue = xml `<data>test</data>`;
    io:println(typeof xmlValue === typeof xmlValue); // @output true
    io:println((typeof xmlValue).toString()); // @output typedesc <data>test</data>
    int[] & readonly arr = [1, 2, 3];
    io:println(typeof arr === typeof arr); // @output true
    io:println((typeof arr).toString()); // @output typedesc [1,2,3]
    [string, int] & readonly tuple = ["ballerina", 123];
    io:println(typeof tuple === typeof tuple); // @output true
    io:println((typeof tuple).toString()); // @output typedesc ["ballerina",123]
    RecType0 & readonly rec = {name: "test"};
    io:println(typeof rec === typeof rec); // @output true
    io:println(typeof rec !== RecType0); // @output true
    io:println((typeof rec).toString()); // @output typedesc {"name":"test"}
    map<string> & readonly mapVal = {s: "test"};
    io:println(typeof mapVal === typeof mapVal); // @output true
    io:println((typeof mapVal).toString()); // @output typedesc {"s":"test"}
    table<map<string>> & readonly tableVal = table [{s: "test"}];
    io:println(typeof tableVal === typeof tableVal); // @output true
    io:println((typeof tableVal).toString()); // @output typedesc [{"s":"test"}]
}

function typeOfWithCloneReadOnly() {
    xml & readonly xmlValue = xml `<?xml-stylesheet href="mystyle.css" type="text/css"?>`;
    any val = xmlValue.cloneReadOnly();
    io:println(typeof val === typeof val); // @output true
    io:println((typeof val).toString()); // @output typedesc <?xml-stylesheet href="mystyle.css" type="text/css"?>
    int[] arr = [1, 2, 3];
    val = arr.cloneReadOnly();
    io:println(typeof val === typeof val); // @output true
    io:println((typeof val).toString()); // @output typedesc [1,2,3]
    [string, int] tuple = ["ballerina", 123];
    val = tuple.cloneReadOnly();
    io:println(typeof val === typeof val); // @output true
    io:println((typeof val).toString()); // @output typedesc ["ballerina",123]
    RecType0 rec = {name: "test"};
    val = rec.cloneReadOnly();
    io:println(typeof val === typeof val); // @output true
    io:println(typeof val !== RecType0); // @output true
    io:println((typeof val).toString()); // @output typedesc {"name":"test"}
    map<string> mapVal = {s: "test"};
    val = mapVal.cloneReadOnly();
    io:println(typeof val === typeof val); // @output true
    io:println((typeof val).toString()); // @output typedesc {"s":"test"}
    table<map<string>> tableVal = table [{s: "test"}];
    val = tableVal.cloneReadOnly();
    io:println(typeof val === typeof val); // @output true
    io:println((typeof val).toString()); // @output typedesc [{"s":"test"}]
}

function typeOfWithCloneWithTypeOnSameValue() returns error? {
    xml:ProcessingInstruction & readonly xmlValue = xml `<?xml-stylesheet href="mystyle.css" type="text/css"?>`;
    xml & readonly clonableXml = xml `<?xml-stylesheet href="mystyle.css" type="text/css"?>`;
    anydata val = check clonableXml.cloneWithType(typeof xmlValue);
    io:println(val is xml:ProcessingInstruction); // @output true
    io:println(val == xml `<?xml-stylesheet href="mystyle.css" type="text/css"?>`); // @output true
    io:println((typeof val).toString()); // @output typedesc <?xml-stylesheet href="mystyle.css" type="text/css"?>
    int[] & readonly arr = [1, 2, 3];
    int[] clonableArray = [1, 2, 3];
    val = check clonableArray.cloneWithType(typeof arr);
    io:println(val is int[]); // @output true
    io:println(val == [1, 2, 3]); // @output true
    io:println((typeof val).toString()); // @output typedesc [1,2,3]
    [string, int] & readonly tuple = ["ballerina", 123];
    [string, int] clonableTuple = ["ballerina", 123];
    val = check clonableTuple.cloneWithType(typeof tuple);
    io:println(val is [string, int]); // @output true
    io:println(val == ["ballerina", 123]); // @output true
    io:println((typeof val).toString()); // @output typedesc ["ballerina",123]
    RecType0 & readonly rec = {name: "test"};
    map<anydata> clonableRec = {name: "test"};
    val = check clonableRec.cloneWithType(typeof rec);
    io:println(val is RecType0); // @output true
    io:println(val is readonly); // @output true
    io:println(val == {name: "test"}); // @output true
    io:println((typeof val).toString()); // @output typedesc {"name":"test"}
    map<string> & readonly mapVal = {s: "test"};
    map<anydata> clonableMap = {s: "test"};
    val = check clonableMap.cloneWithType(typeof mapVal);
    io:println(val is map<string>); // @output true
    io:println(val is readonly); // @output true
    io:println(val == {s: "test"}); // @output true
    io:println((typeof val).toString()); // @output typedesc {"s":"test"}
    table<map<string>> & readonly tableVal = table [{s: "test"}];
    table<map<anydata>> clonableTable = table [{s: "test"}];
    val = check clonableTable.cloneWithType(typeof tableVal);
    io:println(val is table<map<string>>); // @output true
    io:println(val is readonly); // @output true
    io:println(val == table [{s: "test"}]); // @output true
    io:println((typeof val).toString()); // @output typedesc [{"s":"test"}]
}

function typeOfWithCloneWithTypeOnDifferentValue() returns error? {
    xml & readonly xmlValue = xml `<?xml-stylesheet href="mystyle.css" type="text/css"?>`;
    xml clonableXml = xml `<data>test</data>`;
    var val1 = clonableXml.cloneWithType(typeof xmlValue);
    io:println(val1 is error); // @output true
    error err = <error>val1;
    io:println(err.detail().toString()); // @output {"message":"'lang.xml:Element' value cannot be converted to '<?xml-stylesheet href="mystyle.css" type="text/css"?>'"}
    int[] & readonly arr = [1, 2, 3];
    anydata[] clonableArray = [1, 2, 3, 23];
    anydata val = check clonableArray.cloneWithType(typeof arr);
    io:println(val is int[]); // @output true
    io:println(val == [1, 2, 3, 23]); // @output true
    io:println((typeof val).toString()); // @output typedesc [1,2,3,23]
    [string, int] & readonly tuple = ["ballerina", 123];
    [string, int] clonableTuple = ["ballerina-lang", 324];
    val = check clonableTuple.cloneWithType(typeof tuple);
    io:println(val is [string, int]); // @output true
    io:println(val == ["ballerina-lang", 324]); // @output true
    io:println((typeof val).toString()); // @output typedesc ["ballerina-lang",324]
    RecType0 & readonly rec = {name: "test"};
    map<anydata> clonableRec = {name: "Hinduja"};
    val = check clonableRec.cloneWithType(typeof rec);
    io:println(val is RecType0); // @output true
    io:println(val is readonly); // @output true
    io:println(val == {name: "Hinduja"}); // @output true
    io:println((typeof val).toString()); // @output typedesc {"name":"Hinduja"}
    map<string> & readonly mapVal = {s: "test"};
    map<anydata> clonableMap = {s: "Jane Doe"};
    val = check clonableMap.cloneWithType(typeof mapVal);
    io:println(val is map<string>); // @output true
    io:println(val is readonly); // @output true
    io:println(val == {s: "Jane Doe"}); // @output true
    io:println((typeof val).toString()); // @output typedesc {"s":"Jane Doe"}
    table<map<string>> & readonly tableVal = table [{s: "test"}];
    table<map<anydata>> clonableTable = table [{s: "test", a: "test 2"}];
    val = check clonableTable.cloneWithType(typeof tableVal);
    io:println(val is table<map<string>>); // @output true
    io:println(val is readonly); // @output true
    io:println(val == table [{s: "test", a: "test 2"}]); // @output true
    io:println((typeof val).toString()); // @output typedesc [{"s":"test","a":"test 2"}]
}

function typeOfWithEnsureTypeOnSameValue() returns error? {
    xml:ProcessingInstruction & readonly xmlValue = xml `<?xml-stylesheet href="mystyle.css" type="text/css"?>`;
    xml & readonly clonableXml = xml `<?xml-stylesheet href="mystyle.css" type="text/css"?>`;
    anydata val = check clonableXml.ensureType(typeof xmlValue);
    io:println(val is xml:ProcessingInstruction); // @output true
    io:println(val == xml `<?xml-stylesheet href="mystyle.css" type="text/css"?>`); // @output true
    io:println((typeof val).toString()); // @output typedesc <?xml-stylesheet href="mystyle.css" type="text/css"?>
    byte[] & readonly arr = [1, 2, 3];
    int[] & readonly clonableArray = [1, 2, 3];
    val = check clonableArray.ensureType(typeof arr);
    io:println(val is int[]); // @output true
    io:println(val == [1, 2, 3]); // @output true
    io:println((typeof val).toString()); // @output typedesc [1,2,3]
    [string, int] & readonly tuple = ["ballerina", 123];
    anydata[] & readonly clonableTuple = ["ballerina", 123];
    val = check clonableTuple.ensureType(typeof tuple);
    io:println(val is [string, int]); // @output true
    io:println(val == ["ballerina", 123]); // @output true
    io:println((typeof val).toString()); // @output typedesc ["ballerina",123]
    RecType0 & readonly rec = {name: "test"};
    map<anydata> & readonly clonableRec = {name: "test"};
    val = check clonableRec.ensureType(typeof rec);
    io:println(val is RecType0); // @output true
    io:println(val is readonly); // @output true
    io:println(val == {name: "test"}); // @output true
    io:println((typeof val).toString()); // @output typedesc {"name":"test"}
    map<string> & readonly mapVal = {s: "test"};
    map<anydata> & readonly clonableMap = {s: "test"};
    val = check clonableMap.ensureType(typeof mapVal);
    io:println(val is map<string>); // @output true
    io:println(val is readonly); // @output true
    io:println(val == {s: "test"}); // @output true
    io:println((typeof val).toString()); // @output typedesc {"s":"test"}
    table<map<string>> & readonly tableVal = table [{s: "test"}];
    table<map<anydata>> & readonly clonableTable = table [{s: "test"}];
    val = check clonableTable.ensureType(typeof tableVal);
    io:println(val is table<map<string>>); // @output true
    io:println(val is readonly); // @output true
    io:println(val == table [{s: "test"}]); // @output true
    io:println((typeof val).toString()); // @output typedesc [{"s":"test"}]
}

type Array int[];
type Tuple [int, string];
type Table table<map<anydata>>;
type Map map<anydata>;
type Person record { string name; };
type Employee Person;

function typeOfTypeReferenceTypeValues() returns error? {
    Array a = [1, 2, 3];
    Tuple t = [1, "hello"];
    Table tb = table [{id: 1, name: "Gabilan"}, {id: 2, name: "Nadesshan"}];
    Map m = {name: "Waruna"};
    Employee e = {name: "Hinduja"};
    io:println((typeof a).toString()); // @output typedesc Array
    io:println((typeof t).toString()); // @output typedesc Tuple
    io:println((typeof tb).toString()); // @output typedesc Table
    io:println((typeof m).toString()); // @output typedesc Map
    io:println((typeof e).toString()); // @output typedesc Employee
}
