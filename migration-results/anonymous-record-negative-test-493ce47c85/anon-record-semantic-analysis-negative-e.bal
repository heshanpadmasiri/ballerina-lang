function testAnonClosedRecordNegative1() {
    record {| int i = "foo"; |}[] a1; // @error
    [record {| int i = "foo"; |}] a2; // @error
    record {| int i = "foo"; |}|string a3; // @error
    map<record {| int i = "foo"; |}> a4; // @error
    table<record {| int i = "foo"; |}> a5; // @error
    record {| int i = 1; string j = 2; record {| int x = "foo"; |} k; |}[] a6; // @error // @error
    record {| int i = 1; record {| int x = "foo"; |}[] j; |}[] a7; // @error
    [map<record {| int i = "foo"; |}|map<record {| int i = "foo"; |}[]>>, record {| int j = "foo"; |}...] a8; // @error // @error // @error
    stream<record {| int i = "foo"; |}> a9; // @error
    stream<record {| int i = "foo"; |}[]> a10; // @error
    stream<record {| int i = "foo"; |}?> a11; // @error
}

function testAnonOpenRecordNegative2() {
    record { int i = "foo"; }[] a1; // @error
    [record { int i = "foo"; }] a2; // @error
    record { int i = "foo"; }|string a3; // @error
    map<record { int i = "foo"; }> a4; // @error
    table<record { int i = "foo"; }> a5; // @error
    record {| int i = 1; string j = 2; record { int x = "foo"; } k; |}[] a6; // @error // @error
    record {| int i = 1; record { int x = "foo"; }[] j; |}[] a7; // @error
    stream<record { int i = "foo"; }> a8; // @error
    stream<record { int i = "foo"; }[]> a9; // @error
    stream<record { int i = "foo"; }?> a10; // @error
}

function foo() returns record {| int i = "ABC"; |}[] { // @error
    panic error("Bad Sad!");
}

type AA record {
    string a;
    int b;
    record {| int i = "ABC"; |} c; // @error
};

class BB {
    public string a = "Ballerina";
    record {| int i = "ABC"; |} c = {}; // @error
}

function testIntersectionTypeNegative() {
    record {| int i = "foo"; |} & readonly a1; // @error
    (record {| int i = "foo"; |} & readonly)[] a2; // @error
    [record {| int i = "foo"; |} & readonly] a3; // @error
    (record {| int i = "foo"; |} & readonly)|string a4 = {}; // @error
    map<record {| int i = "foo"; |} & readonly> a5 = {}; // @error
    table<record {| int i = "foo"; |} & readonly> a6; // @error
    record {| int i = 1; record {| int x = "foo"; |} & readonly k; |}[] a7 = []; // @error
    record {| int i = 1; (record {| int x = "foo"; |} & readonly)[] j; |}[] a8; // @error
    [map<record {| int i = "foo"; |} & readonly>, record {| int j = "foo"; |} & readonly...] a9; // @error // @error
    stream<record {| int i = "foo"; |} & readonly> a10; // @error
    stream<(record {| int i = "foo"; |} & readonly)[]> a11; // @error
    stream<(record {| int i = "foo"; |} & readonly)?> a12; // @error
}

type CC record {
    string a;
    map<record {| int i = "foo"; |} & readonly> b = {}; // @error
};

type EE object {
    int a;
    map<record {| int i = "foo"; |}> b; // @error
};

function testAnonTypeNegativeScenarios() {
    function (record {| int i = "ABC"; |}[]) returns [record {| int i = "ABC"; |}] a1; // @error // @error
    error<record {| int i = "ABC"; |}> a2; // @error
    typedesc<record {| int i = "ABC"; |}> a3; // @error
    typedesc<record {| int i = "ABC"; |}[]> a4; // @error
    future<record {| int i = "ABC"; |}[]> a5; // @error
    future<record {| int i = 1; record {| int i = "ABC"; |} j = {}; |}[]> a6; // @error
    function (record {| int i = "ABC"; |}...) a7; // @error
    function (map<record {| int i = "foo"; |}>...) a8; // @error
}
