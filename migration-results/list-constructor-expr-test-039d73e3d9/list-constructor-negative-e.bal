type SampleErrorData record {
    string message?;
    error cause?;
    string info;
    boolean fatal;
};

type Person record {|
   int id;
   string name;
|};

type SampleError error<SampleErrorData>;

function testIncompatibleListConstructorExprs1() {
    var [v1, v2, v3] = ["hello", 123, 34.56]; // @error

    SampleError e = error SampleError("Sample Error", info = "Detail Info", fatal = true);
    var [i, error(reason, info = info, fatal = fatal)] = [1, e]; // @error

    Person p = {id:1, name:"ABC"};
    var [j, {id:id, name:name}] = [1, p]; // @error

    [int, int] a = [3, 4];
    var [[k, l], m] = [a, 4]; // @error
}

function testIncompatibleListConstructorExprs2() {
    [NoFillerObject, int] a = []; // @error
    [[int, int], [NoFillerObject, NoFillerObject]] b = []; // @error
}

type NoFillerObject object {
};

function testInvalidAssignmentForInferredTuple() {
    var tup = [
        {id: 123, name: "Anne", city: "Colombo"},
        {id: 456, name: "Jo", age: 40},
        1,
        "abc"
    ];

    [record {|
         int id;
         string name;
         int city;
    |},
    record {}, boolean, string] tup2 = tup; // @error

    record {|
         int id;
         string name;
         string age;
    |} v1 = tup[1]; // @error
    float v2 = tup[2]; // @error
}

function testInferringForReadOnlyNonReadOnlyMemberNegative() {
    int[] arr = [1, 2];

    future<()> ft = start testInferringForReadOnlyNonReadOnlyMemberNegative();

    readonly rd = [1, arr, ft]; // @error // @error
}

function testInferringForReadOnlyNegativeInUnion() {
    map<boolean|int> mp = {
        i: 1,
        b: true
    };

    readonly|int[] rd = [1, mp]; // @error

    boolean[] & readonly arr = [];

    boolean[][]|readonly br = [arr]; // @error
}

function testListConstrWithIssuesInCET() {
    Foo f = ["hello", <string> 1]; // @error // @error
    string[]|Foo g = [<string> 1, "hello"]; // @error // @error
}

function testAmbiguousTypeWithAny() {
    any|any[] _ = [1, 2]; // @error
}
