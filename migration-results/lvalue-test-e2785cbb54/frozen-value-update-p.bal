type BRec record { int i; };

public function main() {
    BRec b = { i: 120 };
    BRec b2 = b.cloneReadOnly();
    b2.i = 1; // @panic
}
