import ballerina/lang.'int as foo;

function testXMLNavigationOnSingleElement() {
    xml x1 = xml `<root><child attr="attr-val"></child></root>`;
    any item = 3;
    any x2 = item.<root>; // @error
    int k = 0;
    xml x3 = k.<root>; // @error
}

function testFilterExprWithInvalidImportPrefixInsteadOfNamespacePrefix() {
    xml x = xml`foo`;
    xml _ = x.<foo:doc>; // error // @error

    foo:Signed8 _ = 1;
}
