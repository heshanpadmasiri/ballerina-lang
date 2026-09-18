type ARec record { string|int i; };
type BRec record { int i; };

public function main() {
    BRec b = { i: 120 };
    ARec a = b;
    a.i = "hello"; // @panic
}
