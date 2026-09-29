import ballerina/io;

string output = "";

function stringConcat(string key, string value) {
    output = output + key + ":" + value + " ";
}

function testMapWithArityOne() returns string {
    map<string> m = {a: "1A", b: "2B", c: "3C", d: "4D"};
    output = "";
    foreach var [_, value] in m.entries() {
        stringConcat("_", value);
    }
    return output;
}

function testMapWithArityTwo() returns string {
    map<string> m = {a: "1A", b: "2B", c: "3C", d: "4D"};
    output = "";
    foreach var [key, value] in m.entries() {
        stringConcat(key, value);
    }
    return output;
}

function testAddWhileIteration() returns string {
    map<string> m = {a: "1A", b: "2B", c: "3C"};
    output = "";
    foreach var [key1, value1] in m.entries() {
        stringConcat(key1, value1);
        m[key1 + key1] = value1 + value1;
        foreach var [key2, value2] in m.entries() {
            stringConcat(key2, value2);
        }
        output += "\n";
    }
    return output;
}

public function main() {
    io:println(testMapWithArityOne()); // @output _:1A _:2B _:3C _:4D 
    io:println(testMapWithArityTwo()); // @output a:1A b:2B c:3C d:4D 
    io:print(testAddWhileIteration()); // @output a:1A a:1A b:2B c:3C aa:1A1A 
                                      // @output b:2B a:1A b:2B c:3C aa:1A1A bb:2B2B 
                                      // @output c:3C a:1A b:2B c:3C aa:1A1A bb:2B2B cc:3C3C 
}
