import ballerina/io;

function testInt1() returns int {
    int add = 0;
    int[] fa = [-5, 2, 4, 5, 7, -8, -3, 2];
    fa.forEach(function (int i) { add = add + i; });
    return add;
}

function testFloat1() returns float {
    float fadd = 0.0;
    float[] fa = [1.1, 2.2, -3.3, 4.4, 5.5];
    fa.forEach(function (float i) { fadd = fadd + i; });
    return fadd;
}

function testBasicArray1(string[] values) returns string {
    string str1 = "";
    values.'map(function (string x) returns [string, string] {
        string up = x.toUpperAscii();
        string lower = x.toLowerAscii();
        return [up, lower];
    }).forEach(function ([string, string] value) {
        var [up, lower] = value;
        str1 = str1 + " " + up + ":" + lower;
    });
    return str1.trim();
}

function testBasicArray2(string[] values) returns string {
    string str1 = "";
    int index = 0;
    values.'map(function (string s) returns string {
        string value = index.toString() + s;
        index += 1;
        return value;
    }).forEach(function (string s) { str1 = str1 + s + " "; });
    return str1.trim();
}

function testBasicMap1() returns [int, string[]] {
    map<string> m = {a: "A", b: "B", c: "C", d: "D", e: "E"};
    int count = 0;
    string[] values = m.keys().'map(function (string key) returns string {
        count += 10;
        var k = key;
        return k.toLowerAscii();
    }).filter(function (string v) returns boolean {
        if (v == "a" || v == "e" && count != 0) {
            count += 10;
            return true;
        }
        return false;
    });
    return [count, values];
}

function testBasicMap2() returns [int, string, map<string>] {
    int count = 0;
    string str = "start";
    map<string> m = {a: "A", b: "B", c: "C", d: "D", e: "E"};
    map<string> modified = m.entries().'map(function ([string, string] tuple) returns [string, string] {
        var [key, value] = tuple;
        str = str + "-" + key + " : " + value;
        count += 10;
        return [key, value];
    }).filter(function ([string, string] v) returns boolean {
        var [k, _] = v;
        if (k == "a" || k == "e") {
            count += 10;
            return true;
        }
        return false;
    }).'map(function ([string, string] v) returns string {
        var [v1, v2] = v;
        count += 10;
        return v1 + v2;
    });
    str = str + "-end";
    count += 1;
    return [count, str, modified];
}

function xmlTest() returns [string, xml] {
    string str = "start";
    xml xdata = xml `<p:person xmlns:p="foo" xmlns:q="bar">
        <p:name>bob</p:name>
        <p:address><p:city>NY</p:city><q:country>US</q:country></p:address>
        <q:ID>1131313</q:ID>
    </p:person>`;
    int index = 0;
    xml m = (xdata/<*>[1]/<*>).'map(function (xml x) returns xml {
        index += 1;
        str = str + "-" + index.toString();
        return x;
    });
    str = str + "-end";
    return [str, m];
}

type Student record { string fname; int age; };

function recordTest() returns [int, string[]] {
    boolean status = true;
    int randomNum = 0;
    Student[] studentArr = [{fname: "aa", age: 30}, {fname: "bb", age: 20}, {fname: "cc", age: 24}];
    _ = studentArr.filter(function (Student stu) returns boolean {
        randomNum += 2;
        return status && stu.age < 25;
    }).length();
    string[] names = studentArr.'map(function (Student stu) returns string { return stu.fname; });
    randomNum += 10;
    return [randomNum, names];
}

function testIgnoredValue() returns string {
    string str = "The start-";
    string[] s = ["abc", "cde", "pqr", "xy"];
    _ = s.filter(function (string s1) returns boolean {
        return s1.length() == 3;
    }).'map(function (string s1) returns string {
        str = str + " hello " + s1 + " :) bye :) ";
        return str + s1;
    });
    str = str + "-The end";
    return str.trim();
}

function testInExpression() returns [string, int] {
    string str = "";
    string[] strArr = ["abc", "cde", "pqr", "xyz"];
    float[] floatArr = [1.1, -2.2, 3.3, 4.4];
    var x = function (any a) {
        var s = <string>a;
        str = s;
        strArr[4] = "mno";
    };
    x("total count " + strArr.filter(function (string str1) returns boolean {
        strArr[5] = "stu";
        return str1.length() == 3;
    }).length().toString());
    int i = strArr.length() + floatArr.length();
    return [str, i];
}

function testInStatement() returns int {
    map<string> m = {a: "abc", b: "cd", c: "pqr"};
    int count = 2;
    if (5 > m.filter(function (string value) returns boolean {
        count *= 2;
        var v = value;
        return v.length() == 3 && count % 2 == 0;
    }).length()) {
        return count;
    }
    return 0;
}

function testWithComplexJson() returns json[] {
    json j = {"address_components": [
        {"long_name": "1823", "short_name": "1823", "types": ["street_number"]},
        {"long_name": "Bonpland", "short_name": "Bonpland", "types": ["street_number"]},
        {"long_name": "Palermo", "short_name": "Palermo", "types": ["sublocality_level_1", "sublocality", "political"]},
        {"long_name": "Comuna 14", "short_name": "Comuna 14", "types": ["administrative_area_level_2", "political"]},
        {"long_name": "Buenos Aires", "short_name": "CABA", "types": ["administrative_area_level_1", "political"]},
        {"long_name": "Argentina", "short_name": "AR", "types": ["country", "political"]},
        {"long_name": "C1414", "short_name": "C1414", "types": ["postal_code"]},
        {"long_name": "CMW", "short_name": "CMW", "types": ["postal_code_suffix"]}
    ]};
    json[] filteredResults = [];
    string filterFrom = "street_number";
    json[] addressComp = <json[]> checkpanic j.address_components;
    int index = 0;
    addressComp.filter(function (json comp) returns boolean {
        json[] compTypes = <json[]> checkpanic comp.types;
        return compTypes.filter(function (json compType) returns boolean {
            return compType.toString() == filterFrom;
        }).length() > 0;
    }).forEach(function (json k) {
        filteredResults[index] = k;
        index += 1;
    });
    return filteredResults;
}

function testWithComplexXML() returns ([int, string][]) {
    xml bookstore = xml `<bookstore>
        <book category="cooking"><title lang="en">Everyday Italian</title><author>Giada De Laurentiis</author><year>2005</year><price>30.00</price></book>
        <book category="children"><title lang="en">Harry Potter</title><author>J. K. Rowling</author><year>2005</year><price>29.99</price></book>
        <book category="web"><title lang="en">XQuery Kick Start</title><author>James McGovern</author><author>Per Bothner</author><author>Kurt Cagle</author><author>James Linn</author><author>Vaidyanathan Nagarajan</author><year>2003</year><price>49.99</price></book>
        <book category="web" cover="paperback"><title lang="en">Learning XML</title><author>Erik T. Ray</author><year>2003</year><price>39.95</price></book>
    </bookstore>`;
    [int, string][] titles = [];
    int count = 0;
    (bookstore/<book>).forEach(function (xml ent) {
        titles[count] = [count, (ent/<title>/*).toString()];
        count += 1;
    });
    return titles;
}

type Balance record { string asset; string free; string locked; };
type Wallet record { Balance[] balances; };

function testWithComplexRecords() returns Balance[] {
    Balance bal1 = {asset: "BTC", free: "12", locked: "8"};
    Balance bal2 = {asset: "LTC", free: "2", locked: "1"};
    Balance bal3 = {asset: "BTC", free: "20", locked: "3"};
    Wallet wal = {balances: [bal1, bal2, bal3]};
    string BTC = "BTC";
    return wal.balances.filter(function (Balance b) returns boolean { return b.asset == BTC; });
}

function multipleIterableOps() returns string[] {
    string[] strArr = [];
    int index = 0;
    string currency = "USD";
    var closure = function (string key) { strArr[index] = currency; index += 1; };
    closure("key");
    map<int> currencies = {USD: 318, EUR: 322, GBP: 400};
    currencies.keys().forEach(function (string key) { strArr[index] = key; index += 1; });
    currencies.entries().forEach(function ([string, int] pair) {
        var [x, _] = pair;
        strArr[index] = x;
        index += 1;
    });
    currencies.entries().forEach(function ([string, int] pair) { strArr[index] = currency; });
    return strArr;
}

public function main() {
    io:println(testInt1()); // @output 4
    io:println(testFloat1()); // @output 9.9
    string[] values = ["Hello", "World..!", "I", "am", "Ballerina.!!!"];
    io:println(testBasicArray1(values)); // @output HELLO:hello WORLD..!:world..! I:i AM:am BALLERINA.!!!:ballerina.!!!
    io:println(testBasicArray2(values)); // @output 0Hello 1World..! 2I 3am 4Ballerina.!!!
    [int, string[]] basicMap1 = testBasicMap1();
    io:println(basicMap1[0]); // @output 70
    io:println(basicMap1[1]); // @output ["a","e"]
    [int, string, map<string>] basicMap2 = testBasicMap2();
    io:println(basicMap2[0]); // @output 91
    io:println(basicMap2[1]); // @output start-a : A-b : B-c : C-d : D-e : E-end
    io:println(basicMap2[2]); // @output {"a":"aA","e":"eE"}
    [string, xml] xmlResult = xmlTest();
    io:println(xmlResult[0]); // @output start-1-2-end
    io:println(xmlResult[1]); // @output <p:city xmlns:p="foo">NY</p:city><q:country xmlns:q="bar">US</q:country>
    [int, string[]] recordResult = recordTest();
    io:println(recordResult[0]); // @output 16
    io:println(recordResult[1]); // @output ["aa","bb","cc"]
    io:println(testIgnoredValue()); // @output The start- hello abc :) bye :)  hello cde :) bye :)  hello pqr :) bye :) -The end
    [string, int] expressionResult = testInExpression();
    io:println(expressionResult[0]); // @output total count 4
    io:println(expressionResult[1]); // @output 10
    io:println(testInStatement()); // @output 16
    json[] jsonResult = testWithComplexJson();
    io:println(jsonResult.length()); // @output 2
    io:println(jsonResult[0]); // @output {"long_name":"1823","short_name":"1823","types":["street_number"]}
    io:println(jsonResult[1]); // @output {"long_name":"Bonpland","short_name":"Bonpland","types":["street_number"]}
    [int, string][] xmlTitles = testWithComplexXML();
    io:println(xmlTitles.length()); // @output 4
    io:println(xmlTitles[0]); // @output [0,"Everyday Italian"]
    io:println(xmlTitles[1]); // @output [1,"Harry Potter"]
    io:println(xmlTitles[2]); // @output [2,"XQuery Kick Start"]
    io:println(xmlTitles[3]); // @output [3,"Learning XML"]
    Balance[] balanceResult = testWithComplexRecords();
    io:println(balanceResult.length()); // @output 2
    io:println(balanceResult[0]); // @output {"asset":"BTC","free":"12","locked":"8"}
    io:println(balanceResult[1]); // @output {"asset":"BTC","free":"20","locked":"3"}
    io:println(multipleIterableOps()); // @output ["USD","USD","EUR","GBP","USD","EUR","GBP","USD"]
}
