type L record { int i; };

public function main() {
    map<L> m = {};
    m["one"]["i"] = 1; // @panic
}
