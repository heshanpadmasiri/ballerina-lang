import ballerina/io;
import ballerina/test;

xmlns "http://ballerina.com/b" as ns1;

public function main() returns error? {
    [xml, xml] elementLiterals = testElementLiteralWithNamespaces();
    io:println(elementLiterals[0].toString()); // @output <root xmlns="http://ballerina.com/" xmlns:ns0="http://ballerina.com/a" ns0:id="456"><foo>123</foo><bar xmlns:ns1="http://ballerina.com/c" ns1:status="complete"/></root>
    io:println(elementLiterals[1].toString()); // @output <foo xmlns="http://ballerina.com/">123</foo><bar xmlns="http://ballerina.com/" xmlns:ns1="http://ballerina.com/c" ns1:status="complete"/>
    int sequenceSize = 0;
    foreach xml _ in elementLiterals[1] {
        sequenceSize += 1;
    }
    io:println(sequenceSize); // @output 2

    [xml, xml, xml] qualifiedNames = testElementWithQualifiedName();
    io:println(qualifiedNames[0].toString()); // @output <root>hello</root>
    io:println(qualifiedNames[1].toString()); // @output <root xmlns="http://ballerina.com/">hello</root>
    io:println(qualifiedNames[2].toString()); // @output <ns1:root xmlns="http://ballerina.com/" xmlns:ns1="http://ballerina.com/b">hello</ns1:root>

    io:println(testDefineInlineNamespace().toString()); // @output <nsx:foo xmlns:nsx="http://wso2.com" nsx:id="123">hello</nsx:foo>
    [xml, xml] inlineDefaults = testDefineInlineDefaultNamespace();
    io:println(inlineDefaults[0].toString()); // @output <foo xmlns="http://ballerina.com/default/namespace" xmlns:nsx="http://wso2.com/aaa">hello</foo>
    io:println(inlineDefaults[1].toString()); // @output <foo xmlns="http://wso2.com" xmlns:nsx="http://wso2.com/aaa">hello</foo>
    io:println(testUsingNamespcesOfParent().toString()); // @output <root xmlns:ns0="http://ballerinalang.com/"><ns0:foo>hello</ns0:foo></root>

    [string, string, string] namespaceDeclarations = testNamespaceDclr();
    io:println(namespaceDeclarations[0]); // @output {http://sample.com/wso2/a2}foo
    io:println(namespaceDeclarations[1]); // @output {http://sample.com/wso2/b2}foo
    io:println(namespaceDeclarations[2]); // @output {http://sample.com/wso2/d2}foo
    [string, string, string] innerNamespaceDeclarations = testInnerScopeNamespaceDclr();
    io:println(innerNamespaceDeclarations[0]); // @output {http://ballerina.com/b}foo
    io:println(innerNamespaceDeclarations[1]); // @output {http://sample.com/wso2/a3}foo
    io:println(innerNamespaceDeclarations[2]); // @output {http://ballerina.com/b}foo

    io:println(testObjectLevelXML().toString()); // @output <p:person xmlns:p="foo" xmlns:q="bar">hello</p:person>
    string defaultNamespaceXml = XMLWithDefaultNamespaceToString();
    test:assertEquals(defaultNamespaceXml, "<Order xmlns=\"http://acme.company\" xmlns:acme=\"http://acme.company.nondefault\">\n        <OrderLines>\n            <OrderLine acme:lineNo=\"334\" itemCode=\"334-2\"/>\n        </OrderLines>\n        <ShippingAddress>\n        </ShippingAddress>\n    </Order>");
    io:println(defaultNamespaceXml); // @output <Order xmlns="http://acme.company" xmlns:acme="http://acme.company.nondefault">
                                      // @output         <OrderLines>
                                      // @output             <OrderLine acme:lineNo="334" itemCode="334-2"/>
                                      // @output         </OrderLines>
                                      // @output         <ShippingAddress>
                                      // @output         </ShippingAddress>
                                      // @output     </Order>
    xml serialized = check xml:fromString(getXML().toString());
    io:println(serialized.toString()); // @output <foo xmlns="http://wso2.com/">hello</foo>
    xml parsed = check xml:fromString("<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE foo [<!ELEMENT foo ANY ><!ENTITY data \"Example\" >]><foo>&data;</foo>");
    io:println(parsed.toString()); // @output <?xml version="1.0" encoding="UTF-8"?><foo>Example</foo>

    testXmlLiteralUsingXmlNamespacePrefix();
    check testXmlInterpolationWithQuery();
    testAddAttributeToDefaultNS();
}

function testElementLiteralWithNamespaces() returns [xml, xml] {
    xmlns "http://ballerina.com/";
    xmlns "http://ballerina.com/a" as ns0;
    xmlns "http://ballerina.com/c" as ns1;
    xml x1 = xml `<root ns0:id="456"><foo>123</foo><bar ns1:status="complete"></bar></root>`;
    xml x2 = x1/*;
    return [x1, x2];
}

function testElementWithQualifiedName() returns [xml, xml, xml] {
    xml x1 = xml `<root>hello</root>`;
    xmlns "http://ballerina.com/";
    xml x2 = xml `<root>hello</root>`;
    xml x3 = xml `<ns1:root>hello</ns1:root>`;
    return [x1, x2, x3];
}

function testDefineInlineNamespace() returns xml {
    return xml `<nsx:foo nsx:id="123" xmlns:nsx="http://wso2.com" >hello</nsx:foo>`;
}

function testDefineInlineDefaultNamespace() returns [xml, xml] {
    xmlns "http://ballerina.com/default/namespace";
    xml x1 = xml `<foo xmlns:nsx="http://wso2.com/aaa" >hello</foo>`;
    xml x2 = xml `<foo xmlns:nsx="http://wso2.com/aaa" xmlns="http://wso2.com" >hello</foo>`;
    return [x1, x2];
}

function testUsingNamespcesOfParent() returns xml {
    return xml `<root xmlns:ns0="http://ballerinalang.com/"><ns0:foo>hello</ns0:foo></root>`;
}

function testNamespaceDclr() returns [string, string, string] {
    xmlns "http://sample.com/wso2/a2" as ns0;
    xmlns "http://sample.com/wso2/b2" as ns1;
    xmlns "http://sample.com/wso2/c2";
    xmlns "http://sample.com/wso2/d2" as ns3;
    return [ns0:foo, ns1:foo, ns3:foo];
}

function testInnerScopeNamespaceDclr() returns [string, string, string] {
    string s1 = "";
    string s2 = "";
    string s3 = "";
    if true {
        s1 = ns1:foo;
        xmlns "http://sample.com/wso2/a3" as ns1;
        s2 = ns1:foo;
    }
    s3 = ns1:foo;
    return [s1, s2, s3];
}

class Person {
    xml info = xml `<p:person xmlns:p="foo" xmlns:q="bar">hello</p:person>`;
}

function testObjectLevelXML() returns xml {
    Person p = new();
    return p.info;
}

function getXML() returns xml {
    return xml `<foo xmlns="http://wso2.com/">hello</foo>`;
}

function XMLWithDefaultNamespaceToString() returns string {
    xml x = xml `<Order xmlns="http://acme.company" xmlns:acme="http://acme.company.nondefault">
        <OrderLines>
            <OrderLine acme:lineNo="334" itemCode="334-2"></OrderLine>
        </OrderLines>
        <ShippingAddress>
        </ShippingAddress>
    </Order>`;
    return x.toString();
}

function testXmlLiteralUsingXmlNamespacePrefix() {
    xml x1 = xml `<entry xml:base="https://namespace.servicebus.windows.net/$Resources/Eventhubs"></entry>`;
    test:assertEquals(x1.toString(), "<entry xml:base=\"https://namespace.servicebus.windows.net/$Resources/Eventhubs\"/>",
        "XML literal with xml namespace prefix failed");
}

xmlns "http://www.so2w.org" as globalNS;

function testXmlInterpolationWithQuery() returns error? {
    xml x1 = xml `<empRecords xmlns:inlineNS="http://www.so2w.org">
         ${from int i in 1 ... 3
        select xml `<empRecord employeeId="${i}"><inlineNS:id>${i}</inlineNS:id></empRecord>`}
      </empRecords>;`;
    xml x2 = x1/<empRecord>[0];
    test:assertEquals(x2.toString(), "<empRecord employeeId=\"1\"><inlineNS:id xmlns:inlineNS=\"http://www.so2w.org\">1</inlineNS:id></empRecord>", "XML interpolation with query failed");
    xmlns "http://www.so2w.org" as localNS;
    xml x3 = xml `<empRecords>
         ${from int i in 1 ... 3
        select xml `<empRecord employeeId="${i}"><localNS:id>${i}</localNS:id></empRecord>`}
      </empRecords>;`;
    xml x4 = x3/<empRecord>[0]/<localNS:id>;
    test:assertEquals(x4.toString(), "<localNS:id xmlns:localNS=\"http://www.so2w.org\">1</localNS:id>", "XML interpolation with query failed");
    xml x5 = from int i in [1] select xml `<empRecord employeeId="${i}"><localNS:id>${i}</localNS:id></empRecord>`;
    string expectedStr3 = "<empRecord employeeId=\"1\"><localNS:id xmlns:localNS=\"http://www.so2w.org\">1</localNS:id></empRecord>";
    test:assertEquals(x5.toString(), expectedStr3, "XML interpolation with query failed");
    xml x6 = xml `<empRecords>
         ${from int i in 1 ... 3
        select xml `<empRecord employeeId="${i}"><globalNS:id>${i}</globalNS:id></empRecord>`}
      </empRecords>;`;
    xml x7 = x6/<empRecord>[0]/<globalNS:id>;
    test:assertEquals(x7.toString(), "<globalNS:id xmlns:globalNS=\"http://www.so2w.org\">1</globalNS:id>", "XML interpolation with query failed");
    xml x8 = xml ``;
    from int i in [1] do { x8 = xml `<empRecord employeeId="${i}"><localNS:id>${i}</localNS:id></empRecord>`; };
    test:assertEquals(x8.toString(), expectedStr3, "XML interpolation with query failed");
    xml x9 = xml ``;
    from int j in [1] do { x9 = xml `<empRecord employeeId="${j}"><localNS:id>${j}</localNS:id></empRecord>`; };
    test:assertEquals(x9.toString(), expectedStr3, "XML interpolation with query failed");
    xml x10 = from int i in [1]
        let xml y = xml `<empRecord employeeId="${i}"><localNS:id>${i}</localNS:id></empRecord>`
        select xml `<record>${y}</record>`;
    string expectedStr5 = "<record><empRecord employeeId=\"1\"><localNS:id xmlns:localNS=\"http://www.so2w.org\">1</localNS:id></empRecord></record>";
    test:assertEquals(x10.toString(), expectedStr5, "XML interpolation with query failed");
    xml x11 = from xml x in (from int j in [1] select xml `<empRecord employeeId="${j}"><localNS:id>${j}</localNS:id></empRecord>`)
        select xml `<record>${x}</record>`;
    test:assertEquals(x11.toString(), expectedStr5, "XML interpolation with query failed");
    xml x12 = from int i in [1] join int j in [1]
        on xml `<empRecord employeeId="${i}"><localNS:id>${i}</localNS:id></empRecord>`
        equals xml `<empRecord employeeId="${j}"><localNS:id>${j}</localNS:id></empRecord>`
        select xml `<record>${i}</record>`;
    test:assertEquals(x12.toString(), "<record>1</record>", "XML interpolation with query failed");
    xml expectedXml = xml `<empRecord employeeId="1"><localNS:id>1</localNS:id></empRecord>`;
    xml x13 = from int i in [1]
        where xml `<empRecord employeeId="${i}"><localNS:id>${i}</localNS:id></empRecord>` == expectedXml
        select xml `<record>${expectedXml}</record>`;
    test:assertEquals(x13.toString(), expectedStr5, "XML interpolation with query failed");
    do {
        xmlns "http://www.so2w1.org" as doNS;
        xml x14 = from int i in [1] select xml `<localNS:empRecord employeeId="${i}"><doNS:id>${i}</doNS:id></localNS:empRecord>`;
        test:assertEquals(x14.toString(), "<localNS:empRecord xmlns:localNS=\"http://www.so2w.org\" employeeId=\"1\"><doNS:id xmlns:doNS=\"http://www.so2w1.org\">1</doNS:id></localNS:empRecord>", "XML interpolation with query failed");
    }
    do {
        xmlns "http://www.so2w2.org" as doNS;
        xml x15 = from int i in [1] select xml `<localNS:empRecord employeeId="${i}"><doNS:id>${i}</doNS:id></localNS:empRecord>`;
        test:assertEquals(x15.toString(), "<localNS:empRecord xmlns:localNS=\"http://www.so2w.org\" employeeId=\"1\"><doNS:id xmlns:doNS=\"http://www.so2w2.org\">1</doNS:id></localNS:empRecord>", "XML interpolation with query failed");
    }
}

function testAddAttributeToDefaultNS() {
    xml x1 = xml `<root xmlns="http://sample.com/wso2/c1" xmlns:ns3="http://sample.com/wso2/f"></root>`;
    var xAttr = let var x2 = <'xml:Element>x1 in x2.getAttributes();
    xAttr["{http://sample.com/wso2/c1}foo1"] = "bar1";
    test:assertEquals(x1.toString(), string `<root xmlns="http://sample.com/wso2/c1" xmlns:ns3="http://sample.com/wso2/f" foo1="bar1"/>`, "XML add attribute with default namespace failed");
    test:assertEquals(xAttr.toString(), string `{"{http://www.w3.org/2000/xmlns/}xmlns":"http://sample.com/wso2/c1","{http://www.w3.org/2000/xmlns/}ns3":"http://sample.com/wso2/f","{http://sample.com/wso2/c1}foo1":"bar1"}`, "XML add attribute with default namespace failed");
}
