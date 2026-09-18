class Foo {
    public function init() {
        self.init(); // @panic
    }
}

public function main() {
    Foo foo = new;
}
