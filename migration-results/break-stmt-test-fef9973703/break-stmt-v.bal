import ballerina/io;

function calculateExp1(int x, int y) returns int {
    int z = 0;
    int yCopy = y;
    while x >= yCopy {
        yCopy = yCopy + 1;
        if yCopy == 10 {
            z = 100;
            break;
        } else if yCopy > 20 {
            z = 1000;
            break;
        }
        z = z + 10;
    }
    return z;
}

function nestedBreakStmt(int x, int y) returns int {
    int z = 10;
    int yCopy = y;
    while x >= yCopy {
        yCopy = yCopy + 1;
        if yCopy >= 10 {
            z = z + 100;
            break;
        }
        z = z + 10;
        while yCopy < x {
            z = z + 10;
            yCopy = yCopy + 1;
            if z >= 40 {
                break;
            }
        }
    }
    return z;
}

string output = "";

function tracePath(string path) {
    output = output + "->" + path;
}

function testBreakWithForeach(string command) returns string {
    output = "start";
    foreach var i in 0 ... 5 {
        tracePath("foreach" + i.toString());
        if i == 3 && command == "break" {
            tracePath("break");
            break;
        }
        tracePath("foreachEnd" + i.toString());
    }
    tracePath("end");
    return output;
}

public function main() {
    io:println(calculateExp1(15, 5)); // @output 100
    io:println(calculateExp1(25, 15)); // @output 1000
    io:println(calculateExp1(8, 5)); // @output 40
    io:println(nestedBreakStmt(12, 8)); // @output 140
    io:println(testBreakWithForeach("break")); // @output start->foreach0->foreachEnd0->foreach1->foreachEnd1->foreach2->foreachEnd2->foreach3->break->end
}
