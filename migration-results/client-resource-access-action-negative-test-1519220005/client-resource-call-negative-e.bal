type CustomString string;
type CustomString2 CustomString;

string? stringNilArgument = ();
() nilArgument = ();

CustomString customString = "x";
CustomString2 customString2 = customString;

const int intConstant = 1;
var varInt = 1;
var varBoolean = true;

int[2] integerParameterArray = [1, 2];
string[2] stringParameterArray = ["path1", "path2"];
boolean[2] booleanParameterArray = [true, false];

public function testClientResourceAccessArgumentsError() {
    var successClient = client object {
        resource function get path() returns int { return 1; }
        resource function post path() returns int { return 1; }
        resource function get path/[int a]() returns int { return 1; }
        resource function get path/foo(string name) returns int { return 1; }
        resource function get path/foo2(string name, string address) returns int { return 1; }
        resource function get path/foo3(string name = "abc") returns int { return 1; }
        resource function get path/foo4(string address, string name = "abc") returns int { return 1; }
    };

    int _ = successClient->/path/foo(123); // @error
    int _ = successClient->/path/foo("x", "y"); // @error
    int _ = successClient->/path/foo("x", "y", "z"); // @error
    int _ = successClient->/path/foo(nilArgument); // @error
    int _ = successClient->/path/foo(stringNilArgument); // @error

    int _ = successClient->/path/foo(name = 23); // @error
    int _ = successClient->/path/foo(name = intConstant); // @error
    int _ = successClient->/path/foo(name = varInt); // @error
    int _ = successClient->/path/foo(name = varBoolean); // @error
    int _ = successClient->/path/foo("arg", name = 23); // @error
    int _ = successClient->/path/foo(name = 23, name = 23); // @error // @error
    int _ = successClient->/path/foo(); // @error
    int _ = successClient->/path/foo(b = 23); // @error // @error
    int _ = successClient->/path/foo(customString, name = 23); // @error
    int _ = successClient->/path/foo(customString, customString); // @error
    int _ = successClient->/path/foo(customString, customString, customString); // @error
    int _ = successClient->/path/foo2(address = 23, "name"); // @error // @error // @error
    int _ = successClient->/path/foo2(name = customString, 23); // @error // @error
    int _ = successClient->/path/foo3(name = 23); // @error
    int _ = successClient->/path/foo3("name", name = "name2"); // @error
    int _ = successClient->/path/foo4(name = "name"); // @error
    int _ = successClient->/path/foo4("address", name = intConstant); // @error
    int _ = successClient->/path/foo4("address", customString, "name2"); // @error
    int _ = successClient->/path/foo4(address = customString2, name = "name", key = "key"); // @error
    int _ = successClient->/path.post("a"); // @error
    int _ = successClient->/path.post(customString); // @error
}

public function testAmbiguousResourceAccessError() {
    var successClient = client object {
        resource function get [string pathVar]/path() returns int { return 1; }
        resource function get foo/path() returns int { return 1; }
        resource function get foo2/["Path" pathValue]() returns int { return 1; }
        resource function get foo2/path() returns int { return 1; }
        resource function get foo3/[string ...]() returns int { return 1; }
        resource function get foo3/[string x]/[string y]() returns int { return 1; }
        resource function get foo4/[string ...]() returns int { return 1; }
        resource function get foo4/path() returns int { return 1; }
        resource function get foo5/[int ...]() returns int { return 1; }
        resource function get foo5/[int x]/[int y]() returns int { return 1; }
        resource function get foo6/[boolean ...]() returns int { return 1; }
        resource function get foo6/[boolean x]/[boolean y]() returns int { return 1; }
    };

    int _ = successClient->/foo/path();
    int _ = successClient->/foo2/path();
    int _ = successClient->/foo2/["path"]();
    int _ = successClient->/foo3/a/b(); // @error
    int _ = successClient->/foo3/[...stringParameterArray](); // @error
    int _ = successClient->/foo4/path();
    int _ = successClient->/foo5/[5]/[6](); // @error
    int _ = successClient->/foo5/[...integerParameterArray](); // @error
    int _ = successClient->/foo6/[false]/[true](); // @error
    int _ = successClient->/foo6/[...booleanParameterArray](); // @error
}

public function testResourceCallWithErrorClient() {
    var errorClient = object {
        resource function get path/[string]() returns int { return 1; } // @error
    };
    int _ = errorClient->/path/["a"]; // @error
}
