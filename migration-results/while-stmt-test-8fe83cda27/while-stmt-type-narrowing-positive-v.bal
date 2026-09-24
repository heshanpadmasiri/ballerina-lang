import ballerina/io;

function testWhileStmtTypeNarrow() returns true {
    test1("s");
    test2("s");
    test3();
    return true;
}

function test1(int|string? x) {
    while x != () {
        if x is int {
            int _ = x;
        } else {
            string _ = x;
        }
        break;
    }
    while x != () {
        if x is int {
            int _ = x;
            return;
        }
        string _ = x;
        break;
    }
    if x is int? {
        while x != () {
            int _ = x;
            break;
        }
    }
    if x !is int? {
        string _ = x;
    } else {
        int? _ = x;
        while x != () {
            int _ = x;
            break;
        }
    }
}

function test2(string|2|true? x) {
    while x !is () {
        while x != true {
            while !(x == 2) {
                string _ = x;
                break;
            }
            break;
        }
        break;
    }
}

function test3() {
    int|boolean|string x = "x";
    while x !is int {
        do {
            if x is boolean {
                return;
            }
            string _ = x;
        }
        break;
    }
    int|boolean|string y = "y";
    while y !is int {
        {
            if y is boolean {
                return;
            }
            string _ = y;
        }
        break;
    }
}

public function main() {
    io:println(testWhileStmtTypeNarrow()); // @output true
}
