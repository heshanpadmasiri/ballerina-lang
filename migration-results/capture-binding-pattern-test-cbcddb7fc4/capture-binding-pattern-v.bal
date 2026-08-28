function captureBindingPattern1(any v) returns string {
    match v {
        var _ => {
            return "Matched";
        }
    }
}

function testCaptureBindingPattern1() {
    assertEquals(captureBindingPattern1(2), "Matched");
    assertEquals(captureBindingPattern1("str"), "Matched");
    assertEquals(captureBindingPattern1(true), "Matched");
}

function captureBindingPattern2(any v) returns anydata {
    match v {
        var a if a is int => {
            return a;
        }
        var a if a is string => {
            return a;
        }
        var a if a is boolean => {
            return a;
        }
    }

    return "Not matched.";
}

function testCaptureBindingPattern2() {
    assertEquals(captureBindingPattern2(2), 2);
    assertEquals(captureBindingPattern2("str"), "str");
    assertEquals(captureBindingPattern2(true), true);
    assertEquals(captureBindingPattern2([]), "Not matched.");
}

function captureBindingPattern3(any v) returns string {
    match v {
        var a if a is int && a == 2 => {
            return "a == 2";
        }
        var a if a is string && a == "str" => {
            return "a == str";
        }
        var a if a is boolean && a == true => {
            return "a == true";
        }
    }

    return "Not matched.";
}

function testCaptureBindingPattern3() {
    assertEquals(captureBindingPattern3(2), "a == 2");
    assertEquals(captureBindingPattern3("str"), "a == str");
    assertEquals(captureBindingPattern3(true), "a == true");
    assertEquals(captureBindingPattern3("Not matched"), "Not matched.");
}

function captureBindingPattern4(int v) returns string {
    string s = "";

    match v {
        1 => {
            s += "ONE";
        }
        2 => {
            s += "TWO";
        }
        3 => {
            s += "THREE";
        }
        var _ => {
            s += "OTHER";
        }
    }
    return s;
}

function testCaptureBindingPattern4() {
    assertEquals("ONE", captureBindingPattern4(1));
    assertEquals("TWO", captureBindingPattern4(2));
    assertEquals("THREE", captureBindingPattern4(3));
    assertEquals("OTHER", captureBindingPattern4(4));
}

type A [int, string] & readonly;
type B map<int> & readonly;
type T A|B;

function captureBindingPattern5(T v) returns string {
    string s = "No match";

    match v {
        var [a, b] => {
            A c = [a, b];
            s = c.toString();
        }
        var {a: x, b: y} => {
            B c = {a: x, b: y};
            s = c.toString();
        }
    }
    return s;
}

function testCaptureBindingPattern5() {
    assertEquals("[1,\"a\"]", captureBindingPattern5([1, "a"]));
    assertEquals("{\"a\":1,\"b\":2}", captureBindingPattern5({a: 1, b: 2}));
    assertEquals("No match", captureBindingPattern5({b: 3}));
}

function captureBindingPattern6(int|boolean a) returns string {
    match a {
        var x if a is int|string => {
            return x.toString();
        }
        var y if a is int|int[] => {
            return y.toString();
        }
        _ => {
            return "no match";
        }
    }
}

function testCaptureBindingPattern6() {
    assertEquals(captureBindingPattern6(23), "23");
    assertEquals(captureBindingPattern6(true), "no match");
}

function captureBindingPattern7(int|float|boolean a) returns string {
    match a {
        var x if a is int|float|string => {
            return x.toString();
        }
        var y if a is int|int[] => {
            return y.toString();
        }
        _ => {
            return "no match";
        }
    }
}

function testCaptureBindingPattern7() {
    assertEquals(captureBindingPattern7(1.2f), "1.2");
    assertEquals(captureBindingPattern7(22), "22");
    assertEquals(captureBindingPattern7(true), "no match");
}

function assertEquals(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }

    panic error("expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

public function main() {
    testCaptureBindingPattern1();
    testCaptureBindingPattern2();
    testCaptureBindingPattern3();
    testCaptureBindingPattern4();
    testCaptureBindingPattern5();
    testCaptureBindingPattern6();
    testCaptureBindingPattern7();
}
