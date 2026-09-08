class P1 { Q1 q; string p1; function init() { self.q = new; self.p1 = "P1"; } } class Q1 { P1 p; string q1; function init() { self.p = new; self.q1 = "Q1"; } } // @panic

function testArraysOfCyclicDependentTypes3() returns P1[] {
    P1[] arr = [];
    arr[3] = new;
    return arr;
}

public function main() {
    _ = testArraysOfCyclicDependentTypes3();
}
