import ballerina/io;

function testJSONWithExpressionKey() returns json {
    string a = "key1";
    json j = {a: "Lion", [a]: "Cat", [getKey()]: "Dog"};
    return j;
}

function getKey() returns string {
    return "key2";
}

public function main() {
    io:println(testJSONWithExpressionKey()); // @output {"a":"Lion","key1":"Cat","key2":"Dog"}
}
