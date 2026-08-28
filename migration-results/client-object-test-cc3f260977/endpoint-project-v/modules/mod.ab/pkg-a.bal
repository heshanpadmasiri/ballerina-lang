public client class DummyEndpoint {
    remote function invoke1(string a) returns error? {
        error e = error("i1");
        return e;
    }

    remote function invoke2(string a) returns string {
        return "done" + a;
    }
}

DummyEndpoint ep = new;

public function getDummyEndpoint() returns DummyEndpoint {
    return ep;
}
