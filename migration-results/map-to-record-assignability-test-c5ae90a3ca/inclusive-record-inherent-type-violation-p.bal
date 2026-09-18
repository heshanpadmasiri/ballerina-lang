function testInherentTypeViolationInInclusiveRecords() {
    map<decimal> mDecimal = {"a": 1.2, "b": 2.3};
    record {} rDecimal = mDecimal;
    rDecimal["c"] = 3.4; // @panic
}

public function main() {
    testInherentTypeViolationInInclusiveRecords();
}
