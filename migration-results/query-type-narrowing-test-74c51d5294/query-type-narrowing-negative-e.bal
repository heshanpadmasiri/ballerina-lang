type A record {| int i; |};
type B record {| string i; |};
type AorB A|B;

function bFn(B x) {
}

function testAorB(AorB[] data) {
    _ = from AorB item in data
        where item !is A
        select bFn(item); // @error

    from AorB item in data
    where !(item is A)
    do {
        bFn(item); // @error
    };
}

type D record { int i; };
type E record { string i; };
type F record { string j; };
type DorE D|E;
type DorF D|F;
type EorF E|F;

function eFn(E x) {
}

function fFn(F x) {
}

function testDEF(DorE[] x, DorF[] y, EorF[] z) {
    _ = from var item in x
        where item !is D
        select eFn(item); // @error

    from var item in x
    where item !is D
    do {
        eFn(item); // @error
    };

    _ = from var item in y
        where item !is D
        select fFn(item); // @error

    _ = from var item in z
        where item !is D
        select fFn(item); // @error

    _ = from var item in z
        where item !is E
        select fFn(item); // @error
}

type V record {| int i; |};
type W record {| string s; |};
type Y record {| int s; |};
type Z record {| float f; |};

function yzFn(Y|Z x) {
}

function testVWYZ((V|W|Y|Z)[] data) {
    _ = from var item in data
        where item !is V|W
        select yzFn(item); // @error

    from var item in data
    where item !is V|W
    do {
        yzFn(item); // @error
    };
}

type Q record {| string a; |};
type R record { int b; };
type T record { boolean a; };

function rFn(R x) {
}

function rtFn(R|T x) {
}

function testQRT((Q|R)[] data1, (Q|R|T)[] data2) {
    _ = from var item in data1
        where item !is Q
        select rFn(item); // @error

    from var item in data1
    where item !is Q
    do {
        rFn(item); // @error
    };

    _ = from var item in data2
        where item !is Q
        select rtFn(item); // @error
}

type Integers 1|2|3;

function testLiterals(Integers[] numbers) {
    from Integers item in numbers
    where item == 1 || item == 2
    do {
        1 _ = item; // @error
    };

    int?[] a = [1, 2, 3];
    var _ = from var item in a
        where item == 1
        let () varName = item // @error
        select item;

    from var item in 1 ... 3
    let int? one = 1
    where one == 1
    do {
        2 two = one; // @error
    };
}

public function main() {
}
