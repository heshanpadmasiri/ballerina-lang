import ballerina/io;

public function main() {
    io:println(calculateExp1(15, 5)); // @output 9
    io:println(calculateExp1(25, 15)); // @output 10
    io:println(nestedContinueStmt(15, 5)); // @output 666
    io:println(nestedContinueStmt(25, 15)); // @output 2486
}

function calculateExp1(int x, int y) returns int {
    int z = 0;
    int yCopy = y;
    while x > yCopy {
        yCopy += 1;
        if yCopy == 10 {
            continue;
        }
        z += 1;
    }
    return z;
}

function nestedContinueStmt(int x, int y) returns int {
    int z = 0;
    int yCopy = y;
    while x >= yCopy {
        yCopy += 1;
        int i = 0;
        if yCopy == 10 {
            continue;
        }
        while i < yCopy {
            i += 1;
            if i == 10 {
                continue;
            }
            z += i;
        }
    }
    return z;
}
