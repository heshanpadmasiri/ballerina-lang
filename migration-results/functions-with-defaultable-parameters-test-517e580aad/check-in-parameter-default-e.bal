isolated function intOrError() returns int|error => error("err!");

function f1(int a = check intOrError()) returns int => a; // @error

function f2(any a = function (int intResult = check intOrError()) returns int|error { // @error
    return intResult + 1;
}) returns any => a;

function (int a = check intOrError()) returns int f3 = a => a; // @error

function f4() returns error? {
    var _ = function (int a = check intOrError()) returns int => a; // @error

    function (string, int, int) _ =
        function (string s, int i = check intOrError(), int j = i + check intOrError()) { // @error @error
        };

    record {|
        function fn = function (int v = check intOrError()) {}; // @error
    |} _ = {};

    function (int a = check intOrError()) returns int _ = a => a; // @error
}

type Foo record {|
    function fm = function (int v = check intOrError()) {}; // @error
    function fn = function (int v = check intOrError(), record {| int x = check intOrError(); |} u = {}) {}; // @error @error
|};

class Bar {
    function fn = function (int v = check intOrError(), int[] w = [12, check intOrError()]) {}; // @error @error
}

isolated function intFunc() returns int => 1;

function f5(int a = check intFunc()) returns int => a; // @error @error
