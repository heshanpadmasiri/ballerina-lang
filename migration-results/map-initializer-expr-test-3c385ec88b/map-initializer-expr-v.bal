import ballerina/io;

public function main() {
    map<any> animals = mapInitTest();
    io:println(animals.length()); // @output 4
    io:println(animals["animal1"]); // @output Lion
    io:println(animals["animal2"]); // @output Cat
    io:println(animals["animal4"]); // @output Dog

    map<any> nested = testNestedMapInit();
    map<any> info = <map<any>>nested["info"];
    io:println(info["city"]); // @output Colombo
    io:println(info["country"]); // @output SriLanka

    map<any> jsonMap = testMapInitWithJson();
    io:println(jsonMap["name"]); // @output Supun
    io:println(jsonMap["info"]); // @output {"city":"Colombo","country":"SriLanka"}

    map<any> complex = testComplexMapInit();
    io:println(complex["name"]); // @output Supun
    map<map<any>>[] addresses = <map<map<any>>[]>complex["addressArray"];
    io:println(addresses[0]["address"]["city"]); // @output Colombo
    io:println(addresses[1]["address"]["city"]); // @output Kandy
    io:println(addresses[2]["address"]["city"]); // @output Galle

    map<any> identifiedAnimals = mapInitWithIdentifiersTest();
    io:println(identifiedAnimals.length()); // @output 3
    io:println(identifiedAnimals["a"]); // @output Lion
    io:println(identifiedAnimals["key1"]); // @output Cat
    io:println(identifiedAnimals["key2"]); // @output Dog

    io:println(testEmptyMap().length()); // @output 0
    io:println(testExpressionAsKeys()); // @output true
    io:println(testExpressionAsKeysWithSameKeysDefinedAsLiteralsOrFieldNames()); // @output true
}

function mapInitTest() returns map<any> {
    map<any> animals;
    animals = {"animal1": "Lion", "animal2": "Cat", "animal3": "Leopard", "animal4": "Dog"};
    return animals;
}

function testNestedMapInit() returns map<any> {
    map<map<any>> m = {"info": {"city": "Colombo", "country": "SriLanka"}};
    return m;
}

function testMapInitWithJson() returns map<any> {
    json j = {"city": "Colombo", "country": "SriLanka"};
    map<any> m = {"name": "Supun", "info": j};
    return m;
}

function testComplexMapInit() returns map<any> {
    map<any> address = {city: "CA", "country": "USA"};
    int[] intArray = [7, 8, 9];
    map<map<any>>[] addressArray = [
        {address: {city: "Colombo", "country": "SriLanka"}},
        {address: {city: "Kandy", "country": "SriLanka"}},
        {address: {city: "Galle", "country": "SriLanka"}}
    ];
    map<any> m = {
        name: "Supun",
        age: 25,
        gpa: 2.81,
        status: true,
        info: (),
        address: address,
        intArray: intArray,
        addressArray: addressArray
    };
    return m;
}

function mapInitWithIdentifiersTest() returns map<any> {
    string a = "key1";
    map<any> animals = {a: "Lion", [a]: "Cat", [getKey()]: "Dog"};
    return animals;
}

function getKey() returns string {
    return "key2";
}

function testEmptyMap() returns map<any> {
    map<any> emptyMap = {};
    mapFunction({});
    return emptyMap;
}

function mapFunction(map<any> m) {
}

string iValue = "i";

function testExpressionAsKeys() returns boolean {
    map<anydata> b = {s: "hello", [iValue]: 1, [getChar("f")]: 2.0, [getChar("b")]: true};
    return b["s"] == "hello" && b["i"] == 1 && b["f"] == 2.0 && b["b"] == true;
}

string mapValue = "";

function testExpressionAsKeysWithSameKeysDefinedAsLiteralsOrFieldNames() returns boolean {
    map<string|float> b = {
        f: 1.0,
        [getChar("f")]: 4.0,
        [getChar("s")]: addStringToMapValue(" world"),
        [getChar("s")]: addStringToMapValue(" from Ballerina"),
        s: addStringToMapValue("hello")
    };
    return b["s"] == "hello world from Ballerina" && b["f"] == 4.0;
}

function getChar(string st) returns string {
    return st;
}

function addStringToMapValue(string s) returns string {
    mapValue += s;
    return mapValue;
}
