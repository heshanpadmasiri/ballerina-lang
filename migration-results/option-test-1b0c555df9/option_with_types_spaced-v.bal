import ballerina/io;

public type Student record {|
    string? union;
    string name;
    int age;
    float score;
    decimal value;
|};

// @args ["--union", "e-fac", "--name", "Riyafa", "--age", "25", "--score", "99.99", "--value", "1e10"]
public function main(*Student student) {
    io:println(student["union"]); // @output e-fac
    io:println(student["name"]); // @output Riyafa
    io:println(student["age"]); // @output 25
    io:println(student["score"]); // @output 99.99
    io:println(student["value"]); // @output 1E+10
}
