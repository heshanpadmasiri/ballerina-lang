import ballerina/io;

public type Student record {|
    string name;
|};

// @args ["--name", "Riyafa", "--", "--Sri Lanka"]
public function main(string birth, *Student student) {
    io:println(student["name"]); // @output Riyafa
}
