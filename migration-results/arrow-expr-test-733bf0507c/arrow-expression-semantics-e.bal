function testInvalidUsageOfParamType() returns int {
    function (string) returns int lambda = param1 => param1 / 2; // @error
    return lambda("12");
}

function testInvalidParamType() returns boolean {
    function (boolean) returns boolean lambda = param1 => !param1;
    return lambda("false"); // @error
}

function testInvalidNumberOfParams() {
    function (boolean, string) returns boolean lambda1 = param1 => !param1; // @error
    function (boolean) returns boolean lambda2 = (param1, param2) => !param1; // @error
}

function testInvalidReturnType() {
    function (boolean) returns int lambda1 = param1 => !param1; // @error
}

function testWithUnknownExpectedType() {
    var lambda1 = param1 => !param1; // @error
    any lambda2 = param1 => !param1; // @error
}

function testArrowExprVariableScope() {
    function (boolean) returns boolean lambda1 = param1 => !param1;
    param1 = 12; // @error
}

function testArrowExprVariableScope2() {
    int param1 = 12;
    function (boolean) returns boolean lambda1 = param1 => !param1; // @error
}

function testAccessInvalidClosure() {
    function (boolean) returns boolean lambda1 = param1 => !closureVar; // @error
    boolean closureVar = true;
}

function() foo = function () returns () {
    int i = 34;
    function (int) returns int addFunc1 = a => a + p + m + i; // @error
    int m = 3;
    int k = addFunc1(6);
};

int p = 2;

function testArrowExprWithNoInputs() {
    function () returns string lambda = i => i + p; // @error
}

function testArrowExprWithUninitializedClosureVars() {
    int i;
    int m;
    function (int) returns int addFunc1 = a => a + i + m;
}

function testInvalidBinaryExprInExprFuncBody() {
    _ = ["foo", "bar", "baz"].map(s => s + 1); // @error
    int[] intArr = [1, 2];
    _ = intArr.map(i => "s" + i); // @error
    string[] strArr = [];
    _ = strArr.map(s => 1 + s); // @error
    [int, int] intTup = [1, 2];
    _ = intTup.map(i => "s" + i); // @error
    [string] strTup = ["str"];
    _ = strTup.map(s => 1 + s); // @error
    _ = [].map(m => // @error
        m + 1); // @error
}
