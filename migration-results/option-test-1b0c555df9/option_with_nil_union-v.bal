import ballerina/io;

public type Student record {|
    string? union;
|};

// @args ["--union=hello"]
public function main(*Student student) {
    io:println(student["union"]); // @output hello
}
