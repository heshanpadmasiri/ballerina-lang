final string name = "Jack Sparrow";

record {|record {string n = p.n;} r = {};|} nestedRec = {};

function f1() {
    lock {
        f2();
    }
}

function f2() {
    int? a = 10;
    if a is () {
        _ = f1();
    }
}
