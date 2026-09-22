function testOpenRecordAssignabilityNegative() {
    record {int|string|boolean a; int|boolean b;} r1 = {a: 1, b: true};
    record {int|string|boolean a; int|string b;} r2 = r1; // @error
    record {int|string|boolean a; int|string b;} _ = r1; // @error

    boolean|string|int|record {boolean|string b;} r3 = {b : true};
    boolean|string|int|record {boolean|int b;} r4 = r3; // @error
    boolean|string|int|record {boolean|int b;} _ = r3; // @error
}

function testClosedRecordAssignabilityNegative() {
    record {|int|string|boolean a; int|boolean b;|} r1 = {a: 1, b: true};
    record {|int|string|boolean a; int|string b;|} r2 = r1; // @error
    record {|int|string|boolean a; int|string b;|} _ = r1; // @error

    record {|int|string|boolean a; int|boolean...;|} r3 = {a: 1, "c": true};
    record {|int|string|boolean a; int|string...;|} r4 = r3; // @error
    record {|int|string|boolean a; int|string...;|} _ = r3; // @error

    record {|int|string|boolean a; int|boolean b; int|boolean...;|} r5 = {a: 1, b: true, "c": true};
    record {|int|string|boolean a; int|string b; int|string...;|} r6 = r5; // @error
    record {|int|string|boolean a; int|string b; int|string...;|} _ = r5; // @error

    boolean|string|int|record {|boolean|string b;|} r7 = {b : true};
    boolean|string|int|record {|boolean|int b;|} r8 = r7; // @error
    boolean|string|int|record {|boolean|int b;|} _ = r7; // @error
}

type R1 record {
    string y?;
};

type R2 record {
    int x?;
};

type R3 record {|
    string y?;
    int...;
|};

function testOpenRecordToRecordWithIncompatibleOptionalFieldTyping() {
    R2 r1 = {x: 1, "y": 10};
    R1 _ = r1; // @error

    record {|int|string...;|} r2 = {};
    R1 _ = r2; // @error

    record {|int...;|} r3 = {};
    R1 _ = r3; // @error
    R3 _ = r3; // @error

    record {|readonly int? b; int...;|} r4 = {b: 1};
    record {int a?; int b;} _ = r4; // @error
}
