public function main() {
    @strand{thread:"any"} // @error
    worker w1 {
        5 ->> w2;
    }
    @strand{thread:"any"} // @error
    worker w2 {
        string _ = <- w1; // @error
    }
    wait w2;
}
