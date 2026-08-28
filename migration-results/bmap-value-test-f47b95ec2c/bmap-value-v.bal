import ballerina/io;

public function main() {
    map<any> bmap = {};
    bmap["Chanaka"] = 1;
    bmap["Udaya"] = 2;
    bmap["Chanaka"] = 1;
    io:println(bmap["Chanaka"]); // @output 1
    foreach int i in 0 ..< 100 {
        bmap[i.toString()] = i;
    }
    io:println(bmap.length()); // @output 102
    io:println(bmap["51"]); // @output 51
    ignore(bmap.removeIfHasKey("Chanaka"));
    io:println(bmap.length()); // @output 101
    ignore(bmap.removeIfHasKey("Chanaka"));
    io:println(bmap.length()); // @output 101

    map<any> clearMap = {"IS": 0, "ESB": 1, "APIM": 2};
    io:println(clearMap.length()); // @output 3
    clearMap.removeAll();
    io:println(clearMap.length()); // @output 0

    map<any> hasKeyMap = {"IS": 0, "ESB": 1, "APIM": 2};
    io:println(hasKeyMap.hasKey("IS")); // @output true
    io:println(hasKeyMap.hasKey("ESB")); // @output true
    io:println(hasKeyMap.hasKey("APIM")); // @output true

    map<any> stringMap = {
        "key1": 1,
        "key2": "foo",
        "key3": xml `<bar>hello</bar>`
    };
    io:println(stringMap.toString()); // @output {"key1":1,"key2":"foo","key3":`<bar>hello</bar>`}

    testUpdateMapValue();
    io:println(testMapWithAny()); // @output Lion
    io:println(testMapWithMap()); // @output item1
    io:println(testMapWithAnyValue()); // @output 5
    io:println(testMapWithAnyDifferentValue()); // @output aString
    io:println(testMapWithBinaryExpression()); // @output 3
    io:println(testMapWithFunctionInvocations()); // @output item1
    io:println(testMapWithAnyFunctionInvocations()); // @output item2

    map<any> orderedMap = testMapOrder();
    string[] keys = orderedMap.keys();
    io:println(<string> orderedMap[keys[0]]); // @output Element 1
    io:println(<string> orderedMap[keys[1]]); // @output Element 2
    io:println(<string> orderedMap[keys[2]]); // @output Element 3
    io:println(orderedMap.toString()); // @output {"key1":"Element 1","key2":"Element 2","key3":"Element 3"}

    io:println(testMapStringRepresentation().toString()); // @output {"key1":"Element 1","key2":"Element 2","key3":null}

    map<any> bmapOrder = {"Entry1": "foo", "Entry2": "bar", "Entry3": "foobar"};
    string[] bmapKeys = bmapOrder.keys();
    io:println(<string> bmapOrder[bmapKeys[0]]); // @output foo
    io:println(<string> bmapOrder[bmapKeys[1]]); // @output bar
    io:println(<string> bmapOrder[bmapKeys[2]]); // @output foobar
}

function testMapWithAny() returns string {
    map<any> animals;
    animals = {"animal1":"Lion", "animal2":"Cat", "animal3":"Leopard", "animal4":"Dog"};
    any animal = animals["animal1"];
    string animalString = <string> animal;
    return animalString;
}

function testMapWithMap() returns string {
    map<any> list1 = {"item1":"item1", "item2":"item2", "item3":"item3", "item4":"item4"};
    map<any> list2 = list1;
    string list2String = <string> list2["item1"];
    return list2String;
}

function testMapWithAnyValue() returns int {
    map<any> list1 = {"item1": 1, "item2": 2, "item3": 3, "item4": 4};
    any value = 5;
    list1["item5"] = value;
    var intVal = <int> list1["item5"];
    return intVal;
}

function testMapWithAnyDifferentValue() returns any {
    map<any> list1 = {"item1": 1, "item2": 2, "item3": 3, "item4": 4};
    any value = "aString";
    list1["item5"] = value;
    return list1["item5"];
}

function testMapWithBinaryExpression() returns int {
    map<any> list1 = {"item1": 1, "item2": 2, "item3": 3, "item4": 4};
    int intItem1 = <int> list1["item1"];
    int intItem2 = <int> list1["item2"];
    int value = intItem1 + intItem2;
    return value;
}

function testMapWithFunctionInvocations() returns string {
    map<any> list1 = {"list1":"item1", "item2":"item2", "item3":"item3", "item4":"item4"};
    string list1String = <string> list1["list1"];
    string value = testEcho(list1String);
    return value;
}

function testMapWithAnyFunctionInvocations() returns string {
    map<any> list1 = {"list1":"item1", "item2":"item2", "item3":"item3", "item4":"item4"};
    string value = testEchoAny(list1["item2"]);
    return value;
}

function testMapOrder() returns map<any> {
    map<any> m = {};
    m["key1"] = "Element 1";
    m["key2"] = "Element 2";
    m["key3"] = "Element 3";
    return m;
}

function testMapStringRepresentation() returns map<any> {
    map<any> m = {};
    m["key1"] = "Element 1";
    m["key2"] = "Element 2";
    m["key3"] = ();
    return m;
}

function testEcho(string value) returns string {
    return value;
}

function testEchoAny(any value) returns string {
    string stringVal = <string> value;
    return stringVal;
}

public type Animals Map;

public type Map map<string>;

function testUpdateMapValue() {
    Map x = {};
    x["value"] = "animals";
    assertEquality({"value": "animals"}, x);

    Animals animals = {};
    foreach var [name, age] in [["animal1", "Cat"], ["animal2", "Dog"]] {
        animals[name] = age;
    }
    assertEquality({"animal1": "Cat", "animal2": "Dog"}, animals);
}

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    panic error("AssertionError", message = "expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

function ignore(any? value) {
}
