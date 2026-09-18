class AObj {
    boolean|int i;
    function init(boolean|int i) { self.i = i; }
}

class BObj {
    boolean i;
    function init(boolean i) { self.i = i; }
}

public function main() {
    BObj b = new(true);
    AObj a = b;
    a.i = 10; // @panic
}
