import ballerina/io;

public function main() {
    io:println(scopeIfValue(5, 10, 20)); // @output 6
    io:println(scopeIfValue(13, 8, 7)); // @output 7
    io:println(scopeIfValue(25, 30, 8)); // @output 100000

    io:println(scopeWhileScope(5, 10, 20)); // @output 5
    io:println(scopeWhileScope(13, 8, 7)); // @output 105
    io:println(scopeWhileScope(40, 30, 8)); // @output 205
    io:println(scopeWhileScope(40, 30, 50)); // @output 305
}

function scopeIfValue(int a, int b, int c) returns int {
    int k = 0;
    if a > b {
        k = k + c;
    } else {
        k = 1;
        if c > b {
            k = k + a;
        } else {
            k = k + 99999;
        }
    }

    return k;
}

function scopeWhileScope(int a, int b, int c) returns int {
    int k = 5;
    int b1 = b;
    while a > b1 {
        b1 = b1 + 1;
        int i = 10;

        if c < a {
            i = i + 10;
        } else {
            i = i + 20;
        }
        k = k + i;
    }
    return k;
}
