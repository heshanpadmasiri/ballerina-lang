import ballerina/io;

int i = 1;

function init() {
    i += 23;
}

function testedMain() returns error? {
    return error("errorCode", i = i);
}

public function main() {
    error? result = testedMain();
    if result is error {
        io:println(result.message()); // @output errorCode
        io:println(result.detail()["i"]); // @output 24
    }
}
