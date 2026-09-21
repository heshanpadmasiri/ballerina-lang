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
    F f = new ();
    future<int> iDash = start f.g(); // @error
    future<string> iInvalid = start f.g(0); // @error
    future<int> argInvalid = start f.g("hello"); // @error
    var restSum = start f.k();
    restSum = start f.k("hi"); // @error
}
