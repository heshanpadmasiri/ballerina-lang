import ballerina/io;

public type INT int;

// @args ["10", "12", "0", "", "0.0", "0", "0"]
public function main(int x, int? y, int a = 3, string s = "abc", float f = 5.5, INT i = 10, int:Signed16 j = 12) {
    io:println(x); // @output 10
    io:println(y); // @output 12
    io:println(a); // @output 0
    io:println(s); // @output
    io:println(f); // @output 0.0
    io:println(i); // @output 0
    io:println(j); // @output 0
}
