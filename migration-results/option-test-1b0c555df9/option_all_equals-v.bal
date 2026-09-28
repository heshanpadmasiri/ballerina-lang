import ballerina/io;

public type Student record {|
    string name;
    boolean good;
    int score;
    float height;
    decimal energy;
    int[] ratings;
    boolean[] friends;
    string? val;
|};

// @args ["--name=Riyafa=Riyafa", "--good", "--score=100", "--height=5.5", "--energy=10e99", "--ratings=5", "--ratings=3", "--friends", "--friends"]
public function main(*Student student) {
    io:println(student.name); // @output Riyafa=Riyafa
    io:println(student.good); // @output true
    io:println(student.score); // @output 100
    io:println(student.height); // @output 5.5
    io:println(student.energy); // @output 1.0E+100
    io:println(student.ratings); // @output [5,3]
    io:println(student.friends); // @output [true,true]
}
