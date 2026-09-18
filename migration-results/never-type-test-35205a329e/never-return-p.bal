public function main() {
    functionWithNeverReturnType();
}
function functionWithNeverReturnType() returns never {
    panic error("Panic occured in function with never return"); // @panic
}
