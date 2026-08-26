import ballerina/io;

public function main() {
    io:println(stringTemplateWithText1()); // @output `
    io:println(stringTemplateWithText2()); // @output \\
    io:println(stringTemplateWithText3()); // @output \{
    io:println(stringTemplateWithText4()); // @output {{
    io:println(stringTemplateWithText5()); // @output $\{
    io:println(stringTemplateWithText6()); // @output }
    io:println(stringTemplateWithText7()); // @output }}
    io:println(stringTemplateWithText8()); // @output }}}
    io:println(stringTemplateWithText9()); // @output Hello
    io:println(stringTemplateWithText10()); // @output Ballerina
    io:println(stringTemplateWithText11()); // @output Hello Ballerina
    io:println(stringTemplateWithText12()); // @output Ballerina !!!
    io:println(stringTemplateWithText13()); // @output Hello Ballerina !!!
    io:println(stringTemplateWithText14()); // @output Hello Smith, John
    io:println(stringTemplateWithText15()); // @output Hello Smith, John !!!
    io:println(stringTemplateWithText16()); // @output Count = 10
    io:println(stringTemplateWithText17()); // @output $\{count}
    io:println(stringTemplateWithText18()); // @output \\10
    io:println(stringTemplateWithText19()); // @output Path = \\root
    io:println(stringTemplateWithText20()); // @output Path = \\
    io:println(stringTemplateWithText21()); // @output Hello John Smith !!!
    io:println(stringTemplateWithText22()); // @output Hello John Smith !!!
    io:println(stringTemplateWithText23()); // @output Hello John Smith !!!
    io:println(emptyStringTemplate()); // @output
    io:println(concatStringTemplateExprs()); // @output FirstName: John. Second name: Doe
    io:println(stringTemplateEscapeChars()); // @output \n\r\b\t\f\'\"`\{\\
    io:println(stringTemplateStartsWithDollar()); // @output $$$$ A 8 B
    io:println(stringTemplateEndsWithDollar()); // @output A 8 B $$$$
    io:println(stringTemplateWithOnlyDollar()); // @output $$$$$$$$$
    io:println(stringTemplateDollarFollowedByEscapedLeftBrace()); // @output Hi $$$$\{ 25 End
    io:println(stringTemplateDollarFollowedByRightBrace()); // @output Hi $$$$}}} 25 End
    io:println(stringTemplateWithBraces()); // @output {{{{4 + 4}}}}}}}}}}
    io:println(complexStringTemplateExpr()); // @output Hello \n$\\$$\{Dummy\tText\`\\test Ballerina endText\\{{{{{innerStartText 7 }}!!!
    testStringTemplateExprWithUnionType();
    testNumericEscapes();
    testStringTemplateWithFiniteType();
}

function stringTemplateWithText1() returns string {
    return string `${"`"}`;
}

function stringTemplateWithText2() returns string {
    return string `\\`;
}

function stringTemplateWithText3() returns string {
    return string `\{`;
}

function stringTemplateWithText4() returns string {
    return string `{{`;
}

function stringTemplateWithText5() returns string {
    return string `$\{`;
}

function stringTemplateWithText6() returns string {
    return string `}`;
}

function stringTemplateWithText7() returns string {
    return string `}}`;
}

function stringTemplateWithText8() returns string {
    return string `}}}`;
}

function stringTemplateWithText9() returns string {
    return string `Hello`;
}

function stringTemplateWithText10() returns string {
    string name = "Ballerina";
    return string `${name}`;
}

function stringTemplateWithText11() returns string {
    string name = "Ballerina";
    return string `Hello ${name}`;
}

function stringTemplateWithText12() returns string {
    string name = "Ballerina";
    return string `${name} !!!`;
}

function stringTemplateWithText13() returns string {
    string name = "Ballerina";
    return string `Hello ${name} !!!`;
}

function stringTemplateWithText14() returns string {
    string firstName = "John";
    string lastName = "Smith";
    return string `Hello ${lastName}, ${firstName}`;
}

function stringTemplateWithText15() returns string {
    string firstName = "John";
    string lastName = "Smith";
    return string `Hello ${lastName}, ${firstName} !!!`;
}

function stringTemplateWithText16() returns string {
    int count = 10;
    return string `Count = ${count}`;
}

function stringTemplateWithText17() returns string {
    return string `$\{count}`;
}

function stringTemplateWithText18() returns string {
    int count = 10;
    return string `\\${count}`;
}

function stringTemplateWithText19() returns string {
    string path = "root";
    return string `Path = \\${path}`;
}

function stringTemplateWithText20() returns string {
    return string `Path = \\`;
}

function stringTemplateWithText21() returns string {
    string firstName = "John";
    string lastName = "Smith";
    return string `Hello ${firstName + " " + lastName} !!!`;
}

function stringTemplateWithText22() returns string {
    return string `Hello ${getFullName()} !!!`;
}

function stringTemplateWithText23() returns string {
    return string `Hello ${getFirstName() + " " + getLastName()} !!!`;
}

function getFullName() returns string {
    return getFirstName() + " " + getLastName();
}

function getFirstName() returns string {
    return "John";
}

function getLastName() returns string {
    return "Smith";
}

function emptyStringTemplate() returns string {
    return string ``;
}

function concatStringTemplateExprs() returns string {
    string s1 = "John";
    string s2 = "Doe";
    return string `FirstName: ${s1}.` + string ` Second name: ${s2}`;
}

function stringTemplateEscapeChars() returns string {
    return string `\n\r\b\t\f\'\"${"`"}\{\\`;
}

function stringTemplateStartsWithDollar() returns string {
    return string `$$$$ A ${4 + 4} B`;
}

function stringTemplateEndsWithDollar() returns string {
    return string `A ${4 + 4} B $$$$`;
}

function stringTemplateWithOnlyDollar() returns string {
    return string `$$$$$$$$$`;
}

function stringTemplateDollarFollowedByEscapedLeftBrace() returns string {
    return string `Hi $$$$\{ ${5 * 5} End`;
}

function stringTemplateDollarFollowedByRightBrace() returns string {
    return string `Hi $$$$}}} ${5 * 5} End`;
}

function stringTemplateWithBraces() returns string {
    return string `{{{{4 + 4}}}}}}}}}}`;
}

function complexStringTemplateExpr() returns string {
    string s1 = "Ballerina";
    return string `Hello \n$\\$$\{Dummy\tText\${"`"}\\test ${s1} endText\\{{{{{innerStartText ${4 + 3} }}!!!`;
}

public type Foo int|float|decimal|string|boolean;

function stringTemplateExprWithUnionType1() returns string {
    Foo foo = 4;
    return string `${foo}`;
}

function stringTemplateExprWithUnionType2() returns string {
    Foo foo = 4.5;
    return string `${foo}`;
}

function stringTemplateExprWithUnionType3() returns string {
    Foo foo = "chirans";
    return string `${foo}`;
}

function stringTemplateExprWithUnionType4() returns string {
    Foo foo = true;
    return string `${foo}`;
}

function testStringTemplateExprWithUnionType() {
    assertEquality("4", stringTemplateExprWithUnionType1());
    assertEquality("4.5", stringTemplateExprWithUnionType2());
    assertEquality("chirans", stringTemplateExprWithUnionType3());
    assertEquality("true", stringTemplateExprWithUnionType4());
}

function testNumericEscapes() {
    string s1 = string `\u{61}`;
    string s2 = string `\u{61}ppl\\u{65}`;
    string s3 = string `A \u{5C} B`;
    string s4 = string `A \\u{5C} B`;
    string s5 = string `"\u{D800}"`;
    string s6 = string `\u{DFFF}"\u{DFFF}"`;
    string s7 = string `"\u{12FFFF} ABC \u{DFFF} DEF \u{DAFF}"`;
    string s8 = string `\u{12FFFF} ABC \u{DFFFAAA} DEF \u{FFFFFFF}`;
    string s9 = string `\u{001B[`;
    string s10 = string `"\u{001B["`;

    assertEquality("\\u{61}", s1);
    assertEquality("[92,117,123,54,49,125]", s1.toBytes().toString());
    assertEquality("\\u{61}ppl\\\\u{65}", s2);
    assertEquality("A \\u{5C} B", s3);
    assertEquality("A \\\\u{5C} B", s4);
    assertEquality("\"\\u{D800}\"", s5);
    assertEquality("\\u{DFFF}\"\\u{DFFF}\"", s6);
    assertEquality("\"\\u{12FFFF} ABC \\u{DFFF} DEF \\u{DAFF}\"", s7);
    assertEquality("\\u{12FFFF} ABC \\u{DFFFAAA} DEF \\u{FFFFFFF}", s8);
    assertEquality("\\u{001B[", s9);
    assertEquality("\"\\u{001B[\"", s10);
}

type Type1 1|2|3;
type Type2 "int"|"string"|Type1;
type Type3 1|"hello"|Type2;
type Type4 2.0|3.0|5.0;

function testStringTemplateWithFiniteType() {
    Type1 a = 2;
    Type2 b = 3;
    Type2 c = "string";
    Type3 d = "hello";
    Type4 e = 2.0;

    string str = string `${a}`;
    assertEquality("2", str);
    str = string `${b}`;
    assertEquality("3", str);
    str = string `${c}`;
    assertEquality("string", str);
    str = string `${d}`;
    assertEquality("hello", str);
    str = string `${e}`;
    assertEquality("2.0", str);
}

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    panic error("expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}
