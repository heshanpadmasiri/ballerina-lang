function waitTest8() returns int {
    future<int> f1 = @strand {thread: "any"} start addPanic(5, 2);
    int result = checkpanic wait f1;
    return result;
}

function addPanic(int i, int j) returns int {
    int k = i + j;
    int l = 0;
    while l < 8888888 {
        l += 1;
    }
    if 0 < 1 {
        error err = error("err from panic"); // @panic
        panic err;
    }
    return k;
}

public function main() {
    int _ = waitTest8();
}
