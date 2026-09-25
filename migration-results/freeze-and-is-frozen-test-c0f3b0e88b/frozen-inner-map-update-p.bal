public function main() {
    map<anydata> m1 = {one: "1", two: 2};
    map<anydata> m2 = {one: "21", two: 22, mapVal: m1};
    map<anydata> m3 = m2.cloneReadOnly();
    m3["one"] = 12; // @panic
}
