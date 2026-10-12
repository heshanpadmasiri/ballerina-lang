import ballerina/io;

function testStringAsJsonVal() returns json {
    json j = "Supun";
    return j;
}

function testIntAsJsonVal() returns json {
    json j = 5;
    return j;
}

function testFloatAsJsonVal() returns json {
    json j = 7.65;
    return j;
}

function testByteAsJsonVal() returns json {
    byte b = 5;
    json j = b;
    return j;
}

function testDecimalAsJsonVal() returns json {
    decimal d = 7.65;
    json j = d;
    return j;
}

function testBooleanAsJsonVal() returns json {
    json j = true;
    return j;
}

function testNullAsJsonVal() returns json {
    json j = null;
    return j;
}

function testJsonWithNull() returns [json, json|error] {
    json j = {"name": null};
    return [j, j.name];
}

function testNestedJsonInit() returns json {
    json j = {name: "aaa", age: 25, parent: {name: "bbb", age: 50}, address: {city: "Colombo", "country": "SriLanka"}, array: [1, 5, 7]};
    return j;
}

function testGetString() returns [string, string] {
    json j1 = "Supun";
    json j2 = {name: "Setunga"};
    string j1String;
    string j2String;
    j1String = <string> j1;
    j2String = <string> checkpanic j2.name;
    return [j1String, j2String];
}

function testGetInt() returns [int, int] {
    json j1 = 25;
    json j2 = {age: 43};
    int j1Int;
    int j2Int;
    j1Int = <int>j1;
    j2Int = <int> checkpanic j2.age;
    return [j1Int, j2Int];
}

function testGetFloat() returns float {
    json j = {score: 9.73};
    float jFloat;
    jFloat = <float> checkpanic j.score;
    return jFloat;
}

function testGetDecimal() returns decimal {
    json j = {score: 9.5};
    decimal jDecimal;
    jDecimal = <decimal> checkpanic j.score;
    return jDecimal;
}

function testGetBoolean() returns boolean {
    json j = {pass: true};
    boolean jBoolean;
    jBoolean = <boolean> checkpanic j.pass;
    return jBoolean;
}

function testGetJson() returns json|error {
    json j = {address: {city: "Colombo", "country": "SriLanka"}};
    return j.address;
}

function testGetNonExistingElement() returns json|error {
    json j2 = {age: 43};
    return j2.name;
}

function testAddString() returns json {
    json j = {fname: "Supun"};
    map<json> jm = <map<json>>j;
    jm["lname"] = "Setunga";
    return j;
}

function testAddInt() returns json {
    json j = {fname: "Supun"};
    map<json> jm = <map<json>>j;
    jm["age"] = 25;
    return j;
}

function testAddFloat() returns json {
    json j = {fname: "Supun"};
    map<json> jm = <map<json>>j;
    jm["score"] = 4.37;
    return j;
}

function testAddDecimal() returns json {
    json j = {fname: "Supun"};
    decimal d = 4.37;
    map<json> jm = <map<json>>j;
    jm["score"] = d;
    return j;
}

function testAddBoolean() returns json {
    json j = {fname: "Supun"};
    map<json> jm = <map<json>>j;
    jm["status"] = true;
    return j;
}

function testAddJson() returns json {
    json j = {fname: "Supun"};
    map<json> jm = <map<json>>j;
    jm["address"] = {country: "SriLanka"};
    return j;
}

function testUpdateString() returns json {
    json j = {fname: "Supun", lname: "Thilina"};
    map<json> jm = <map<json>>j;
    jm["lname"] = "Setunga";
    return j;
}

function testUpdateInt() returns json {
    json j = {fname: "Supun", age: 30};
    map<json> jm = <map<json>>j;
    jm["age"] = 25;
    return j;
}

function testUpdateFloat() returns json {
    json j = {fname: "Supun", score: 7.65};
    map<json> jm = <map<json>>j;
    jm["score"] = 4.37;
    return j;
}

function testUpdateBoolean() returns json {
    json j = {fname: "Supun", status: false};
    map<json> jm = <map<json>>j;
    jm["status"] = true;
    return j;
}

function testUpdateJson() returns json {
    json j = {fname: "Supun", address: {country: "USA"}};
    map<json> jm = <map<json>>j;
    jm["address"] = {country: "SriLanka"};
    return j;
}

function testUpdateStringInArray() returns json {
    json j = ["a", "b", "c"];
    json[] ja = <json[]>j;
    ja[1] = "d";
    return j;
}

function testUpdateIntInArray() returns json {
    json j = ["a", "b", "c"];
    json[] ja = <json[]>j;
    ja[1] = 64;
    return j;
}

function testUpdateFloatInArray() returns json {
    json j = ["a", "b", "c"];
    json[] ja = <json[]>j;
    ja[1] = 4.72;
    return j;
}

function testUpdateDecimalInArray() returns json {
    json j = ["a", "b", "c"];
    json[] ja = <json[]>j;
    decimal d = 4.72;
    ja[1] = d;
    return j;
}

function testUpdateBooleanInArray() returns json {
    json j = ["a", "b", "c"];
    json[] ja = <json[]>j;
    ja[1] = true;
    return j;
}

function testUpdateNullInArray() returns json {
    json j = ["a", "b", "c"];
    json[] ja = <json[]>j;
    ja[1] = null;
    return j;
}

function testUpdateJsonInArray() returns json {
    json j = ["a", "b", "c"];
    json[] ja = <json[]>j;
    ja[1] = {country: "SriLanka"};
    return j;
}

function testUpdateJsonArrayInArray() returns json {
    json j = ["a", "b", "c"];
    json[] ja = <json[]>j;
    ja[1] = [1, 2, 3];
    return j;
}

function testGetNestedJsonElement() returns string {
    json j = {name: "aaa", age: 25, parent: {name: "bbb", age: 50}, address: {city: "Colombo", "country": "SriLanka"}, array: [1, 5, 7]};
    string cityString;
    cityString = <string> checkpanic j.address.city;
    return cityString;
}

function testSetArrayOutofBoundElement() returns json {
    json j = [1, 2, 3];
    json[] ja = <json[]>j;
    ja[7] = 8;
    return j;
}

function testGetStringInArray() returns string {
    json j = ["a", "b", "c"];
    json[] ja = <json[]>j;
    string value;
    value = <string>ja[1];
    return value;
}

function testGetElementFromPrimitive() returns json|error {
    json j = {name: "Supun"};
    return j.name.fname;
}

function testUpdateNestedElement() returns json {
    json j = {details: {fname: "Supun", lname: "Thilina"}};
    map<json> jm = <map<json>>j;
    map<json> jmDetails = <map<json>>jm["details"];
    jmDetails["lname"] = "Setunga";
    return j;
}

function testEmptyStringToJson() returns json|error {
    string s = "";
    return s.cloneWithType(json);
}

function testJsonStringToJson() returns json|error {
    string s = "{\"name\", \"supun\"}";
    return s.cloneWithType(json);
}

function testStringWithEscapedCharsToJson() returns json|error {
    string s = "{\\\"name\\\", \"supun\"}";
    return s.cloneWithType(json);
}

function testJsonArrayToJsonCasting() returns json {
    json[][] j1 = [[1, 2, 3], [3, 4, 5], [7, 8, 9]];
    json j2 = j1;
    return j2;
}

type Json2DArray json[][];

function testJsonToJsonArrayCasting() returns [any, json[][]|error, json[][]|error] {
    json j1 = [[1, 2, 3], [3, 4, 5], [7, 8, 9]];
    json[] j2 = <json[]>j1;
    json[][]|error j3 = trap <json[][]>j1;
    json[][]|error j4 = j1.cloneWithType(Json2DArray);
    return [j2, j3, j4];
}

type Json3DArray json[][][];

function testJsonToJsonArrayInvalidCasting() returns json[][][]|error {
    json j1 = [[1, 2, 3], [3, 4, 5], [7, 8, 9]];
    var j2 = j1.cloneWithType(Json3DArray);
    return j2;
}

function testJsonLength() returns int {
    json[] j = [[1, 2, 3, 4], [3, 4, 5, 6], [7, 8, 9, 10]];
    return j.length();
}

function testGetFromNull() returns json|error {
    json j2 = {age: 43, name: null};
    return j2.name.fname;
}

function testAddToNull() returns json {
    json j = {name: "Supun", address: null};
    map<json> jm = <map<json>>j;
    jm["address"] = {country: "SriLanka"};
    return j;
}

function testJsonIntToFloat() returns float {
    json j = {score: 4};
    float jFloat = <float> checkpanic j.score;
    return jFloat;
}

function testIntArrayToJsonAssignment() returns [json, json] {
    int[] a = [1, 5, 9];
    json[] j = a;
    j[3] = 4;
    return [j, j[1]];
}

function testFloatArrayToJsonAssignment() returns [json, json] {
    float[] f = [1.3, 5.4, 9.4];
    json[] j = f;
    j[3] = 4.5;
    return [j, j[1]];
}

function testDecimalArrayToJsonAssignment() returns [json, json] {
    decimal[] d = [1.3, 1.234, 4.1];
    json[] j = d;
    j[3] = <decimal>4.54;
    return [j, j[1]];
}

function testStringArrayToJsonAssignment() returns [json, json] {
    string[] s = ["apple", "orange"];
    json[] j = s;
    j[2] = "grape";
    return [j, j[1]];
}

function testBooleanArrayToJsonAssignment() returns [json, json] {
    boolean[] b = [true, true, false];
    json[] j = b;
    j[3] = true;
    return [j, j[1]];
}

function testJsonLaxErrorLifting() {
    error? e1 = testSimpleVarRefJsonErrorLiftingInLaxTyping();
    assertTrue(e1 is ());
    error? e2 = testJsonMapErrorLifingInLaxTyping();
    assertTrue(e2 is ());
    error? e3 = testJsonReturnTypeErrorLifting();
    assertTrue(e3 is ());
    error? e4 = testLaxAccessForRuntimeErrors1();
    assertTrue(e4 is error);
    assertEquals(<string>checkpanic (<error>e4).detail()["message"],
        "incompatible types: 'string' cannot be cast to 'int'");
    error? e5 = testLaxAccessForRuntimeErrors2();
    assertTrue(e5 is error);
    assertEquals(<string>checkpanic (<error>e5).detail()["message"],
        "incompatible types: 'int' cannot be cast to 'string'");
}

public function testSimpleVarRefJsonErrorLiftingInLaxTyping() returns error? {
    json j = 1;
    int i = check j;
    assertEquals(1, i);
}

public function testLaxAccessForRuntimeErrors1() returns error? {
    json j = "1";
    int i = check j;
}

public function testJsonMapErrorLifingInLaxTyping() returns error? {
    json j = {
        x: {
            y: {
                z: "value"
            }
        }
    };

    string val =  check j.x.y.z;
    assertEquals("value", val);
}

public function testLaxAccessForRuntimeErrors2() returns error? {
    json j = {
        x: {
            y: {
                z: 1
            }
        }
    };

    string val = check j.x.y.z;
}

public function testJsonReturnTypeErrorLifting() returns error? {
    int i = check foo();
    assertEquals(1, i);
}

function foo() returns json {
    json j = 1;
    return j;
}

function testJsonMapAccess() returns error? {
    map<map<json>> mapVal = {};
    json|error result = mapVal.__.__;
    assertTrue(result is error);
    error err = <error>result;
    assertEquals("{ballerina/lang.map}KeyNotFound", err.message());
    assertEquals("key '__' not found in JSON mapping", <string>checkpanic err.detail()["message"]);

    mapVal = {a: {a: "aaa"}};
    result = mapVal.b.a;
    assertTrue(result is error);
    err = <error>result;
    assertEquals("{ballerina/lang.map}KeyNotFound", err.message());
    assertEquals("key 'b' not found in JSON mapping", <string>checkpanic err.detail()["message"]);

    result = mapVal.a;
    assertTrue(result is json);
    assertEquals({a: "aaa"}, check result);

    result = mapVal.a.a;
    assertTrue(result is json);
    assertEquals("aaa", check result);

    json jsonVal = {};
    result = jsonVal.b.a;
    assertTrue(result is error);
    err = <error>result;
    assertEquals("{ballerina/lang.map}KeyNotFound", err.message());
    assertEquals("key 'b' not found in JSON mapping", <string>checkpanic err.detail()["message"]);

    map<map<map<json>>> x1 = {};
    result = x1.__.__;
    assertTrue(result is error);
    err = <error>result;
    assertEquals("{ballerina/lang.map}KeyNotFound", err.message());
    assertEquals("key '__' not found in JSON mapping", <string>checkpanic err.detail()["message"]);

    map<map<map<map<json>>>> x2 = {};
    result = x2.__.__;
    assertTrue(result is error);
    err = <error>result;
    assertEquals("{ballerina/lang.map}KeyNotFound", err.message());
    assertEquals("key '__' not found in JSON mapping", <string>checkpanic err.detail()["message"]);
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertTrue(boolean actual) {
    assertEquals(true, actual);
}

function assertEquals(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    typedesc<anydata> expT = typeof expected;
    typedesc<anydata> actT = typeof actual;
    string msg = "expected [" + expected.toString() + "] of type [" + expT.toString()
        + "], but found [" + actual.toString() + "] of type [" + actT.toString() + "]";
    panic error(ASSERTION_ERROR_REASON, message = msg);
}

public function main() {
    io:println(testStringAsJsonVal()); // @output Supun
    io:println(testIntAsJsonVal()); // @output 5
    io:println(testFloatAsJsonVal()); // @output 7.65
    io:println(testByteAsJsonVal()); // @output 5
    io:println(testDecimalAsJsonVal()); // @output 7.65
    io:println(testBooleanAsJsonVal()); // @output true
    io:println(testNullAsJsonVal()); // @output
    io:println(testNestedJsonInit()); // @output {"name":"aaa","age":25,"parent":{"name":"bbb","age":50},"address":{"city":"Colombo","country":"SriLanka"},"array":[1,5,7]}
    [json, json|error] withNull = testJsonWithNull();
    io:println(withNull[0]); // @output {"name":null}
    io:println(withNull[1]); // @output
    [string, string] strings = testGetString();
    io:println(strings[0]); // @output Supun
    io:println(strings[1]); // @output Setunga
    [int, int] ints = testGetInt();
    io:println(ints[0]); // @output 25
    io:println(ints[1]); // @output 43
    io:println(testGetFloat()); // @output 9.73
    io:println(testGetDecimal()); // @output 9.5
    io:println(testGetBoolean()); // @output true
    io:println(checkpanic testGetJson()); // @output {"city":"Colombo","country":"SriLanka"}
    error missing = <error>testGetNonExistingElement();
    io:println(checkpanic missing.detail()["message"]); // @output key 'name' not found in JSON mapping
    io:println(testAddString()); // @output {"fname":"Supun","lname":"Setunga"}
    io:println(testAddInt()); // @output {"fname":"Supun","age":25}
    io:println(testAddFloat()); // @output {"fname":"Supun","score":4.37}
    io:println(testAddDecimal()); // @output {"fname":"Supun","score":4.37}
    io:println(testAddBoolean()); // @output {"fname":"Supun","status":true}
    io:println(testAddJson()); // @output {"fname":"Supun","address":{"country":"SriLanka"}}
    io:println(testUpdateString()); // @output {"fname":"Supun","lname":"Setunga"}
    io:println(testUpdateInt()); // @output {"fname":"Supun","age":25}
    io:println(testUpdateFloat()); // @output {"fname":"Supun","score":4.37}
    io:println(testUpdateBoolean()); // @output {"fname":"Supun","status":true}
    io:println(testUpdateJson()); // @output {"fname":"Supun","address":{"country":"SriLanka"}}
    io:println(testUpdateStringInArray()); // @output ["a","d","c"]
    io:println(testUpdateIntInArray()); // @output ["a",64,"c"]
    io:println(testUpdateFloatInArray()); // @output ["a",4.72,"c"]
    io:println(testUpdateDecimalInArray()); // @output ["a",4.72,"c"]
    io:println(testUpdateBooleanInArray()); // @output ["a",true,"c"]
    io:println(testUpdateNullInArray()); // @output ["a",null,"c"]
    io:println(testUpdateJsonInArray()); // @output ["a",{"country":"SriLanka"},"c"]
    io:println(testUpdateJsonArrayInArray()); // @output ["a",[1,2,3],"c"]
    io:println(testGetNestedJsonElement()); // @output Colombo
    io:println(testSetArrayOutofBoundElement()); // @output [1,2,3,null,null,null,null,8]
    io:println(testGetStringInArray()); // @output b
    error primitive = <error>testGetElementFromPrimitive();
    io:println(checkpanic primitive.detail()["message"]); // @output JSON value is not a mapping
    io:println(testUpdateNestedElement()); // @output {"details":{"fname":"Supun","lname":"Setunga"}}
    io:println(checkpanic testEmptyStringToJson()); // @output 
    io:println(checkpanic testJsonStringToJson()); // @output {"name", "supun"}
    io:println(checkpanic testStringWithEscapedCharsToJson()); // @output {\"name\", "supun"}
    io:println(testJsonArrayToJsonCasting()); // @output [[1,2,3],[3,4,5],[7,8,9]]
    [any, json[][]|error, json[][]|error] casted = testJsonToJsonArrayCasting();
    io:println(casted[0]); // @output [[1,2,3],[3,4,5],[7,8,9]]
    io:println(checkpanic (<error>casted[1]).detail()["message"]); // @output incompatible types: 'json[]' cannot be cast to 'json[][]'
    io:println(checkpanic casted[2]); // @output [[1,2,3],[3,4,5],[7,8,9]]
    error invalidCast = <error>testJsonToJsonArrayInvalidCasting();
    io:println(checkpanic invalidCast.detail()["message"]); // @output 'json[]' value cannot be converted to 'Json3DArray': 
    // @output 		array element '[0][0]' should be of type 'json[]', found '1'
    // @output 		array element '[0][1]' should be of type 'json[]', found '2'
    // @output 		array element '[0][2]' should be of type 'json[]', found '3'
    // @output 		array element '[1][0]' should be of type 'json[]', found '3'
    // @output 		array element '[1][1]' should be of type 'json[]', found '4'
    // @output 		array element '[1][2]' should be of type 'json[]', found '5'
    // @output 		array element '[2][0]' should be of type 'json[]', found '7'
    // @output 		array element '[2][1]' should be of type 'json[]', found '8'
    // @output 		array element '[2][2]' should be of type 'json[]', found '9'
    io:println(testJsonLength()); // @output 3
    error nullAccess = <error>testGetFromNull();
    io:println(checkpanic nullAccess.detail()["message"]); // @output JSON value is not a mapping
    io:println(testAddToNull()); // @output {"name":"Supun","address":{"country":"SriLanka"}}
    io:println(testJsonIntToFloat()); // @output 4.0
    error? ignoredMapAccess = testJsonMapAccess();
    assertTrue(ignoredMapAccess is ());
    [json, json] intArray = testIntArrayToJsonAssignment();
    io:println(intArray[0]); // @output [1,5,9,4]
    io:println(intArray[1]); // @output 5
    [json, json] floatArray = testFloatArrayToJsonAssignment();
    io:println(floatArray[0]); // @output [1.3,5.4,9.4,4.5]
    io:println(floatArray[1]); // @output 5.4
    [json, json] decimalArray = testDecimalArrayToJsonAssignment();
    io:println(decimalArray[0]); // @output [1.3,1.234,4.1,4.54]
    io:println(decimalArray[1]); // @output 1.234
    [json, json] stringArray = testStringArrayToJsonAssignment();
    io:println(stringArray[0]); // @output ["apple","orange","grape"]
    io:println(stringArray[1]); // @output orange
    [json, json] booleanArray = testBooleanArrayToJsonAssignment();
    io:println(booleanArray[0]); // @output [true,true,false,true]
    io:println(booleanArray[1]); // @output true
    testJsonLaxErrorLifting();
}
