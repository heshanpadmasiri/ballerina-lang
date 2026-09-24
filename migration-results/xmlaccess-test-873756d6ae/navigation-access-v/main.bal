import ballerina/io;

public function main() {
    [xml, xml, xml, xml, xml] single = testXMLNavigationOnSingleElement();
    io:println(single[0]); // @output <child attr="attr-val"/>
    io:println(single[1]); // @output <child attr="attr-val"/>
    io:println(single[2]); // @output <child attr="attr-val"/>
    io:println(single[3]); // @output <child attr="attr-val"/>
    io:println(single[4]); // @output <child attr="attr-val"/>

    [xml, xml, xml, xml, xml] namespacedSingle = testXMLNavigationOnSingleElementWithNamespaces();
    io:println(namespacedSingle[0]); // @output <ns:child xmlns:ns="foo"/>
    io:println(namespacedSingle[1]); // @output <ns:child xmlns:ns="foo"/>
    io:println(namespacedSingle[2]); // @output <ns:child xmlns:ns="foo"/>
    io:println(namespacedSingle[3]); // @output <ns:child xmlns:ns="foo"/>
    io:println(namespacedSingle[4]); // @output <ns:child xmlns:ns="foo"/>

    [xml, xml, xml, xml, xml, xml, int, xml] defaultNs = testXMLNavigationOnSingleElementReferToDefaultNS();
    io:println(defaultNs[0]); // @output <child xmlns="foo"/>
    io:println(defaultNs[1]); // @output <child xmlns="foo"/>
    io:println(defaultNs[2]); // @output <child xmlns="foo"/>
    io:println(defaultNs[3]); // @output <child xmlns="foo"/>
    io:println(defaultNs[4]); // @output <child xmlns="foo"/>
    io:println(defaultNs[5]); // @output <child xmlns="foo"/>
    io:println(defaultNs[6]); // @output 0
    io:println(defaultNs[7]); // @output <child xmlns="foo"/>

    [xml, xml, xml, xml, xml] defaultNsPrefix = testXMLNavigationOnSingleElementReferToDefaultNSViaPrefix();
    io:println(defaultNsPrefix[0]); // @output <child xmlns="foo"/>
    io:println(defaultNsPrefix[1]); // @output <child xmlns="foo"/>
    io:println(defaultNsPrefix[2]); // @output <child xmlns="foo"/>
    io:println(defaultNsPrefix[3]); // @output <child xmlns="foo"/>
    io:println(defaultNsPrefix[4]); // @output <child xmlns="foo"/>

    [xml, xml, xml, xml, xml] sequence = testXMLNavigationOnSequence();
    io:println(sequence[0]); // @output <child>A</child><child>B</child><child>C</child>
    io:println(sequence[1]); // @output <child>A</child><child>B</child><child>C</child><it-child>D</it-child>TEXT
    io:println(sequence[2]); // @output <child>A</child><child>B</child><child>C</child><it-child>D</it-child>
    io:println(sequence[3]); // @output <child>A</child><child>B</child><child>C</child>
    io:println(sequence[4]); // @output <child>A</child><child>B</child><child>C</child>

    [xml, xml, xml, xml, xml] namespacedSequence = testXMLNavigationOnSequenceWithNamespaces();
    io:println(namespacedSequence[0]); // @output <child xmlns="foo">A</child><child xmlns="foo" xmlns:ns="foo">B</child>
    io:println(namespacedSequence[1]); // @output <child xmlns="foo">A</child><child xmlns="foo" xmlns:ns="foo">B</child><k:child xmlns="foo" xmlns:k="bar">C</k:child><it-child xmlns="foo">D</it-child>TEXT
    io:println(namespacedSequence[2]); // @output <child xmlns="foo">A</child><child xmlns="foo" xmlns:ns="foo">B</child><k:child xmlns="foo" xmlns:k="bar">C</k:child><it-child xmlns="foo">D</it-child>
    io:println(namespacedSequence[3]); // @output <child xmlns="foo">A</child><child xmlns="foo" xmlns:ns="foo">B</child>
    io:println(namespacedSequence[4]); // @output <child xmlns="foo">A</child><child xmlns="foo" xmlns:ns="foo">B</child>

    [xml, xml, xml, xml, xml] multipleFilters = testXMLNavigationOnSequenceWithNamespacesAndMultipleFilters();
    io:println(multipleFilters[0]); // @output <child xmlns="foo">A</child><child xmlns="foo" xmlns:ns="foo">B</child><child2 xmlns="foo">D</child2>
    io:println(multipleFilters[2]); // @output <child xmlns="foo">A</child><child xmlns="foo" xmlns:ns="foo">B</child><k:child xmlns="foo" xmlns:k="bar">C</k:child><child2 xmlns="foo">D</child2>
    io:println(multipleFilters[3]); // @output <child xmlns="foo">A</child><child xmlns="foo" xmlns:ns="foo">B</child><k:child xmlns="foo" xmlns:k="bar">C</k:child><child2 xmlns="foo">D</child2>
    io:println(multipleFilters[4]); // @output <child xmlns="foo">A</child><child xmlns="foo" xmlns:ns="foo">B</child><child2 xmlns="foo">D</child2>

    [xml, xml, xml, xml, xml, xml, xml] composition = testXMLElementAccessNavigationAccessComposition();
    io:println(composition[0]); // @output <lname>Gunae</lname><lname>Jayee</lname><lname>Kumarae</lname>
    io:println(composition[1]); // @output <fname>Kamal</fname><lname>Gunae</lname><fname>Nimal</fname><lname>Jayee</lname><fname>Sunil</fname><lname>Kumarae</lname>
    io:println(composition[2]); // @output <lname>Gunae</lname><lname>Jayee</lname><lname>Kumarae</lname>
    io:println(composition[3]); // @output <fname>Kamal</fname><fname>Nimal</fname><fname>Sunil</fname>
    io:println(composition[4]); // @output KamalGunaeNimalJayeeSunilKumarae
    io:println(composition[5]); // @output <fname>Kamal</fname><fname>Nimal</fname><fname>Sunil</fname>
    io:println(composition[6]); // @output <fname>Kamal</fname><fname>Nimal</fname><fname>Sunil</fname>

    [xml, xml] quoted = testXMLNavigationExpressionWithQuotedIdentifiers();
    io:println(quoted[0]); // @output <object xmlns="http://www.force.com/2009/06/asyncapi/dataload">Account</object>
    io:println(quoted[1]); // @output <object xmlns="http://www.force.com/2009/06/asyncapi/dataload">Account</object>
    testXMLNavigationExpressionWithXMLSubtypeOnLHS();
    testXMLNavigationDescendantsStepWithXMLSubtypeOnLHS();
    testXMLNavigationWithEscapeCharacter();
    testXmlNavigationWithDefaultNamespaceDefinedAfter();
    testXmlIndexedStepExtend();
    testXmlFilterStepExtend();
    testXmlIndexedAndFilterStepExtend();
    error? methodCallResult = testXmlMethodCallStepExtend();
    testXmlMethodCallIndexedAndFilterStepExtend();
}
