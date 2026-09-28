import ballerina/io;

// @args ["2", "John"]
public function main(int value, string name = "Riyafa") {
    io:println(name); // @output John
}
