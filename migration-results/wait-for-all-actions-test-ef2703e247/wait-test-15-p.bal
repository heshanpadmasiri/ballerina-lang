public function main() {
    map<anydata|error> result = waitTest15();
}

function waitTest15() returns map<anydata|error> {
    future<int> f1 = start add_1(5, 2);
    future<string> f3 = start concat("foo");
    future<boolean> f4 = start status();
    future<int> f2 = start add_panic(10, 12);
    return wait {f1, f2, f3, f4};
}

function add_1(int i, int j) returns int { return i + j; }
function concat(string name) returns string => "hello " + name;
function status() returns boolean => true;
function add_panic(int i, int j) returns int {
    int l = 0;
    while l < 9999999 { l += 1; }
    panic error("err from panic"); // @panic
}
