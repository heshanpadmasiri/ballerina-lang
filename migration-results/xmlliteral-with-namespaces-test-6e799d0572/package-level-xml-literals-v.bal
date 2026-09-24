import ballerina/io;

xmlns "http://ballerina.com/b" as ns1;

xml person = xml `<p:person xmlns:p="foo" xmlns:q="bar">hello</p:person>`;
xml student = xml `<ns1:student>hello</ns1:student>`;

public function main() {
    [xml, xml] values = testPackageLevelXML();
    io:println(values[0].toString()); // @output <p:person xmlns:p="foo" xmlns:q="bar">hello</p:person>
    io:println(values[1].toString()); // @output <ns1:student xmlns:ns1="http://ballerina.com/b">hello</ns1:student>
}

function testPackageLevelXML() returns [xml, xml] {
    return [person, student];
}
