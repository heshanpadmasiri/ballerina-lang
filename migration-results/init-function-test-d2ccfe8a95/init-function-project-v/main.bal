import ballerina/io;
import testorg/init_function_project.c_d;

int i = 10;

int? iFromInit = ();
string? sFromInit = ();

function init() {
    iFromInit = i + 100;
    sFromInit = c_d:getS();
}

function testedMain() returns error? {
    return error("errorCode", i = iFromInit, s = sFromInit);
}

public function main() {
    error? result = testedMain();
    if result is error {
        io:println(result.message()); // @output errorCode
        io:println(result.detail()["i"]); // @output 110
        io:println(result.detail()["s"]); // @output hello world
    }
}
