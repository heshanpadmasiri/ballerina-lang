type Student record {
    readonly string name;
    int id;
};

function testAssignKeyedTableValueToTableType() {
    table<Student> key(name) tbl1 = table [
        {name: "Amy", id: 1234},
        {name: "John", id: 4567}
    ];
    var a2 = checkpanic table key(id) from var {id} in tbl1 // @error WARNING invalid usage of the 'checkpanic' expression operator: no expression type is equivalent to error type
        select {id};
    table<record {|readonly int id;|}> key(id) a3 = a2;
    var a4 = table key(id) [
        {"id": 1234},
        {"id": 4567}
    ];
    var tbl = table key(id) [
        {"id": 1234},
        {"id": 4567}
    ];
    assertEqual(tbl, a3);
    assertEqual(a3, a4);
}

function assertEqual(any expected, any actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }

    if expected === actual {
        return;
    }

    string expectedValAsString = expected.toString();
    string actualValAsString = actual.toString();
    panic error(string `Assertion error: expected ${expectedValAsString} found ${actualValAsString}`);
}
