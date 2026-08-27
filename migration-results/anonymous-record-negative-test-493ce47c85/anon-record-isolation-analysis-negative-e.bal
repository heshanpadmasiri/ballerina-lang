function testRecordWithClosureTypeMutabilityNegative() {
    int j = 9;
    string n = "A";
    record {| int i = j; |} _ = {}; // @error
    record {| int i = j; |}[] _ = []; // @error
    [record {| int i = j; |}] _ = []; // @error
    table<record {| int i = j; |}> _ = table []; // @error
    record {| int i = j; record {| string m = n; |} k;|}[] _ = []; // @error // @error
    record {| int i = j; record {| string m = n; |}[] k;|}[] _ = []; // @error // @error
    record {| int i = j; |}|string _ = {}; // @error
    [map<record {| int i = j; |}|record {| string m = n; |}[]>, record {| int i = j; |}...] _ = []; // @error // @error // @error
    map<record {| int i = j; |}> a9; // @error // @error
    stream<record {| int i = j; |}> a10; // @error // @error
    stream<record {| int i = j; |}[]> a11; // @error // @error
    stream<record {| int i = j; |}?> a12; // @error // @error
}

function testRecordWithClosureTypeMutabilityNegative2() {
    int j = 9;
    string n = "A";
    record {| int i = j; |} a1; // @error // @error
    record {| int i = j; |}[] a2; // @error // @error
    [record {| int i = j; |}] a3; // @error // @error
    table<record {| int i = j; |}> a4; // @error // @error
    record {| int i = j; record {| string m = n; |} k;|}[] a5; // @error // @error // @error
    record {| int i = j; record {| string m = n; |}[] k;|}[] a6; // @error // @error // @error
    record {| int i = j; |}|string a7; // @error // @error
    [map<record {| int i = j; |}|record {| string m = n; |}[]>, record {| int i = j; |}...] a8; // @error // @error // @error // @error
    stream<record { int i = j; }> a9; // @error // @error
    stream<record { int i = j; }[]> a10; // @error // @error
    stream<record { int i = j; }?> a11; // @error // @error
}

int x = 12;

function foo() returns record {| int i = x; |}[] { // @error
    panic error("Bad Sad!");
}

type AA record {
    string a;
    int b;
    record {| int i = x; |} c; // @error
};

class BB {
    public string a = "Ballerina";
    record {| int i = x; |} c = {}; // @error
}

function testIntersectionTypeNegative() {
    int j = 9;
    record {| int i = j; |} & readonly a1; // @error // @error
    (record {| int i = j; |} & readonly)[] a2; // @error // @error
    [record {| int i = j; |} & readonly] a3; // @error // @error
    (record {| int i = j; |} & readonly)|string a4; // @error // @error
    map<record {| int i = j; |} & readonly> a5; // @error // @error
    table<record {| int i = j; |} & readonly> a6; // @error // @error
    record {| int i = 1; record {| int x = j; |} & readonly k; |}[] a7; // @error // @error
    record {| int i = 1; (record {| int x = j; |} & readonly)[] j; |}[] a8; // @error // @error
    [map<record {| int i = j; |} & readonly>, record {| int i = j; |} & readonly...] a9; // @error // @error // @error
    stream<record {| int i = j; |} & readonly> a10; // @error // @error
    stream<(record {| int i = j; |} & readonly)[]> a11; // @error // @error
    stream<(record {| int i = j; |} & readonly)?> a12; // @error // @error
}

type CC record {
    string a;
    map<record {| int i = x; |} & readonly> b = {}; // @error
};

type EE object {
    int a;
    map<record {| int i = x; |}> b; // @error
};

function testAnonTypeNegativeScenarios() {
    function (record {| int i = x; |}[]) returns [record {| int i = x; |}] a1; // @error // @error // @error
    error<record {| int i = x; |}> a2; // @error // @error
    typedesc<record {| int i = x; |}> a3; // @error // @error
    typedesc<record {| int i = x; |}[]> a4; // @error // @error
    future<record {| int i = x; |}[]> a5; // @error // @error
    future<record {| int i = 1; record {| int i = x; |} j = {}; |}[]> a6; // @error // @error
    function (record {| int i = x; |}...) a7; // @error // @error
    function (map<record {| int i = x; |}>...) a8; // @error // @error
}
