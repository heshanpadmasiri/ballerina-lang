import ballerina/io;

function errorMatchPattern1(error e) returns anydata {
    match e {
        error("Message", x = 200, y = 300, ...var a) => { return a["z"]; }
        error("Message", x = 200, ...var a) => { return a["z"]; }
        error(_) => { return "No match"; }
    }
}

function testErrorMatchPattern1() {
    io:println(errorMatchPattern1(error("Message", x = 200, y = 300, z = 400))); // @output 400
    io:println(errorMatchPattern1(error("Message", x = 200, y = 301, z = 400))); // @output 400
    io:println(errorMatchPattern1(error("Message1"))); // @output No match
}

function errorMatchPattern2(error e) returns anydata {
    match e {
        error(x = 200, y = 300, ...var a) => { return a["z"]; }
        error(x = 200, ...var a) => { return a["z"]; }
        error(_) => { return "No match"; }
    }
}

function testErrorMatchPattern2() {
    io:println(errorMatchPattern2(error("Message", x = 200, y = 300, z = 400))); // @output 400
    io:println(errorMatchPattern2(error("Message", x = 200, y = 301, z = 400))); // @output 400
    io:println(errorMatchPattern2(error("Message1"))); // @output No match
}

function errorMatchPattern3(error e) returns anydata {
    match e {
        error("Message1", error("Message2", c = 200, ...var a)) => { return a["d"]; }
    }
    return "No match";
}

function testErrorMatchPattern3() {
    io:println(errorMatchPattern3(error("Message1", error("Message2", c = 200, d = 300, e = 400)))); // @output 300
    io:println(errorMatchPattern3(error("Message1"))); // @output No match
}

public function main() {
    testErrorMatchPattern1();
    testErrorMatchPattern2();
    testErrorMatchPattern3();
}
