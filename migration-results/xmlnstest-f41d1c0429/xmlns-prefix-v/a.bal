xmlns "http://exampleA1.com" as ns1;
final string AA = ns1:doc;

function testXMLNSUsage() {
    assert(AA, "{http://exampleA1.com}doc");
    assert(ns1:foo, "{http://exampleA1.com}foo");
    assert(ns3:foz, "{http://exampleA3.com}foz");

    xmlns "http://exampleA2.com" as ns2;
    assert(ns2:foo, "{http://exampleA2.com}foo");
}

xmlns "http://exampleA3.com" as ns3;

function assert(anydata actual, anydata expected) {
    if expected != actual {
        panic error(string `expected ${expected.toString()}, but found ${actual.toString()};`);
    }
}
