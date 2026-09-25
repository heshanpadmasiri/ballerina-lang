public function main() {
    map<anydata> m1 = {one: "1", two: 2};
    map<anydata> m2 = m1.cloneReadOnly();
    m2.removeAll(); // @panic
}
