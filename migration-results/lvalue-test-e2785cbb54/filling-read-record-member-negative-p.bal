type L record { int i; };
type M record { L l?; };

public function main() {
    M m = {};
    m["l"]["i"] = 1; // @panic
}
