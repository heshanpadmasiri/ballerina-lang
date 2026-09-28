public function main() {
    map<anydata|error> result = waitTest14();
}

function waitTest14() returns map<anydata|error> {
    future<string> f4 = @strand{thread:"any"} start concat("foo");
    future<int> f3 = @strand{thread:"any"} start add_panic(50, 100);
    record { int|error i; string|error j;} a = wait {i: f3, j: f4};
    return {i: a.i, j: a.j};
}

function concat(string name) returns string => "hello " + name;
function add_panic(int i, int j) returns int {
    int l = 0;
    while l < 9999999 { l += 1; }
    panic error("err from panic"); // @panic
}
