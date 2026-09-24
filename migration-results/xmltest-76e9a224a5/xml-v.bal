import ballerina/io;
import ballerina/lang.'xml as xmllib;

xml globalXML = xml `<test><name>ballerina</name></test>`;

function testXML() returns [xml, map<string>, (string|error), xml] {
    xmlns "http://wso2.com/" as ns0;

    xmllib:Element x = <xmllib:Element> xml `<ns0:foo a="hello world" xmlns:ns1="http://ballerinalang.org/"><ns1:bar1>hello1</ns1:bar1><bar2>hello2</bar2></ns0:foo>`;
    map<string> attrMap = x.getAttributes();
    attrMap[ns0:b] = "active";
    return [x, x.getAttributes(), x.ns0:b, x/*];
}

function testXmlNavigation() returns [xml, xml, xml, xml, xml, xml, xml, xml] {
    xml x1 = xml `<name1><fname><foo>1</foo><bar>2</bar></fname><lname1><foo>3</foo><bar>4</bar></lname1></name1>`;
    xml x2 = xml `<name2><fname><foo>5</foo><bar>6</bar></fname><lname2><foo>7</foo><bar>8</bar></lname2></name2>`;
    xml x3 = x1 + x2 + xml `<foo>apple</foo>`;

    xml x4 = x3/*;
    xml x5 = x1/<fname>;
    xml x6 = x3/<fname>/<foo>[0];
    xml x7 = x3/<fname>/<foo>[1];
    xml x8 = x3/<fname>[1];
    xml x9 = x3/<fname>[0]/<foo>;
    xml x10 = x3/*/<bar>[0];
    xml x11 = x3/*/*;

    return [x4, x5, x6, x7, x8, x9, x10, x11];
}

function testDollarSignOnXMLLiteralTemplate() returns [xml, xml, xml] {
    string a = "hello";
    xml x1 = xml `<foo id="hello $${ 3 + 6 / 3}" >${a}</foo>`;
    xml x2 = xml `<foo id="hello $$${ 3 + 6 / 3}" >$${a}</foo>`;
    xml x3 = xml `<foo id="hello $$ ${ 3 + 6 / 3}" >$$ ${a}</foo>`;

    return [x1, x2, x3];
}

function testGetGlobalXML() returns xml {
    return globalXML;
}

function testXMLWithNumericEscapes() returns xml[10] {
    xml x1 = xml `\u{61}`;
    xml x2 = xml `\u{61}ppl\\u{65}`;
    xml x3 = xml `A \u{5C} B`;
    xml x4 = xml `A \\u{5C} B`;
    xml x5 = xml `"\u{D800}"`;
    xml x6 = xml `\u{DFFF}"\u{DFFF}"`;
    xml x7 = xml `"\u{12FFFF} ABC \u{DFFF} DEF \u{DAFF}"`;
    xml x8 = xml `\u{12FFFF} ABC \u{DFFFAAA} DEF \u{FFFFFFF}`;
    xml x9 = xml `\u{001B[`;
    xml x10 = xml `"\u{001B["`;

    return [x1, x2, x3, x4, x5, x6, x7, x8, x9, x10];
}

public function main() {
    var basic = testXML();
    io:println(basic[0]); // @output <ns0:foo xmlns:ns0="http://wso2.com/" xmlns:ns1="http://ballerinalang.org/" a="hello world" ns0:b="active"><ns1:bar1>hello1</ns1:bar1><bar2>hello2</bar2></ns0:foo>
    io:println(basic[1]); // @output {"{http://www.w3.org/2000/xmlns/}ns0":"http://wso2.com/","a":"hello world","{http://www.w3.org/2000/xmlns/}ns1":"http://ballerinalang.org/","{http://wso2.com/}b":"active"}
    io:println(basic[2]); // @output active
    io:println(basic[3]); // @output <ns1:bar1 xmlns:ns1="http://ballerinalang.org/">hello1</ns1:bar1><bar2>hello2</bar2>

    var navigation = testXmlNavigation();
    io:println(navigation[0]); // @output <fname><foo>1</foo><bar>2</bar></fname><lname1><foo>3</foo><bar>4</bar></lname1><fname><foo>5</foo><bar>6</bar></fname><lname2><foo>7</foo><bar>8</bar></lname2>apple
    io:println(navigation[1]); // @output <fname><foo>1</foo><bar>2</bar></fname>
    io:println(navigation[2]); // @output <foo>1</foo><foo>5</foo>
    io:println(navigation[3]); // @output
    io:println(navigation[4]); // @output
    io:println(navigation[5]); // @output <foo>1</foo><foo>5</foo>
    io:println(navigation[6]); // @output <bar>2</bar><bar>4</bar><bar>6</bar><bar>8</bar>
    io:println(navigation[7]); // @output <foo>1</foo><bar>2</bar><foo>3</foo><bar>4</bar><foo>5</foo><bar>6</bar><foo>7</foo><bar>8</bar>

    var dollarSigns = testDollarSignOnXMLLiteralTemplate();
    io:println(dollarSigns[0]); // @output <foo id="hello $5">hello</foo>
    io:println(dollarSigns[1]); // @output <foo id="hello $$5">$hello</foo>
    io:println(dollarSigns[2]); // @output <foo id="hello $$ 5">$$ hello</foo>

    io:println(testGetGlobalXML()); // @output <test><name>ballerina</name></test>

    var numericEscapes = testXMLWithNumericEscapes();
    io:println(numericEscapes.length()); // @output 10
    io:println(numericEscapes[0]); // @output \u{61}
    io:println(numericEscapes[1]); // @output \u{61}ppl\\u{65}
    io:println(numericEscapes[2]); // @output A \u{5C} B
    io:println(numericEscapes[3]); // @output A \\u{5C} B
    io:println(numericEscapes[4]); // @output "\u{D800}"
    io:println(numericEscapes[5]); // @output \u{DFFF}"\u{DFFF}"
    io:println(numericEscapes[6]); // @output "\u{12FFFF} ABC \u{DFFF} DEF \u{DAFF}"
    io:println(numericEscapes[7]); // @output \u{12FFFF} ABC \u{DFFFAAA} DEF \u{FFFFFFF}
    io:println(numericEscapes[8]); // @output \u{001B[
    io:println(numericEscapes[9]); // @output "\u{001B["
}
