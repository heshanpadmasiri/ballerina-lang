type Foo record {|
    function a = function () returns error? {
        int _ = check int:fromString("invalid");
        return;
    };
    int b = check int:fromString("invalid"); // @error
    int[]|error c = check f1(); // @error
    string[] d = ["", check f3()]; // @error
|};

type MyError distinct error;

isolated function f1() returns int[]|error => [];

isolated function f2() returns MyError|record {|
        function a = function () returns error? {
            int _ = check int:fromString("invalid");
            record {|
                any x = check f1(); // @error
            |} _ = {};
            return;
        };
        int b = check int:fromString("invalid"); // @error
        int c = 0;
    |} => {};

isolated function f3() returns string|error|MyError => "";

record {|
    any|error a = check f1(); // @error
    record {|
        function a = function () returns error? {
            int _ = check int:fromString("invalid");
            return;
        };
        int b = check int:fromString("invalid"); // @error
        int? c = check trap <int> <any> 1; // @error
    |} b = check f2(); // @error
    string c = check f3(); // @error
|} rec = {a: 1};

isolated function func() {
    record {|
        any|error a = check f1(); // @error
        record {|
            function a = function () returns error? {
                int _ = check int:fromString("invalid");
                return;
            };
            int b = check int:fromString("invalid"); // @error
            int c = check int:fromString(check f3()); // @error // @error
        |} b = check f2(); // @error
        object {} rec2 = object {
            any|error a = check f1(); // @error
        };
    |} _ = {a: 1};
}

type Baz record {
    any a = check new Qux(function () returns error? { // @error
                              int _ = check int:fromString("invalid");
                              return;
                          });
    any b = check new Qux(() => check int:fromString("invalid")); // @error
};

class Qux {
    isolated function init(function () returns int|error? f) returns error? {
        return;
    }
}

isolated function intFunc() returns int => 1;

type Quux record {|
    int i1 = check intFunc(); // @error // @error
    int[] i2 = check f1(); // @error
|};
