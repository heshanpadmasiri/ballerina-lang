import ballerina/io;

type DepartmentLT record {
    string dptName = "";
    PersonLT[] employees = [];
    PersonLT manager = {};
};

type PersonLT record {
    string name = "default first name";
    string lname = "";
    map<any> adrs = {};
    int age = 999;
    PersonLT? child = ();
};

function testStructLiteral1() returns DepartmentLT {
    DepartmentLT p = {};
    return p;
}

function testStructLiteral2() returns PersonLT {
    PersonLT p = {};
    return p;
}

public function main() {
    io:println(testStructLiteral1()); // @output {"dptName":"","employees":[],"manager":{"name":"default first name","lname":"","adrs":{},"age":999,"child":null}}
    io:println(testStructLiteral2()); // @output {"name":"default first name","lname":"","adrs":{},"age":999,"child":null}
}
