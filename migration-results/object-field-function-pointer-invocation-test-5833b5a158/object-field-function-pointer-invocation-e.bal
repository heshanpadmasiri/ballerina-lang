class F {
    function () returns int f = function() returns int => 1;
    function (int) returns int g = function(int i) returns int => i;
    function (int...) returns int k = function(int... r) returns int {
        return r[0];
    };
}

function (int) fk = function(int i) {
};

function extraArg() {
    int i = (new F()).f(1); // too many arguments in call to 'f()' // @error
    F f = new ();
    int iDash = f.g(); // missing required parameter '' in call to 'g()' // @error
    string iInvalid = f.g(0); // incompatible types: expected 'string', found 'int' // @error
    int argInvalid = f.g("hello"); // incompatible types: expected 'int', found 'string' // @error
    int restSum = f.k();
    restSum = f.k("hi"); // incompatible types: expected 'int', found 'string' // @error
}
