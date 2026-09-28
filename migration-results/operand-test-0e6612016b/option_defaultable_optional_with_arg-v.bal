import ballerina/io;

public type Student record {|
    string name?;
    int? score;
    float height = 5.5;
|};

// @args ["--name=Riyafa", "--score=100", "--height=5.6"]
public function main(*Student student) {
    io:println(student["name"]); // @output Riyafa
    io:println(student.score); // @output 100
    io:println(student.height); // @output 5.6
}
