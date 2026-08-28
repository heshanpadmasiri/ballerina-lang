import ballerina/io;

type Employee record {
    int id;
    string name;
    float salary;
};

function testTableGeneration() returns int {
    table<Employee> tbEmployee = table [
        {id: 1, name: "Mary🤒", salary: 300.5},
        {id: 2, name: "John💉", salary: 200.5},
        {id: 3, name: "Jim", salary: 330.5}
    ];
    return tbEmployee.toString().length();
}

type Names record {|
    string country;
    string[] names;
|};

function testTableWithArrayGeneration() returns int {
    string[] names = ["Sam🚜", "John🕔", "Ann"];
    Names val = {country: "Ireland🔀", names: names};
    table<Names> tbNames = table [];
    tbNames.add(val);
    return tbNames.toString().length();
}

public function main() {
    io:println(testTableGeneration()); // @output 116
    io:println(testTableWithArrayGeneration()); // @output 55
}
