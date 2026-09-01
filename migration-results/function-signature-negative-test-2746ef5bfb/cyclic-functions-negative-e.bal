final readonly & map<json> func = { // @error
    "f1": f1()
};

public isolated function testFunc() {
    json _ = func["f1"];
}

public isolated function f1() {
    var _ = testFunc();
}

type Func isolated function ();

final readonly & map<Func?> func1 = { // @error
    "f1": f2()
};

public isolated function testFunc1() {
    Func? _ = func1["f1"];
}

public isolated function f2() {
    var _ = testFunc1();
}
