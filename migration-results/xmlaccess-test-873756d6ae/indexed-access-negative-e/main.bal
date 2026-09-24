function testUpdatingGetAllChildren() {
    xml x1 = xml `<name>supun</name>`;
    xml x2 = xml `<fruit>apple</fruit>`;
    x1/* = x2; // @error
}

function testNonStringIndexAccess() {
    xml x = xml `<elem></elem>`;
    var c = x["child"]; // @error
    var k = x[true]; // @error
    var b = x[1.2]; // @error
}

function testInvalidXMLAccessWithIndex() {
    xml x1 = xml `<root><!-- comment node--><name>supun</name><city>colombo</city></root>`;
    xml x2 = x1[0]/*;

    x2[1] = xml `<address/>`; // @error

    string|'xml:Text x3 = xml `sample test`;
    string sampleString1 = x3[0]; // @error
    xml x4 = x3[0]; // @error
}
