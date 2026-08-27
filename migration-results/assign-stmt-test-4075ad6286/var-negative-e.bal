error ex = error("");

function test1() {
    Foo|error k = <Foo> bar; // @error // @error // @error
    if k is Foo { // @error
        string result1 = k + ex;
    } else {
        string result2 = k + ex; // @error
    }
}

function test2() {
    int foo = 10;
    Float|error k = <Float> foo; // @error // @error
    if k is Float { // @error
        string result1 = k + ex;
    } else {
        string result2 = k + ex; // @error
    }
}

function test3() {
    string|error k = <string> foo; // @error
    if k is string {
        string result1 = k + ex; // @error
    } else {
        string result2 = k + ex; // @error
    }
}

function test4() {
    Foo|error k = <Foo> bar; // @error // @error // @error
    if k is Foo { // @error
        string result1 = k + ex;
    } else {
        string result2 = k + ex; // @error
    }
}

function test5() {
    int foo = 10;
    Float|error k = <Float> foo; // @error // @error
    if k is Float { // @error
        string result1 = k + ex;
    } else {
        string result2 = k + ex; // @error
    }
}

function test6() {
    string|error k = <string> foo; // @error
    if k is string {
        string result1 = k + ex; // @error
    } else {
        string result2 = k + ex; // @error
    }
}

function test7() {
    Float|error|() x = <Float> fooo; // @error // @error // @error
}

function test8() {
    float|error|() x = <float>10;
}

function test9() {
    any a = 1;
    string|error|() x = <string>a;
}

function test10() {
    var x = <Foo> bar; // @error // @error
    string result1 = x + ex;
}

function test11() {
    int X = 10;
    X x = 4; // @error
    var V = 1 | 2 | 3 | 4;
    V v = 7; // @error
}
