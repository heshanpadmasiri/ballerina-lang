public function foo() {
    worker w1 {
        "hello" -> w2;
    }
    worker w2 {
        string _ = checkpanic <- w1; // @error
    }
}

public function bar() {
    worker w1 {
        "hello" ->> w2;
    }
    worker w2 {
        string _ = checkpanic <- w1; // @error
    }
}
