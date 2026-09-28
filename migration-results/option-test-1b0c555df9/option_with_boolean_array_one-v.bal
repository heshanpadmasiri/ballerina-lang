import ballerina/io;

public type Student record {|
    boolean[] array;
|};

// @args ["--array"]
public function main(*Student student) {
    io:println(student.array[0]); // @output true
}
