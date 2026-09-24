import ballerina/io;

type XmlType xml;

function stampXMLToXML() returns xml|error {
    xml xmlValue = xml `<book>The Lost World</book>`;

    xml|error returnValue = xmlValue.cloneWithType(XmlType);
    return returnValue;
}

function stampXMLToAnydata() returns anydata|error {
    xml xmlValue = xml `<book>The Lost World</book>`;

    anydata|error anydataValue = xmlValue.cloneWithType(anydata);
    return anydataValue;
}

public function main() returns error? {
    xml xmlValue = check stampXMLToXML();
    io:println(xmlValue); // @output <book>The Lost World</book>
    io:println(xmlValue is xml); // @output true

    anydata anydataValue = check stampXMLToAnydata();
    io:println(anydataValue); // @output <book>The Lost World</book>
    io:println(anydataValue is xml); // @output true
}
