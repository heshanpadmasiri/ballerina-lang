function testInherentTypeViolationInExclusiveRecords() {
    map<int> mInt = {"a": 1, "b": 2};
    record {| (int|string)...; |} r = mInt;
    r["c"] = "foo"; // @panic
}

public function main() {
    testInherentTypeViolationInExclusiveRecords();
}
