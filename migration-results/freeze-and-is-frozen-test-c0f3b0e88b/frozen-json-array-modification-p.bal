public function main() {
    json j = {hello: "world "};
    json[] a = [j, "ballerina", 2, 10.3];
    json[] b = a.cloneReadOnly();
    b[8] = j; // @panic
}
