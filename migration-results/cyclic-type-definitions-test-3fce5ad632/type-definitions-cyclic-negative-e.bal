type A A; // @error

type B map<B>; // @error

type C D|map<C>|int; // @error
type D C|int;

type E int|record{E a = "";}; // @error

type CyclicDecimal decimal|CyclicDecimal[];
type tupleCyclic [int, tupleCyclic[]];

function testEuqlity() {
    CyclicDecimal x = 1.0;
    boolean bool = x == 1.23f; // @error
    bool = x != 1.23f; // @error
    bool = x === 1.23f; // @error

    tupleCyclic a = [1];
    bool = a == [2]; // @error
    bool = a != [2]; // @error
    bool = a === [2]; // @error
}

type G [G];
type H [int, H];
type I [int, I[]];
type F [int, string, F|int, map<F>];
type Q [Q...];

function testTupleCyclic() {
    int|F values = [1, "hello", [2, "hi"]]; // @error
    I a = [1];
    I b = [a]; // @error
}

type R[int, R[1], v...]; // @error

type P XNil|XUnion1|XAny|XListRef; // @error @error
const XNil = "nil";
const XAny = "any";
type XUnion1 "union"|P;

type S [XNil|S[]|XListRef]; // @error

type J [int, J[2]];
type J [int, map<J>]; // @error

type K string|int|K[];
type K map<K>|string|K[]|int; // @error

type T [XNil, "text1", xInt, L[1]];
const xInt = 1;
type L [int, L[2], T[1]];
type M [int, L[]];

type N [int, N[2]];
type N int|N[]; // @error

function testFillerValueCyclicTuple() {
    M a = [1];
    L b = [1]; // @error
    T c = ["nil"]; // @error
}

type CT record {
    ET i;
};

type DT CT;
type ET DT;

function testCyclicTypeDef() {
      CT t = {
            i : 2 // @error
        };
}

type A1 B1 & readonly; // @error
type B1 stream<A1>;

type A2 table<B2>; // @error
type B2 A2 & readonly;

type A3 map<A3?>; // @error
type MyIntersection2 A3 & readonly;

type MyIntersection3 A4 & readonly;
type A4 map<MyIntersection3>; // @error

type A5 A5[]; // @error
type MyIntersection4 A5 & readonly;

type A6 xml<A6>; // @error
type MyIntersection5 A6 & readonly;

type A7 table<A7>; // @error
type MyIntersection6 A7 & readonly;

type A8 A8[] & readonly; // @error

type A9 map<A9> & readonly; // @error

type A10 future<A10>; // @error

type A11 table<A11> & readonly; // @error

type A12 xml<A12> & readonly; // @error

type A13 typedesc<A13> & readonly; // @error
