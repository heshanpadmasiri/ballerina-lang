import ballerina/io;

public type Student record {|
    string[] array;
|};

// @args ["--array", "e-fac"]
public function main(*Student student) {
    io:println(student.array[0]); // @output e-fac
}
