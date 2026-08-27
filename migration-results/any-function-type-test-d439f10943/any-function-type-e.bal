function bar(int b) returns int {
    return b;
}

isolated function bar2(int b) returns int {
    return b;
}

function baz = bar;

isolated function baz2 = bar2;

function functionWithFunctionReturnType() returns function {
    string a = "hello";
    return a; // @error
}

function testFunctionTypedescWithIsolatedQualifier() {
    isolated function func = bar; // @error
}

function testFunctionTypedescWithTransactionalQualifier() {
    transactional function func; // @error
}

function functionPointerInvocation() {
    function func = bar;
    function (int) returns string val = func(); // @error
    function (int) returns string val2 = func(2, 2, "name"); // @error
}

function testFunctionTypedesc1() {
    function f = (i, j) => i + j; // @error
}

function testFunctionWithNeverOrNeverEqualReturnType() {
    function () returns string x2 = blowUp1; // @error
}

function blowUp1() returns int|never {
    panic error("Error!");
}

function testAnyFunction() {
    var v = <object {function a;}> object {
                function a = 1; // @error
    };
}
