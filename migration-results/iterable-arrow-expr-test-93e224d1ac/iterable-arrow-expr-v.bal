import ballerina/io;
import ballerina/lang.'int as ints;

int index = 0;

function testMapIterable() returns map<string> {
    map<string> words = {a: "ant", b: "bear"};
    return words.'map(word => word.toUpperAscii());
}

function testFilterIterable() returns float {
    int[6] numberArray = [5, 6, 7, 8, 9, 10];
    index = 0;
    int[] avg = numberArray.map(function (int num) returns [int, int] {
        [int, int] value = [index, num];
        index += 1;
        return value;
    }).filter(num => num[0] >= 3).map(num => num[1]);
    return (<float>ints:sum(...avg)) / <float>avg.length();
}

function testTwoLevelMapIterable() returns map<string> {
    map<string> words = {a: "ant", b: "bear"};
    return words.map(entry => [entry, entry.toUpperAscii()]).map(entry => entry[1].toUpperAscii());
}

function testTwoLevelMapIterableWithFilter() returns map<string> {
    map<string> words = {a: "ant", b: "bear"};
    return words.map(entry => [entry, entry.toUpperAscii()])
        .filter(entry => entry[0] == "bear")
        .map(entry => entry[1]);
}

function testFilterThenMap() returns [map<string>, int] {
    map<string> words = {a: "ant", b: "bear"};
    map<string> str = words.filter(word => word == "ant").map(word => word[1].toUpperAscii() + " MAN");
    int count = words.filter(word => word == "ant").map(word => word[1].toUpperAscii() + " MAN").length();
    return [str, count];
}

function testFilterWithArityOne() returns map<string> {
    map<string> words = {a: "ant", b: "bear", c: "tiger"};
    return words.map(entry => entry)
        .filter(entry => entry != "bear")
        .map(entry => entry.toUpperAscii());
}

function testIterableReturnLambda() returns map<(function (int) returns boolean)> {
    map<string> words = {a: "ant", b: "bear", c: "tiger"};
    return words.map(function (string input) returns (function (int) returns boolean) {
        return param => true;
    });
}

function testCountFunction() returns any {
    map<any> numbers = {a: "1", b: "2", c: "3"};
    return numbers.map(entry => entry).length();
}

public function main() {
    map<string> mapIterable = testMapIterable();
    io:println(mapIterable["a"]); // @output ANT
    io:println(mapIterable["b"]); // @output BEAR

    io:println(testFilterIterable()); // @output 9.0

    map<string> twoLevelMapIterable = testTwoLevelMapIterable();
    io:println(twoLevelMapIterable["a"]); // @output ANT
    io:println(twoLevelMapIterable["b"]); // @output BEAR

    map<string> twoLevelMapIterableWithFilter = testTwoLevelMapIterableWithFilter();
    io:println(twoLevelMapIterableWithFilter["b"]); // @output BEAR

    [map<string>, int] filterThenMap = testFilterThenMap();
    io:println(filterThenMap[0]); // @output {"a":"N MAN"}
    io:println(filterThenMap[1]); // @output 1

    map<string> filterWithArityOne = testFilterWithArityOne();
    io:println(filterWithArityOne["a"]); // @output ANT
    io:println(filterWithArityOne["c"]); // @output TIGER

    map<(function (int) returns boolean)> iterableReturnLambda = testIterableReturnLambda();
    if iterableReturnLambda["a"] is isolated function (int) returns boolean {
        io:println("isolated function (int) returns (boolean)"); // @output isolated function (int) returns (boolean)
    } else {
        panic error("unexpected function type for a");
    }
    if iterableReturnLambda["b"] is isolated function (int) returns boolean {
        io:println("isolated function (int) returns (boolean)"); // @output isolated function (int) returns (boolean)
    } else {
        panic error("unexpected function type for b");
    }
    if iterableReturnLambda["c"] is isolated function (int) returns boolean {
        io:println("isolated function (int) returns (boolean)"); // @output isolated function (int) returns (boolean)
    } else {
        panic error("unexpected function type for c");
    }

    io:println(testCountFunction()); // @output 3
}
