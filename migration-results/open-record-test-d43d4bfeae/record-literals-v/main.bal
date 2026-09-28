import ballerina/io;

type Department record {
    string dptName = "";
    Person[] employees = [];
    Person manager = {};
};

type Person record {
    string name = "default first name";
    string lname = "";
    map<any> adrs = {};
    int age = 999;
    Person? child = ();
};

function testStructLiteral1() returns Department {
    return {};
}

function testStructLiteral2() returns Person {
    return {};
}

public function main() {
    io:println(testStructLiteral1()); // @output {"dptName":"","employees":[],"manager":{"name":"default first name","lname":"","adrs":{},"age":999,"child":null}}
    io:println(testStructLiteral2()); // @output {"name":"default first name","lname":"","adrs":{},"age":999,"child":null}
}
