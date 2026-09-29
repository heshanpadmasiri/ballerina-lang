import ballerina/io;

public function main(string... args) {
    io:println(args[0]); // @output restArg
}

// @args ["restArg"]
