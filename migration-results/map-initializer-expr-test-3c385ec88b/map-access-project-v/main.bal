import ballerina/io;
import map_init.c.d;

public function main() {
    map<any> m = testMapInitWithPackageVars();
    io:println(m.length()); // @output 2
    io:println(m["name"]); // @output PI
    io:println(m["value"]); // @output 3.14159
}

function testMapInitWithPackageVars() returns map<any> {
    map<any> m = {name: d:PI_NAME, value: d:PI_VALUE};
    return m;
}
