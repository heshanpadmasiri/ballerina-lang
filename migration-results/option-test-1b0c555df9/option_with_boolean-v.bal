import ballerina/io;

public type Student record {|
    boolean bool;
|};

// @args ["--bool"]
public function main(*Student student) {
    io:println(student["bool"]); // @output true
}
