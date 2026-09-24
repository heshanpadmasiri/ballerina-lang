import ballerina/io;
import ballerina/lang.'xml;

xmlns "http://sample.com/wso2/a1" as ns0;
xmlns "http://sample.com/wso2/b1" as ns1;
xmlns "http://sample.com/wso2/c1";

function testAddAttributeWithString() returns xml {
    xml x1 = xml `<root xmlns:ns4="http://sample.com/wso2/f"></root>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xAttr["foo1"] = "bar1";
    xAttr["{http://sample.com/wso2/e}foo2"] = "bar2";
    xAttr["{http://sample.com/wso2/f}foo3"] = "bar3";
    return x1;
}

function testAddAttributeWithEmptyNamespace() returns xml {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f"></root>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xAttr["{}foo1"] = "bar";
    return x1;
}

function testAddNamespaceAsAttribute() returns [xml, xml] {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f"></root>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xAttr["{http://www.w3.org/2000/xmlns/}ns4"] = "http://wso2.com";
    xml x2 = xml `<root xmlns="http://ballerinalang.org/" xmlns:ns3="http://sample.com/wso2/f"></root>`;
    map<string> xAttr2 = (<'xml:Element>x2).getAttributes();
    xAttr2["{http://ballerinalang.org/}att"] = "http://wso2.com";
    return [x1, x2];
}

function testAddAttributeWithQName() returns xml {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f"></root>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xAttr[ns0:foo1] = "bar1";
    return x1;
}

function testAddAttributeWithDiffQName_1() returns xml {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f" xmlns:ns4="http://sample.com/wso2/f/" xmlns:ns5="http://sample.com/wso2/f/" ns4:diff="yes"></root>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xmlns "http://sample.com/wso2/f" as pre;
    xAttr[pre:foo1] = "bar1";
    return x1;
}

function testAddAttributeWithDiffQName_2() returns xml {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f" xmlns:ns4="http://sample.com/wso2/f/" xmlns:ns5="http://sample.com/wso2/f/" ns4:diff="yes"></root>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xmlns "http://sample.com/wso2/f/" as ns5;
    xAttr[ns5:foo1] = "bar1";
    return x1;
}

function testAddAttributeWithDiffQName_3() returns xml {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f" xmlns:ns4="http://sample.com/wso2/f/" xmlns:ns5="http://sample.com/wso2/f/" ns4:diff="yes"></root>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xmlns "http://sample.com/wso2/f/" as ns4;
    xAttr[ns4:foo1] = "bar1";
    return x1;
}

function testAddAttributeWithDiffQName_5() returns xml {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f" xmlns:ns4="http://sample.com/wso2/f/" xmlns:ns5="http://sample.com/wso2/f/" ns4:diff="yes"></root>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xAttr["{http://sample.com/wso2/c1}foo1"] = "bar1";
    xAttr["{}foo2"] = "bar2";
    xAttr["foo3"] = "bar3";
    return x1;
}

function testUpdateAttributeWithString() returns xml {
    xmlns "http://defaultNs/";
    xml x1 = xml `<root xmlns:ns0="http://sample.com/wso2/e" foo1="bar1" ns0:foo2="bar2" foo3="bar3"/>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xAttr["foo1"] = "newbar1";
    xAttr["{http://sample.com/wso2/e}foo2"] = "newbar2";
    xAttr["foo3"] = "newbar3";
    return x1;
}

function testUpdateAttributeWithString_1() returns xml {
    xml x1 = xml `<root xmlns:ns4="http://sample.com/wso2/f" xmlns:ns0Kf5j="http://sample.com/wso2/e" foo1="bar1" ns0Kf5j:foo2="bar2" ns4:foo3="bar3"/>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xAttr["{http://sample.com/wso2/f/t}foo3"] = "newbar3";
    return x1;
}

function testUpdateNamespaceAsAttribute() returns xml {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f"></root>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xAttr["{http://www.w3.org/2000/xmlns/}ns3"] = "http://wso2.com";
    return x1;
}

function testUpdateAttributeWithQName() returns xml {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f" xmlns:ns0="http://sample.com/wso2/a1" ns0:foo1="bar1" ns3:foo2="bar2"/>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xAttr[ns0:foo1] = "newbar1";
    xmlns "http://sample.com/wso2/f" as ns4;
    xAttr[ns4:foo2] = "newbar2";
    return x1;
}

function testUpdateAttributeWithQName_1() returns xml {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f" xmlns:ns0="http://sample.com/wso2/a1" xmlns:ns5="http://sample.com/wso2/a1" ns0:foo1="bar1" ns3:foo2="bar2"/>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xmlns "http://sample.com/wso2/a1" as pre;
    xAttr[pre:foo1] = "newaddedbar1";
    return x1;
}

function testGetAttributeWithString() returns [string|error, string?, string?] {
    xml x1 = xml `<root xmlns:ns4="http://sample.com/wso2/f" xmlns:ns0="http://sample.com/wso2/e" foo1="bar1" ns0:foo2="bar2" ns4:foo3="bar3"/>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    return [x1.foo1, xAttr["{http://sample.com/wso2/e}foo2"], xAttr["{http://sample.com/wso2/eee}foo2"]];
}

function testGetAttributeWithoutLocalname() returns string? {
    xml x1 = xml `<root xmlns:ns4="http://sample.com/wso2/f" xmlns="http://sample.com/wso2/e" foo1="bar1" ns4:foo3="bar3"/>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    return xAttr["{http://sample.com/wso2/e}"];
}

function testGetNamespaceAsAttribute() returns string? {
    xml x1 = xml `<root xmlns:ns4="http://sample.com/wso2/f" xmlns="http://sample.com/wso2/e" foo1="bar1" ns4:foo3="bar3"/>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    return xAttr["{http://www.w3.org/2000/xmlns/}ns4"];
}

function testGetAttributeWithQName() returns [string?, string?, string?] {
    xml x1 = xml `<root xmlns:ns3="http://sample.com/wso2/f" xmlns:ns0="http://sample.com/wso2/a1" ns0:foo1="bar1" ns3:foo2="bar2"/>`;
    map<string> xAttr = (<'xml:Element>x1).getAttributes();
    xmlns "http://sample.com/wso2/f" as ns4;
    return [xAttr[ns0:foo1], xAttr[ns4:foo2], xAttr[ns1:foo2]];
}

function testUsingQNameAsString() returns [string, string] {
    string s1 = ns0:wso2;
    string temp = "  " + ns0:ballerina + "  ";
    return [s1, temp.trim()];
}

function testGetAttributeFromSingletonSeq() returns string? {
    xml x1 = xml `<root><child xmlns:p1="http://wso2.com/" xmlns:p2="http://sample.com/wso2/a1/" p1:foo="bar"/></root>`;
    xml x2 = x1/*;
    map<string> xAttr = (<'xml:Element>x2).getAttributes();
    return xAttr["{http://wso2.com/}foo"];
}

function mapOperationsOnXmlAttribute() returns [int?, string[]?, boolean] {
    xml x1 = xml `<child foo="bar"/>`;
    map<string> attrMap = (<'xml:Element>x1).getAttributes();
    return [attrMap.length(), attrMap.keys(), true];
}

function testCharacterReferencesInXmlAttributeValue() {
    string u9 = "\u{9}";
    string uA = "\u{A}";
    string uD = "\u{D}";
    xml x = xml`<p att="x&amp;y|${u9}|${uA}|${uD}|&lt;&gt;"/>`;
    string att = checkpanic x.att;
    string expected = string `x&y|${u9}|${uA}|${uD}|<>`;
    if att != expected {
        panic error("Assertion error, expected `" + expected + "`, found `" + att + "`");
    }
}

function assertEquality(anydata expected, anydata actual) {
    if expected != actual {
        panic error("expected '" + expected.toString() + "', found '" + actual.toString() + "'");
    }
}

function testAttributesInEmptyXMLSequence() {
    xml testXml = xml `<ClinicalDocument><realmCode code="US"/><typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/><templateId root="2.16.840.1.113883"/></ClinicalDocument>`;
    xml idElement = testXml/<id>;
    string|error idVal = idElement.root;
    string? optionalIdVal = checkpanic idElement?.root;
    assertEquality((), optionalIdVal);
    if idVal is error {
        error error(_, ...details) = idVal;
        assertEquality("empty xml sequence cannot have attributes", details["message"]);
        return;
    }
    panic error("expected 'error', found 'string'");
}

function hasUpdatedFoo3WithExpectedNamespace() returns boolean {
    string serialized = testUpdateAttributeWithString_1().toString();
    int? urlPosition = serialized.indexOf("http://sample.com/wso2/f/t");
    if urlPosition is int {
        string beforeUrl = serialized.substring(0, urlPosition);
        int? colonPosition = beforeUrl.lastIndexOf(":");
        int? equalPosition = beforeUrl.lastIndexOf("=");
        if colonPosition is int && equalPosition is int {
            string prefix = beforeUrl.substring(colonPosition + 1, equalPosition);
            return serialized.includes(prefix + ":foo3=\"newbar3\"");
        }
    }
    return false;
}

public function main() {
    io:println(testAddAttributeWithString()); // @output <root xmlns="http://sample.com/wso2/c1" xmlns:ns4="http://sample.com/wso2/f" foo1="bar1" xmlns:ns1="http://sample.com/wso2/e" ns1:foo2="bar2" ns4:foo3="bar3"/>
    io:println(testAddAttributeWithEmptyNamespace()); // @output <root xmlns="http://sample.com/wso2/c1" xmlns:ns3="http://sample.com/wso2/f" foo1="bar"/>
    [xml, xml] namespaces = testAddNamespaceAsAttribute();
    io:println(namespaces[0]); // @output <root xmlns="http://sample.com/wso2/c1" xmlns:ns3="http://sample.com/wso2/f" xmlns:ns4="http://wso2.com"/>
    io:println(namespaces[1]); // @output <root xmlns="http://ballerinalang.org/" xmlns:ns3="http://sample.com/wso2/f" att="http://wso2.com"/>
    io:println(testAddAttributeWithQName()); // @output <root xmlns="http://sample.com/wso2/c1" xmlns:ns3="http://sample.com/wso2/f" xmlns:ns1="http://sample.com/wso2/a1" ns1:foo1="bar1"/>
    io:println(testAddAttributeWithDiffQName_1()); // @output <root xmlns="http://sample.com/wso2/c1" xmlns:ns4="http://sample.com/wso2/f/" xmlns:ns3="http://sample.com/wso2/f" xmlns:ns5="http://sample.com/wso2/f/" ns5:diff="yes" ns3:foo1="bar1"/>
    io:println(testAddAttributeWithDiffQName_2()); // @output <root xmlns="http://sample.com/wso2/c1" xmlns:ns4="http://sample.com/wso2/f/" xmlns:ns3="http://sample.com/wso2/f" xmlns:ns5="http://sample.com/wso2/f/" ns5:diff="yes" ns5:foo1="bar1"/>
    io:println(testAddAttributeWithDiffQName_3()); // @output <root xmlns="http://sample.com/wso2/c1" xmlns:ns4="http://sample.com/wso2/f/" xmlns:ns3="http://sample.com/wso2/f" xmlns:ns5="http://sample.com/wso2/f/" ns5:diff="yes" ns5:foo1="bar1"/>
    io:println(testAddAttributeWithDiffQName_5()); // @output <root xmlns="http://sample.com/wso2/c1" xmlns:ns4="http://sample.com/wso2/f/" xmlns:ns3="http://sample.com/wso2/f" xmlns:ns5="http://sample.com/wso2/f/" ns5:diff="yes" foo1="bar1" foo2="bar2" foo3="bar3"/>
    io:println(testUpdateAttributeWithString()); // @output <root xmlns="http://defaultNs/" xmlns:ns0="http://sample.com/wso2/e" foo1="newbar1" ns0:foo2="newbar2" foo3="newbar3"/>
    io:println(hasUpdatedFoo3WithExpectedNamespace()); // @output true
    io:println(testUpdateNamespaceAsAttribute()); // @output <root xmlns="http://sample.com/wso2/c1" xmlns:ns3="http://wso2.com"/>
    io:println(testUpdateAttributeWithQName()); // @output <root xmlns="http://sample.com/wso2/c1" xmlns:ns3="http://sample.com/wso2/f" xmlns:ns0="http://sample.com/wso2/a1" ns0:foo1="newbar1" ns3:foo2="newbar2"/>
    io:println(testUpdateAttributeWithQName_1()); // @output <root xmlns="http://sample.com/wso2/c1" xmlns:ns3="http://sample.com/wso2/f" xmlns:ns0="http://sample.com/wso2/a1" xmlns:ns5="http://sample.com/wso2/a1" ns5:foo1="newaddedbar1" ns3:foo2="bar2"/>
    [string|error, string?, string?] strings = testGetAttributeWithString();
    io:println(strings[0]); // @output bar1
    io:println(strings[1]); // @output bar2
    io:println(strings[2]); // @output
    io:println(testGetAttributeWithoutLocalname()); // @output
    io:println(testGetNamespaceAsAttribute()); // @output http://sample.com/wso2/f
    [string?, string?, string?] qNames = testGetAttributeWithQName();
    io:println(qNames[0]); // @output bar1
    io:println(qNames[1]); // @output bar2
    io:println(qNames[2]); // @output
    [string, string] qNameStrings = testUsingQNameAsString();
    io:println(qNameStrings[0]); // @output {http://sample.com/wso2/a1}wso2
    io:println(qNameStrings[1]); // @output {http://sample.com/wso2/a1}ballerina
    io:println(testGetAttributeFromSingletonSeq()); // @output bar
    [int?, string[]?, boolean] mapResults = mapOperationsOnXmlAttribute();
    io:println(mapResults[0]); // @output 2
    io:println(mapResults[1]); // @output ["{http://www.w3.org/2000/xmlns/}xmlns","foo"]
    io:println(mapResults[2]); // @output true
    testCharacterReferencesInXmlAttributeValue();
    testPrintAttribMap();
    testAttributesInEmptyXMLSequence();
}

function testPrintAttribMap() {
    xml x1 = xml `<Person name="Foo" />`;
    map<string> attrMap = (<'xml:Element>x1).getAttributes();
    io:println(attrMap); // @output {"{http://www.w3.org/2000/xmlns/}xmlns":"http://sample.com/wso2/c1","name":"Foo"}
}
