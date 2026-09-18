public function main() {
    Bar bar = new (12);
    bar.barFunc();
}

class Bar {
    public int val;

    function init(int val) {
        self.val = val;
    }

    function barFunc() returns never {
        error e = error("Bad Sad!!"); // @panic
        panic e;
    }
}
