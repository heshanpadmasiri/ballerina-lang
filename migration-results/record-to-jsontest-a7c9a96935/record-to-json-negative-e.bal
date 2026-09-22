function testNegatives() {
    record {
        string name;
    } person = {name: "John"};

    json j1 = person; // @error

    record {|
        map<any> m;
    |} r1 = {m: {}};

    json j2 = r1; // @error

    record {|
        string name = "";
        record {|
            record {|
                int x = 10;
                any y = ();
            |} nestedL2 = {};
        |} nestedL1 = {};
    |} r2 = {};

    json j3 = r2; // @error

    record {|
        string name = "";
        record {|
            record {|
                int x = 10;
                (int|string|typedesc<any>)...;
            |} nestedL2 = {};
        |} nestedL1 = {};
    |} r3 = {};

    json j4 = r3; // @error
}

type Bar record {|
    int i;
    Bar? b = ();
    anydata x;
|};

function testNegativeWithRecursiveCheckAgainstJson() {
    Bar b = {i: 1, x: 2};
    json j = b; // @error
}
