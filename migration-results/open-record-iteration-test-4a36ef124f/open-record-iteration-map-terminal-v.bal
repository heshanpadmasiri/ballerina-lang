import ballerina/io;

type RestrictedGrades record {| int maths = 0; int physics = 0; int chemistry = 0; int...; |};

function testMapWithAllIntOpenRecord(int m, int p, int c, int e) returns map<int> {
    RestrictedGrades grades = {maths: m, physics: p, chemistry: c, "english": e};
    return grades.'map(function (int grade) returns int { return grade + 10; });
}

function testTerminalOpsOnAllIntOpenRecord(int m, int p, int c, int e) returns [int, int, int, int, float] {
    RestrictedGrades grades = {maths: m, physics: p, chemistry: c, "english": e};
    int count = grades.reduce(function (int total, int value) returns int { return total + 1; }, 0);
    int max = grades.reduce(function (int current, int value) returns int { return value > current ? value : current; }, 0);
    int min = grades.reduce(function (int current, int value) returns int { return value < current ? value : current; }, 1000000);
    int sum = grades.reduce(function (int total, int value) returns int { return total + value; }, 0);
    float average = grades.reduce(function (float total, int value) returns float {
        return total + <float>value / <float>grades.length();
    }, 0.0);
    return [count, max, min, sum, average];
}

// @args ["80", "75", "65", "78"]
public function main(int m, int p, int c, int e) {
    map<int> intMap = testMapWithAllIntOpenRecord(m, p, c, e);
    io:println(intMap["maths"]); // @output 90
    io:println(intMap["physics"]); // @output 85
    io:println(intMap["chemistry"]); // @output 75
    io:println(intMap["english"]); // @output 88
    var terminal = testTerminalOpsOnAllIntOpenRecord(m, p, c, e);
    io:println(terminal[0]); // @output 4
    io:println(terminal[1]); // @output 80
    io:println(terminal[2]); // @output 65
    io:println(terminal[3]); // @output 298
    io:println(terminal[4]); // @output 74.5
}
