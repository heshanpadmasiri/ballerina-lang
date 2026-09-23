function test1(){
    int; // @error missing identifier

    typedesc<any> x = int;
    typedesc<any> y = int;
    if (x === y) {
        i = 5; // @error undefined symbol 'i'
    }
    typedesc a = byte[]; // @error invalid operation: type 'byte' does not support member access // @error missing key expr in member access expr
    typedesc b = int[]|string[]; // @error invalid operation: type 'int' does not support member access // @error missing key expr in member access expr // @error invalid operation: type 'string' does not support member access // @error missing key expr in member access expr
}

type ImmutableIntArray int[] & readonly;
type IntArray int[];
type Foo "foo";
type FooBar "foo"|1;
type FunctionTypeOne function (int i) returns string;
type FunctionTypeTwo function () returns string;

function testTypeDefReferenceAsTypeDescNegative() {
    typedesc<readonly> a = IntArray; // @error incompatible types: expected 'typedesc<readonly>', found 'typedesc<IntArray>'
    typedesc<string[]|boolean[]> b = ImmutableIntArray; // @error incompatible types: expected 'typedesc<(string[]|boolean[])>', found 'typedesc<ImmutableIntArray>'
    typedesc<string> c = ImmutableIntArray; // @error incompatible types: expected 'typedesc<string>', found 'typedesc<ImmutableIntArray>'
    typedesc<string[]> d = Foo; // @error incompatible types: expected 'typedesc<string[]>', found 'typedesc<Foo>'
    typedesc<string> e = FooBar; // @error incompatible types: expected 'typedesc<string>', found 'typedesc<FooBar>'
    typedesc<string> f = FunctionTypeOne; // @error incompatible types: expected 'typedesc<string>', found 'typedesc<FunctionTypeOne>'
    typedesc<function (int i) returns string> g = FunctionTypeTwo; // @error incompatible types: expected 'typedesc<function (int) returns (string)>', found 'typedesc<FunctionTypeTwo>'
}
