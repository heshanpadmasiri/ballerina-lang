type Obj0 distinct object {
    function apply() returns int;
};

type Obj1 distinct object {
    *Obj0;
};

type Obj2 object {
    function apply() returns int;
};

type Foo int|distinct object { };
type Foo2 int|(readonly & distinct object { });
type Foo3 (distinct object { } & readonly)|distinct object { };
type Foo4 distinct object { }|distinct object { }|distinct object { };
type Foo5 distinct object { }|distinct error;

type Bar int|distinct object {
    int i;
};

function f(Obj0 o) {
}

function g(Obj2 o) {
}

function foo() {
    any k = "any-val";
    Obj0 o0 = <Obj0> k;
    Obj1 o1 = <Obj1> k;
    Obj2 o2 = <Obj2> k;

    f(o0);
    f(o1);
    f(o2); // @error

    g(o0);
    g(o1);
    g(o2);
}

public function testDistinctObjectAssignability() {
    object {
        int i;
    } x = object {
        int i = 1;
    };

    Bar _ = x; // @error

    x = object {
        int i = 10;
    };

    Bar _ = x; // @error

    distinct object {
        int i;
    } _ = x; // @error

    distinct object { int i; } y = object { int i = 3; };
    Bar _ = y; // @error
}

public function testDistinctObjectAssignability2() {
    object {} x = object {};
    Foo f1 = x; // @error
    Foo2 f2 = x; // @error
    Foo3 f3 = x; // @error
    Foo4 f4 = x; // @error
    Foo5 f5 = x; // @error

    distinct object { } _ = f1; // @error
    distinct object { } _ = f2; // @error
    distinct object { } _ = f3; // @error
    distinct object { } _ = f4; // @error
    distinct object { } _ = f5; // @error

    f1 = f2; // @error
    f1 = f3; // @error
    f1 = f4; // @error
    f1 = f5; // @error
    f2 = f1; // @error
    f2 = f3; // @error
    f2 = f4; // @error
    f2 = f5; // @error
    f3 = f1; // @error
    f3 = f2; // @error
    f3 = f4; // @error
    f3 = f5; // @error
    f4 = f1; // @error
    f4 = f2; // @error
    f4 = f3; // @error
    f4 = f5; // @error
}
