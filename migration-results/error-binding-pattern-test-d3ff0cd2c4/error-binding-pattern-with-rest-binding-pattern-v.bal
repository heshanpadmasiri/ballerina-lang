import ballerina/io;

function errorBindingPattern1(error e) returns anydata {
    match e {
        var error(a, x = b, y = c, ...d) => {
            return d["z"];
        }
        var error(a, x = b, ...c) => {
            return c["z"];
        }
        var error(_) => {
            return "No match";
        }
    }
}

function testErrorBindingPattern1() {
    assertEquals(400, errorBindingPattern1(error("Message", x = 200, y = 300, z = 400)));
    assertEquals(400, errorBindingPattern1(error("Message", x = 200, y = 301, z = 400)));
}

function errorBindingPattern2(error e) returns anydata {
    match e {
        var error(x = a, y = b, ...c) => {
            return c["z"];
        }
        var error(x = a, ...b) => {
            return b["z"];
        }
        var error(_) => {
            return "No match";
        }
    }
}

function testErrorBindingPattern2() {
    assertEquals(400, errorBindingPattern2(error("Message", x = 200, y = 300, z = 400)));
    assertEquals(401, errorBindingPattern2(error("Message", x = 203, z = 401)));
}

function errorBindingPattern3(error e) returns anydata {
    match e {
        var error(a, error(b, c = d, ...x)) => {
            return x["d"];
        }
    }
    return "No match";
}

function testErrorBindingPattern3() {
    assertEquals(300, errorBindingPattern3(error("Message1", error("Message2", c = 200, d = 300, e = 400))));
    assertEquals("No match", errorBindingPattern3(error("Message1")));
}

function assertEquals(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    panic error("expected '" + expected.toString() + "', found '" + actual.toString () + "'");
}

function keepIo(function(anydata...) printer) {
}

public function main() {
    keepIo(io:println);
    testErrorBindingPattern1();
    testErrorBindingPattern2();
    testErrorBindingPattern3();
}
