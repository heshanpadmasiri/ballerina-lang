import ballerina/io;

xmlns "http://ballerina.com/b" as ns1;

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
    xml x1 = xml `<nsx:foo nsx:id="123" xmlns:nsx="http://wso2.com" >hello</nsx:foo>`;
    return x1;
}

function testDefineInlineDefaultNamespace() returns [xml, xml] {
    xmlns "http://ballerina.com/default/namespace";

    xml x1 = xml `<foo xmlns:nsx="http://wso2.com/aaa" >hello</foo>`;
    xml x2 = xml `<foo xmlns:nsx="http://wso2.com/aaa" xmlns="http://wso2.com" >hello</foo>`;
    return [x1, x2];
}

function testUsingNamespcesOfParent() returns xml {
    xml x = xml `<root xmlns:ns0="http://ballerinalang.com/"><ns0:foo>hello</ns0:foo></root>`;
    return x;
}

function testComplexXMLLiteral() returns xml {
    xml x = xml `<cre:InputParameters xmlns:cre="http://xmlns.oracle.com/apps/ozf/soaprovider/plsql/ozf_sd_request_pub/create_sd_request/" xmlns:ore="http://xmlns.oracle.com/apps/ozf/soaprovider/plsql/ozf_sd_request_pub/create_sd_request/" xmlns:pre="http://xmlns.oracle.com/apps/ozf/soaprovider/plsql/ozf_sd_request_pub/create_sd_request/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <cre:P_API_VERSION_NUMBER>1.0</cre:P_API_VERSION_NUMBER>
   <cre:P_INIT_MSG_LIST>T</cre:P_INIT_MSG_LIST>
   <cre:P_COMMIT>F</cre:P_COMMIT>
   <cre:P_VALIDATION_LEVEL>100</cre:P_VALIDATION_LEVEL>
   <cre:P_SDR_LINES_TBL>
      <pre:P_SDR_LINES_TBL_ITEM pre:line="true" ore:tested="yes">
         <pre:PRODUCT_CONTEXT>PRODUCT</pre:PRODUCT_CONTEXT>
         <ore:INVENTORY_ITEM_ID>2155</ore:INVENTORY_ITEM_ID>
         <cre:ITEM_UOM>Ea</cre:ITEM_UOM>
         <cre:REQUESTED_DISCOUNT_TYPE>%</cre:REQUESTED_DISCOUNT_TYPE>
         <cre:REQUESTED_DISCOUNT_VALUE>20</cre:REQUESTED_DISCOUNT_VALUE>
         <cre:COST_BASIS>200</cre:COST_BASIS>
         <cre:MAX_QTY>200</cre:MAX_QTY>
         <cre:APPROVED_DISCOUNT_TYPE>%</cre:APPROVED_DISCOUNT_TYPE>
         <cre:APPROVED_DISCOUNT_VALUE>20</cre:APPROVED_DISCOUNT_VALUE>
         <cre:APPROVED_MAX_QTY>200</cre:APPROVED_MAX_QTY>
         <cre:VENDOR_APPROVED_FLAG>Y</cre:VENDOR_APPROVED_FLAG>
         <cre:PRODUCT_COST_CURRENCY>USD</cre:PRODUCT_COST_CURRENCY>
         <cre:END_CUSTOMER_CURRENCY>USD</cre:END_CUSTOMER_CURRENCY>
      </pre:P_SDR_LINES_TBL_ITEM>
   </cre:P_SDR_LINES_TBL>
   <cre:P_SDR_CUST_TBL>
      <cre:P_SDR_CUST_TBL_ITEM>
         <cre:CUST_ACCOUNT_ID>1290</cre:CUST_ACCOUNT_ID>
         <cre:PARTY_ID>1290</cre:PARTY_ID>
         <cre:SITE_USE_ID>10479</cre:SITE_USE_ID>
         <cre:CUST_USAGE_CODE>BILL_TO</cre:CUST_USAGE_CODE>
         <cre:END_CUSTOMER_FLAG>N</cre:END_CUSTOMER_FLAG>
      </cre:P_SDR_CUST_TBL_ITEM>
   </cre:P_SDR_CUST_TBL>
   <cre:P_SDR_CUST_TBL>
      <cre:P_SDR_CUST_TBL_ITEM>
         <cre:CUST_ACCOUNT_ID>1287</cre:CUST_ACCOUNT_ID>
         <cre:PARTY_ID>1287</cre:PARTY_ID>
         <cre:SITE_USE_ID>1418</cre:SITE_USE_ID>
         <cre:CUST_USAGE_CODE>CUSTOMER</cre:CUST_USAGE_CODE>
         <cre:END_CUSTOMER_FLAG>Y</cre:END_CUSTOMER_FLAG>
      </cre:P_SDR_CUST_TBL_ITEM>
   </cre:P_SDR_CUST_TBL>
</cre:InputParameters>`;

    return x;
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

public function main() {
    var elementLiterals = testElementLiteralWithNamespaces();
    io:println(elementLiterals[0]); // @output <root xmlns="http://ballerina.com/" xmlns:ns0="http://ballerina.com/a" ns0:id="456"><foo>123</foo><bar xmlns:ns1="http://ballerina.com/c" ns1:status="complete"/></root>
    io:println(elementLiterals[1]); // @output <foo xmlns="http://ballerina.com/">123</foo><bar xmlns="http://ballerina.com/" xmlns:ns1="http://ballerina.com/c" ns1:status="complete"/>
    io:println(elementLiterals[1].length()); // @output 2

    var qualifiedNames = testElementWithQualifiedName();
    io:println(qualifiedNames[0]); // @output <root>hello</root>
    io:println(qualifiedNames[1]); // @output <root xmlns="http://ballerina.com/">hello</root>
    io:println(qualifiedNames[2]); // @output <ns1:root xmlns="http://ballerina.com/" xmlns:ns1="http://ballerina.com/b">hello</ns1:root>

    io:println(testDefineInlineNamespace()); // @output <nsx:foo xmlns:nsx="http://wso2.com" nsx:id="123">hello</nsx:foo>

    var defaultNamespaces = testDefineInlineDefaultNamespace();
    io:println(defaultNamespaces[0]); // @output <foo xmlns="http://ballerina.com/default/namespace" xmlns:nsx="http://wso2.com/aaa">hello</foo>
    io:println(defaultNamespaces[1]); // @output <foo xmlns="http://wso2.com" xmlns:nsx="http://wso2.com/aaa">hello</foo>

    io:println(testUsingNamespcesOfParent()); // @output <root xmlns:ns0="http://ballerinalang.com/"><ns0:foo>hello</ns0:foo></root>
    io:println(testComplexXMLLiteral()); // @output <cre:InputParameters xmlns:cre="http://xmlns.oracle.com/apps/ozf/soaprovider/plsql/ozf_sd_request_pub/create_sd_request/" xmlns:ore="http://xmlns.oracle.com/apps/ozf/soaprovider/plsql/ozf_sd_request_pub/create_sd_request/" xmlns:pre="http://xmlns.oracle.com/apps/ozf/soaprovider/plsql/ozf_sd_request_pub/create_sd_request/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    // @output    <cre:P_API_VERSION_NUMBER>1.0</cre:P_API_VERSION_NUMBER>
    // @output    <cre:P_INIT_MSG_LIST>T</cre:P_INIT_MSG_LIST>
    // @output    <cre:P_COMMIT>F</cre:P_COMMIT>
    // @output    <cre:P_VALIDATION_LEVEL>100</cre:P_VALIDATION_LEVEL>
    // @output    <cre:P_SDR_LINES_TBL>
    // @output       <pre:P_SDR_LINES_TBL_ITEM pre:line="true" pre:tested="yes">
    // @output          <pre:PRODUCT_CONTEXT>PRODUCT</pre:PRODUCT_CONTEXT>
    // @output          <ore:INVENTORY_ITEM_ID>2155</ore:INVENTORY_ITEM_ID>
    // @output          <cre:ITEM_UOM>Ea</cre:ITEM_UOM>
    // @output          <cre:REQUESTED_DISCOUNT_TYPE>%</cre:REQUESTED_DISCOUNT_TYPE>
    // @output          <cre:REQUESTED_DISCOUNT_VALUE>20</cre:REQUESTED_DISCOUNT_VALUE>
    // @output          <cre:COST_BASIS>200</cre:COST_BASIS>
    // @output          <cre:MAX_QTY>200</cre:MAX_QTY>
    // @output          <cre:APPROVED_DISCOUNT_TYPE>%</cre:APPROVED_DISCOUNT_TYPE>
    // @output          <cre:APPROVED_DISCOUNT_VALUE>20</cre:APPROVED_DISCOUNT_VALUE>
    // @output          <cre:APPROVED_MAX_QTY>200</cre:APPROVED_MAX_QTY>
    // @output          <cre:VENDOR_APPROVED_FLAG>Y</cre:VENDOR_APPROVED_FLAG>
    // @output          <cre:PRODUCT_COST_CURRENCY>USD</cre:PRODUCT_COST_CURRENCY>
    // @output          <cre:END_CUSTOMER_CURRENCY>USD</cre:END_CUSTOMER_CURRENCY>
    // @output       </pre:P_SDR_LINES_TBL_ITEM>
    // @output    </cre:P_SDR_LINES_TBL>
    // @output    <cre:P_SDR_CUST_TBL>
    // @output       <cre:P_SDR_CUST_TBL_ITEM>
    // @output          <cre:CUST_ACCOUNT_ID>1290</cre:CUST_ACCOUNT_ID>
    // @output          <cre:PARTY_ID>1290</cre:PARTY_ID>
    // @output          <cre:SITE_USE_ID>10479</cre:SITE_USE_ID>
    // @output          <cre:CUST_USAGE_CODE>BILL_TO</cre:CUST_USAGE_CODE>
    // @output          <cre:END_CUSTOMER_FLAG>N</cre:END_CUSTOMER_FLAG>
    // @output       </cre:P_SDR_CUST_TBL_ITEM>
    // @output    </cre:P_SDR_CUST_TBL>
    // @output    <cre:P_SDR_CUST_TBL>
    // @output       <cre:P_SDR_CUST_TBL_ITEM>
    // @output          <cre:CUST_ACCOUNT_ID>1287</cre:CUST_ACCOUNT_ID>
    // @output          <cre:PARTY_ID>1287</cre:PARTY_ID>
    // @output          <cre:SITE_USE_ID>1418</cre:SITE_USE_ID>
    // @output          <cre:CUST_USAGE_CODE>CUSTOMER</cre:CUST_USAGE_CODE>
    // @output          <cre:END_CUSTOMER_FLAG>Y</cre:END_CUSTOMER_FLAG>
    // @output       </cre:P_SDR_CUST_TBL_ITEM>
    // @output    </cre:P_SDR_CUST_TBL>
    // @output </cre:InputParameters>

    var declarations = testNamespaceDclr();
    io:println(declarations[0]); // @output {http://sample.com/wso2/a2}foo
    io:println(declarations[1]); // @output {http://sample.com/wso2/b2}foo
    io:println(declarations[2]); // @output {http://sample.com/wso2/d2}foo

    var scopedDeclarations = testInnerScopeNamespaceDclr();
    io:println(scopedDeclarations[0]); // @output {http://ballerina.com/b}foo
    io:println(scopedDeclarations[1]); // @output {http://sample.com/wso2/a3}foo
    io:println(scopedDeclarations[2]); // @output {http://ballerina.com/b}foo

    io:println(testObjectLevelXML()); // @output <p:person xmlns:p="foo" xmlns:q="bar">hello</p:person>
}
