import ballerina/io;

// @args ["1"]
public function main(int value, string name = "Riyafa") {
    io:println(name); // @output Riyafa
}
