import endpointproject.mod.ab;

function testCheck() returns error? {
    var a = testCheckFunction();

    if a is error {
        if a.message() == "i1" {
            return;
        }
        panic error("Expected error message: , found: i1" + a.message());
    }
    panic error("Expected error, found: " + (typeof a).toString());
}

function testCheckFunction() returns error? {
    ab:DummyEndpoint dummyEp = ab:getDummyEndpoint();
    check dummyEp->invoke1("foo");
    return ();
}

function testNewEP(string a) {
    ab:DummyEndpoint ep1 = new;
    string r = ep1->invoke2(a);

    if r != "donedone" {
        panic error("Expected: donedone, found: " + r);
    }
}

public function main() returns error? {
    check testCheck();
    testNewEP("done");
}
