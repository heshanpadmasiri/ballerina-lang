public function main() {
    foo();
}

function foo() returns never {
    error e = error("Bad Sad!!"); // @panic
    panic e;
}
