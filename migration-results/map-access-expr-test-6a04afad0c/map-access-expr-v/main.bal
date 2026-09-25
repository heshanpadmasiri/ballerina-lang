import ballerina/io;

function mapAccessTest(int x, int y) returns int {
    map<any> testMap = {};
    testMap["first"] = x;
    testMap["second"] = y;
    testMap["third"] = x + y;
    testMap["forth"] = x - y;
    int xx = <int>testMap["first"];
    int yy = <int>testMap["second"];
    return xx + yy;
}

function mapReturnTest(string firstName, string lastName) returns map<any> {
    map<any> testMap = {};
    testMap["fname"] = firstName;
    testMap["lname"] = lastName;
    testMap[firstName + lastName] = firstName + lastName;
    return testMap;
}

function testArrayAccessAsIndexOfMapt() returns string {
    map<any> namesMap = {fname: "Supun", lname: "Setunga"};
    string[] keys = ["fname", "lname"];
    var a = namesMap[keys[0]];
    return a is string ? a : "";
}

function testAccessThroughVar() returns string {
    map<any> m = {};
    m["x"] = "a";
    m["y"] = "b";
    m["z"] = "c";
    return constructString(m);
}

function constructString(map<any> m) returns string {
    string[] keys = m.keys();
    string returnStr = "";
    int i = 0;
    while i < keys.length() {
        string key = keys[i];
        var a = m[key];
        string val = a is string ? a : "";
        returnStr += key + ":" + val + ", ";
        i += 1;
    }
    return returnStr;
}

function testMapRemoveAll() returns int {
    map<any> namesMap = {fname: "Supun", lname: "Setunga", sname: "Kevin", tname: "Ratnasekera"};
    namesMap.removeAll();
    return namesMap.length();
}

function testHasKeyPositive() returns boolean {
    map<any> namesMap = {fname: "Supun", lname: "Setunga", sname: "Kevin", tname: "Ratnasekera"};
    return namesMap.hasKey("fname");
}

function testHasKeyNegative() returns boolean {
    map<any> namesMap = {fname: "Supun", lname: "Setunga", sname: "Kevin", tname: "Ratnasekera"};
    return namesMap.hasKey("fname2");
}

function testGetMapValues() returns [string, string] {
    json j = {"city": "Colombo", "country": "SriLanka"};
    int[] arr = [7, 8, 9];
    map<any> address = {city: "CA", country: "USA"};
    map<map<any>>[] addressArray = [{address: {city: "Colombo", country: "SriLanka"}},
        {address: {city: "Kandy", country: "SriLanka"}}, {address: {city: "Galle", country: "SriLanka"}}];
    map<any> m = {name: "Supun", age: 25, gpa: 2.81, status: true, info: (), address: address, intArray: arr,
        addressArray: addressArray, finfo: j};
    any[] values = m.reduce(function(any[] arr1, any value) returns any[] {
        arr1[arr1.length()] = value;
        return arr1;
    }, []);
    string nam = <string>values[0];
    json jsn = <json>values[8];
    string city = <string>checkpanic jsn.city;
    return [nam, city];
}

function testMapRemovePositive() returns [boolean, boolean, boolean] {
    map<any> namesMap = {fname: "Supun", lname: "Setunga", sname: "Kevin", tname: "Ratnasekera"};
    return [namesMap.hasKey("fname"), namesMap.remove("fname") === "Supun", namesMap.hasKey("fname")];
}

function testRemoveIfHasKeyPositive1() returns boolean {
    map<string> student = {id: "1", name: "Andrew", country: "Sri Lanka", city: "Colombo"};
    string? s = student.removeIfHasKey("city");
    return s is string && s == "Colombo";
}

function testRemoveIfHasKeyNegative1() returns boolean {
    map<string> student = {id: "1", name: "Andrew", country: "Sri Lanka", city: "Colombo"};
    string? s = student.removeIfHasKey("age");
    return s is string && s == "Sri Lanka";
}

function testRemoveIfHasKeyPositive2() returns boolean {
    map<any> student = {id: 1, name: "Andrew", country: "Sri Lanka", city: "Colombo"};
    var s = student.removeIfHasKey("city");
    return s is string && s == "Colombo";
}

function testRemoveIfHasKeyNegative2() returns boolean {
    map<any> student = {id: 1, name: "Andrew", country: "Sri Lanka", city: "Colombo"};
    var s = student.removeIfHasKey("age");
    return s is string && s == "Sri Lanka";
}

function testMapToString() returns string {
    map<map<json>> arr = {};
    typedesc<any> t = typeof arr;
    return t.toString();
}

public function main() {
    io:println(mapAccessTest(100, 5)); // @output 105
    string accessed = testAccessThroughVar();
    io:println("[" + accessed + "]"); // @output [x:a, y:b, z:c, ]
    io:println(accessed == "x:a, y:b, z:c, "); // @output true
    map<any> mapValue = mapReturnTest("Chanaka", "Fernando");
    io:println(mapValue.length()); // @output 3
    io:println(mapValue["fname"]); // @output Chanaka
    io:println(mapValue["lname"]); // @output Fernando
    io:println(mapValue["ChanakaFernando"]); // @output ChanakaFernando
    io:println(testArrayAccessAsIndexOfMapt()); // @output Supun
    io:println(testMapRemoveAll()); // @output 0
    io:println(testHasKeyPositive()); // @output true
    io:println(testHasKeyNegative()); // @output false
    [string, string] values = testGetMapValues();
    io:println(values[0]); // @output Supun
    io:println(values[1]); // @output Colombo
    [boolean, boolean, boolean] removed = testMapRemovePositive();
    io:println(removed[0]); // @output true
    io:println(removed[1]); // @output true
    io:println(removed[2]); // @output false
    io:println(testRemoveIfHasKeyPositive1()); // @output true
    io:println(testRemoveIfHasKeyNegative1()); // @output false
    io:println(testRemoveIfHasKeyPositive2()); // @output true
    io:println(testRemoveIfHasKeyNegative2()); // @output false
    io:println(testMapToString()); // @output typedesc map<map<json>>
}
