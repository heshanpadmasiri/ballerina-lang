int i; // @error
string s; // @error
int a; // @error
int b; // @error

annotation map<int> Foo on function;

@Foo {
    i // @error
}
function init() {
}

@Foo {
    i // @error
}
function foo() returns int {
    a = 8;
    return 8;
}

function testModuleVarDeclNegative() {
    int _ = a; // @error
    string _ = s; // @error
}

(function() returns string) func1; // @error

function(int a, string b) returns string func2; // @error

function(int, string) returns string func3; // @error

(function() returns string)? func4; // @error

function(int) func5; // @error

function func6; // @error
