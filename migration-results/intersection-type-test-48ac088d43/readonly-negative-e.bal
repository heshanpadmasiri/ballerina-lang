function testInvalidIntersection() {
    var fn = function () returns int { return 1; };
    future<int> & readonly x = start fn(); // @error
}

function testUnsupportedIntersection() {
    json & int x = 1; // @error
}

type IntersectionWithInvalidRecordTypeAfter Bar & readonly; // @error
type Bar record { future<int> ft; };

type IntersectionWithInvalidObjectTypeAfter Baz & readonly; // @error
type Baz object { future<int> ft; };

type X error<record { int i?; }> & error<record { int i; }>;
type Y readonly & record { int i; };
type Z record {
    *Y; // @error
    X x;
    Y y;
};

type ReadonlyType readonly;
type FutureType future<int>;
type T2 FutureType & ReadonlyType; // @error

function testReadonlyIntersectionImmutability() {
    ReadonlyType & string[] arr = ["a", "b", "c"];
    arr.push("d"); // @error
}

type Foo record { string p1; int p2?; };
function testAssigningMutableValuesToReadonlyIntersectionsWithTypeRefForReadonly() {
    int[] numArray = [1, 2, 3, 4];
    ReadonlyType & int[] _ = numArray; // @error
    Foo foo = {p1: "P1"};
    Foo & ReadonlyType _ = foo; // @error
}
