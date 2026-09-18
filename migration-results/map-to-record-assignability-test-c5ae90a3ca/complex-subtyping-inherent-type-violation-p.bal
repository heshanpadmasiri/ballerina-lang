type Foo record {|
    int a;
    int...;
|};

type Bar record {|
    int a;
|};

type SuperTypeOfAll record {|
    int...;
|};

map<Bar> gM = {"bb": {a: 10}, "x": {a: 20}};
record {| SuperTypeOfAll x?; Foo...; |} gR = gM;

function testComplexSubtyping2() {
    record {| int c; |} rC = {c: 50};
    gR.x = rC; // @panic
}

public function main() {
    testComplexSubtyping2();
}
