import ballerina/io;

type RestrictedGrades record {| int maths = 0; int physics = 0; int chemistry = 0; int...; |};

function mapTo(int grade) returns int => grade + 10;
function filter(int grade) returns boolean => grade > 75;

function testOpChainsWithTerminalOps(int m, int p, int c) returns [int, int, int, int, float] {
    RestrictedGrades grades = {maths: m, physics: p, chemistry: c, "english": 78};
    int count = grades.'map(mapTo).filter(filter).reduce(function (int total, int value) returns int { return total + 1; }, 0);
    int sum = grades.'map(mapTo).filter(filter).reduce(function (int total, int value) returns int { return total + value; }, 0);
    int max = grades.'map(mapTo).filter(filter).reduce(function (int current, int value) returns int { return value > current ? value : current; }, 0);
    int min = grades.'map(mapTo).filter(filter).reduce(function (int current, int value) returns int { return value < current ? value : current; }, 100000);
    int length = grades.'map(mapTo).filter(filter).length();
    float average = grades.'map(mapTo).filter(filter).reduce(function (float total, int value) returns float {
        return total + <float>value / <float>length;
    }, 0.0);
    return [count, sum, max, min, average];
}

// @args ["80", "76", "65"]
public function main(int m, int p, int c) {
    var terminal = testOpChainsWithTerminalOps(m, p, c);
    io:println(terminal[0]); // @output 3
    io:println(terminal[1]); // @output 264
    io:println(terminal[2]); // @output 90
    io:println(terminal[3]); // @output 86
    io:println(terminal[4]); // @output 88.0
}
