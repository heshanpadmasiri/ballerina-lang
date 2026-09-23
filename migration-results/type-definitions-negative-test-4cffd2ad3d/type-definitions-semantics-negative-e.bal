type T1 A[]; // @error

type T2 [B, C]; // @error // @error

type T3 map<D>; // @error

type T4 E; // @error

type T5 record { F f; }; // @error

type T6 object { G g; }; // @error

type T7 int[]|A[]|[B, C]|map<string>|map<D>|E|int|record { F f; }|object { G g; }|error; // @error // @error // @error // @error // @error // @error // @error

type T8 [int[], A[], [B, C], map<string>, map<D>, E, int, record { F f; }, object { G g; }, error]; // @error // @error // @error // @error // @error // @error // @error

type PersonOrInt int|Person; // @error
type PersonOrNil Person?; // @error

type InvalidIntersectionType int & string; // @error

function foo() {
    type MyType int; // @error
}

type CustomType int;

type CustomType record { // @error
    int i = 0;
};

type MyTuple [int, string];

function bar() returns MyTuple => [1, ""];

function testTypeReference() {
    function () returns int x = bar; // @error
}

type Foo boolean|null;

function testNullFiniteType() {
    Foo _ = "null"; // @error
}

class H {};

H res = check new I(); // @error

int[] a = [1, 2, 3, 4, 5];

int[] b = from var i in a select <I> i; // @error

float result = <J>1 + 2.0; // @error

int result2 = true? <J>1 : 2; // @error

var result3 = <H> new J(); // @error
