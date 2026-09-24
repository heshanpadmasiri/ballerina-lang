xmlns "http://exampleB1.com" as ns1;

final string BA = ns1:doc;

function testXMLNSUsageInAnotherFile() {
    assert(BA, "{http://exampleB1.com}doc");
    assert(ns1:foo, "{http://exampleB1.com}foo");
    assert(ns3:foz, "{http://exampleB3.com}foz");

    xmlns "http://exampleB2.com" as ns2;
    assert(ns2:foo, "{http://exampleB2.com}foo");
}

xmlns "http://exampleB3.com" as ns3;
