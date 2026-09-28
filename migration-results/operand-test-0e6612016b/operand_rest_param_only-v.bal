import ballerina/io;

// @args ["Riyafa", "John"]
public function main(string... s) {
    io:println(s[0]); // @output Riyafa
    io:println(s[1]); // @output John
}
