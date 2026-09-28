public function main() {
    fourthRec result = waitTest13();
}

function waitTest13() returns fourthRec {
    future<int> f1 = @strand{thread:"any"} start add_panic(20, 66);
    return wait {id: f1};
}

type fourthRec record { int|string|error id = 0; };

function add_panic(int i, int j) returns int {
    int l = 0;
    while l < 9999999 { l += 1; }
    panic error("err from panic"); // @panic
}
