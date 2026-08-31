final int PI = 3.14989; // @error

final float floatVariableEx = "not a float"; // @error

final int intVariableEx = "not an int"; // @error

const int CONST1 = 3 + 5;
type A CONST1;
const A CONST2 = 3; // @error

function testAssignInvalidValue() {
    A a = 3; // @error
    CONST1 c = 4; // @error
}

const map<string> X = {a: "a"};

type Foo record {|
   X x;
   int i;
|};

const Foo F1 = {x: {b : "a"}, i: 1, c: 2}; // @error @error
const record{|X x; int i;|} F2 = {x: {b : "a"}, i: 1, c: 2}; // @error @error

const X F3 = {b : "b"}; // @error

const string[] Y = base16 `aabb`; // @error

const [string, int] Z =  base16 `aabb`; // @error

const [170] Z1 =  base16 `aabb`; // @error
