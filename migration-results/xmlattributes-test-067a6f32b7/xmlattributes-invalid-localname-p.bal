import ballerina/lang.'xml;

xmlns "http://sample.com/wso2/c1";

function testAddAttributeWithoutLocalname() returns xml {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f"></root>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xAttr["{http://sample.com/wso2/e}"] = "bar"; // @panic
    return x1;
}

public function main() {
    xml _ = testAddAttributeWithoutLocalname();
}
