import ballerina/io;

public type Student record {|
    string[] array;
|};

// @args ["--array=e-fac", "--array=hello"]
public function main(*Student student) {
    io:println(student.array); // @output ["e-fac","hello"]
}
