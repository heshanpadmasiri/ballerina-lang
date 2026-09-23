import ballerina/io;

public function main() {
    io:println(returnStmtBranch1(12, 13)); // @output 100
    io:println(returnStmtBranch2(9, 10)); // @output 819
}

function returnStmtBranch1(int value, int b) returns int {
    if value > 10 {
        return 100;
    } else if value == 10 {
        return 200;
    } else {
        if b > 10 {
            return 300;
        } else if b == 10 {
            return 400;
        }
        return 500;
    }
}

function returnStmtBranch2(int value, int b) returns int {
    int a = value + b;
    int c = returnStmtBranch1(9, 10);
    c = c + c + a;
    return c;
}
