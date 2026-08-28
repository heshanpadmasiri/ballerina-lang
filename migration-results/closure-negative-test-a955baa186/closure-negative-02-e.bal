function testTypeNarrowingWithClosure() {
    string? optionalName = "Ballerina";
    var lambdaFunc = function () {
        if optionalName == "Ballerina" {
            "Ballerina" bal = optionalName; // @error
        }
    };
}

function testTypeNarrowingWithClosure2() returns int|string {
    int|string x = 5;
    var addFunc1 = function () {
        if (x is int && x > 3) { // @error
            x = x + 1; // @error
        } else {
            x = 0;
        }
    };
    return x;
}

function testBasicClosureWithInvalidTypeNarrowing() {
    int|string a = "32";
    var fn = function () {
        int b;
        if a is int {
            b = a; // @error
        }
    };
}

function testMultiLevelClosureWithInvalidTypeNarrowing() {
    int|string a = "32";
    var fn1 = function() {
        int|boolean|error b = 32;
        var fn2 = function(int|string|boolean c) {
            int d;
            if a is int && b is int && c is int {
                d = a + b + c; // @error
            }
        };
    };
}
