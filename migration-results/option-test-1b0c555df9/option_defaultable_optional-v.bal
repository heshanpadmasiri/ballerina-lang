import ballerina/io;

public type Student record {|
    string name?;
    int? score;
    float height = 5.5;
|};

public function main(*Student student) {
    io:println(student["name"]); // @output
    io:println(student.score); // @output
    io:println(student.height); // @output 5.5
}
