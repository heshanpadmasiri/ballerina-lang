import ballerina/io;

public function main() {
    map<any> m = testMapInitWithStringTemplateAsKey();
    io:println(m["firstname"]); // @output John
}

function testMapInitWithStringTemplateAsKey() returns map<any> {
    string prefix = "first";
    map<any> m = {[string `${prefix}name`]: "John"};
    return m;
}
