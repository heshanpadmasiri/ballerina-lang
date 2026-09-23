public function foo() returns boolean {
    while 0 > 1 {
        return true;
    }
} // @error

public function bar() returns int {
    int[] i = [];

    foreach var item in i {
        return item;
    }
} // @error
