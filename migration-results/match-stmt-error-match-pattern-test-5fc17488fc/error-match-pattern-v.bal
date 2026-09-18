import ballerina/io;
import ballerina/lang.value;

type CustomError1 distinct error;
type CustomError2 distinct error;
type CustomError3 error<record { int x; }>;
type CustomError4 error<record { int y; }>;
type MyError1 error<record { int x; }>;

const MSG = "Const Message";

function errorMatchPattern1(any|error e) returns string {
    match e {
        error("Message") => { return "match1"; }
        error(MSG) => { return "match2"; }
        error(_) => { return "match3"; }
    }
    return "No match";
}

function testErrorMatchPattern1() {
    io:println(errorMatchPattern1(error("Message"))); // @output match1
    io:println(errorMatchPattern1(error(MSG))); // @output match2
    io:println(errorMatchPattern1(error("Const Message"))); // @output match2
    io:println(errorMatchPattern1(error("Const Message1"))); // @output match3
    io:println(errorMatchPattern1("Message1")); // @output No match
}

function errorMatchPattern2(error e) returns string {
    match e { error(var a) => { return "match1"; } }
    return "No match";
}

function testErrorMatchPattern2() {
    io:println(errorMatchPattern2(error("Message"))); // @output match1
}

function errorMatchPattern3(error e) returns string {
    match e { error(var a) if a is string => { return <string>a; } }
    return "No match";
}

function testErrorMatchPattern3() {
    io:println(errorMatchPattern3(error("Message"))); // @output Message
}

function errorMatchPattern4(error e) returns string {
    match e {
        error("Message1", error("Message2")) => { return "match1"; }
        error(MSG, error(MSG)) => { return "match2"; }
        error(var a, error("Message")) => { return "match3"; }
    }
    return "No match";
}

function testErrorMatchPattern4() {
    io:println(errorMatchPattern4(error("Message1", error("Message2")))); // @output match1
    io:println(errorMatchPattern4(error(MSG, error(MSG)))); // @output match2
    io:println(errorMatchPattern4(error("Message2", error("Message")))); // @output match3
}

function errorMatchPattern5(error e) returns string {
    match e { error("Message1", var a) => { return "match1"; } }
    return "No match";
}

function testErrorMatchPattern5() {
    io:println(errorMatchPattern5(error("Message1", error("Message1")))); // @output match1
    io:println(errorMatchPattern5(error("Message2"))); // @output No match
}

function errorMatchPattern6(error e) returns string {
    match e {
        error("Message1", var a) if a is error && (<error>a).message() == "Old Message" => { return "match"; }
        error("Message1", var a) => { return (<error>a).message(); }
    }
    return "No match";
}

function testErrorMatchPattern6() {
    io:println(errorMatchPattern6(error("Message1", error("Message2")))); // @output Message2
    io:println(errorMatchPattern6(error("Message1", error("Old Message")))); // @output match
}

function errorMatchPattern7(error e) returns string {
    match e {
        error("Message1", error("Message2"), c1 = 200) => { return "match1"; }
        error("Message1", error("Message2"), c1 = 2) | error("Message1", error("Message2"), c1 = 4) => {
            return "match2";
        }
    }
    return "No match";
}

function testErrorMatchPattern7() {
    io:println(errorMatchPattern7(error("Message1", error("Message2"), c1 = 200))); // @output match1
    io:println(errorMatchPattern7(error("Message1", error("Message2"), c1 = 2))); // @output match2
    io:println(errorMatchPattern7(error("Message1", error("Message2"), c1 = 4))); // @output match2
    io:println(errorMatchPattern7(error("Message1", error("Old Message")))); // @output No match
}

function errorMatchPattern8(error e) returns string {
    match e {
        error MyError1 ("Message") => { return "match1"; }
        error MyError1 ("Message1", x = 2) => { return "match2"; }
        error MyError1 (x = 4) => { return "match3"; }
        error MyError1 (a = 2) => { return "match4"; }
    }
    return "No match";
}

function testErrorMatchPattern8() {
    io:println(errorMatchPattern8(error MyError1("Message", x = 2))); // @output match1
    io:println(errorMatchPattern8(error MyError1("Message1", x = 2))); // @output match2
    io:println(errorMatchPattern8(error MyError1("Message1", x = 4))); // @output match3
    io:println(errorMatchPattern8(error MyError1("Message1", x = 1))); // @output No match
}

function errorMatchPattern9(error e) returns string {
    match e {
        error MyError1() => { return "match1"; }
        error () => { return "match2"; }
    }
    return "No match";
}

function testErrorMatchPattern9() {
    io:println(errorMatchPattern9(error MyError1("Message", x = 2))); // @output match1
    io:println(errorMatchPattern9(error("Message1"))); // @output match2
}

function testErrorMatchPattern10() {
    any|error e = error("Message1", error("Message3"));
    string result = "Not Matched";
    match e {
        error("Message1", error("Message2")) => { result = "Matched"; }
        _ => { result = "Default"; }
    }
    io:println(result); // @output Not Matched
}

function testErrorMatchPattern11() {
    any|error e = error("Message1", det1 = "detail1", det2 = "detail2");
    string result = "Not Matched";
    match e {
        error("Message1", det1 = var det1, det2 = var det2) => { result = "Matched"; }
        _ => { result = "Default"; }
    }
    io:println(result); // @output Matched
}

function testErrorMatchPattern12() {
    any|error e = error("Message1", det1 = "detail1", det3 = "detail3");
    string result = "Not Matched";
    match e {
        error("Message1", det1 = var det1, det2 = var det2) => { result = "Matched"; }
        _ => { result = "Default"; }
    }
    io:println(result); // @output Not Matched
}

function testErrorMatchPattern13() {
    any|error e = error("Message1", det1 = "detail1", det3 = "detail3");
    string result = "Not Matched";
    match e {
        error("Message1", det1 = var det1, ...var rest) => {
            if rest["det3"] == "detail3" { result = "Matched"; }
        }
        _ => { result = "Default"; }
    }
    io:println(result); // @output Matched
}

function testErrorMatchPattern14() {
    any|error e = error("Message1");
    string result = "Not Matched";
    match e {
        error("Message1", det1 = var det1) => { result = "Matched with incorrect error"; }
        error("Message1") => { result = "Matched"; }
    }
    io:println(result); // @output Matched
}

function errorMatchPattern15(error x) returns string {
    match x {
        error("Error One", data = [11, 12]) => { return "Matched with Error One"; }
        error("Error One", data = {a: "A", b: "B"}) => { return "Some Other Error"; }
        error("Error Two", data = [11, {a: "A", b: "B"}]) => { return "Matched with Error Two"; }
    }
    return "Default";
}

function testErrorMatchPattern15() {
    io:println(errorMatchPattern15(error("Error One", data = [11, 12]))); // @output Matched with Error One
    io:println(errorMatchPattern15(error("Error Two", data = [11, {a: "A", b: "B"}]))); // @output Matched with Error Two
}

function errorDetails(any|error x) returns string {
    match x {
        error(var m, var c, code1 = var d, code2 = var e) => {
            map<any|error> details = {};
            if !(d is ()) { details["code1"] = d; }
            if !(e is ()) { details["code2"] = e; }
            return "message:" + m + " cause:" + (c is () ? "No Cause" : (<error>c).message()) + " details:" + details.toString();
        }
    }
    return "Default";
}

function errorRecordDetails(any|error x) returns string {
    match x {
        error(var m, var c, code1 = {a: var d, ...var e}) => {
            value:Cloneable x1 = d;
            value:Cloneable x2 = e;
            map<any|error> details = {};
            if !(x1 is ()) { details["a"] = x1; }
            if !(x2 is ()) { details["rest"] = x2; }
            return "message:" + m + " cause:" + (c is () ? "No Cause" : (<error>c).message()) + " details:" + details.toString();
        }
    }
    return "Default";
}

function errorArrayDetails(any|error x) returns string {
    match x {
        error(var m, var c, code1 = [var d, ...var e]) => {
            value:Cloneable x1 = d;
            value:Cloneable x2 = e;
            map<any|error> details = {};
            if !(x1 is ()) { details["a"] = x1; }
            if !(x2 is ()) { details["rest"] = x2; }
            return "message:" + m + " cause:" + (c is () ? "No Cause" : (<error>c).message()) + " details:" + details.toString();
        }
    }
    return "Default";
}

function errorRestDetails(any|error x) returns string {
    match x {
        error(var m, var c, code1 = var d, ...var e) => {
            value:Cloneable x1 = d;
            value:Cloneable x2 = e;
            map<any|error> details = {};
            if !(x1 is ()) { details["a"] = x1; }
            if !(x2 is ()) { details["rest"] = x2; }
            return "message:" + m + " cause:" + (c is () ? "No Cause" : (<error>c).message()) + " details:" + details.toString();
        }
    }
    return "Default";
}

function testErrorMatchPattern16() {
    io:println(errorDetails(error("Error"))); // @output message:Error cause:No Cause details:{}
    io:println(errorDetails(error("Error", error("Invalid Op")))); // @output message:Error cause:Invalid Op details:{}
    io:println(errorDetails(error("Error", error("Invalid Op"), code1 = 12))); // @output message:Error cause:Invalid Op details:{"code1":12}
    io:println(errorDetails(error("Error", code1 = 12, code2 = {a: "A", b: [1, 2]}))); // @output message:Error cause:No Cause details:{"code1":12,"code2":{"a":"A","b":[1,2]}}
    io:println(errorRecordDetails(error("Error", code1 = {a: "A", b: [1, 2]}))); // @output message:Error cause:No Cause details:{"a":"A","rest":{"b":[1,2]}}
    io:println(errorArrayDetails(error("Error", code1 = [12, "A", 10.5, 1]))); // @output message:Error cause:No Cause details:{"a":12,"rest":["A",10.5,1]}
    io:println(errorRestDetails(error("Error", error("Invalid Op"), code1 = [12, "A", 10.5, 1], code2 = {a: "A", b: [1, 2]}))); // @output message:Error cause:Invalid Op details:{"a":[12,"A",10.5,1],"rest":{"code2":{"a":"A","b":[1,2]}}}
}

function errorMatchPattern20(any|error? e) returns string {
    match e {
        var errorA if e is CustomError1 => { return "match1"; }
        var errorB if e is CustomError2 => { return "match2"; }
        var errorB if e is CustomError3 => { return "match3"; }
        var errorB if e is CustomError4 => { return "match4"; }
    }
    return "no match";
}

function testErrorMatchPattern17() {
    io:println(errorMatchPattern20(error CustomError1("error: CustomError1"))); // @output match1
    io:println(errorMatchPattern20(error CustomError2("error: CustomError2"))); // @output match2
    io:println(errorMatchPattern20(error CustomError3("error: CustomError3", x = 1))); // @output match3
    io:println(errorMatchPattern20(error CustomError4("error: CustomError4", y = 2))); // @output match4
    io:println(errorMatchPattern20(error("error"))); // @output no match
    io:println(errorMatchPattern20(())); // @output no match
    io:println(errorMatchPattern20("string")); // @output no match
}

public function main() {
    testErrorMatchPattern1();
    testErrorMatchPattern2();
    testErrorMatchPattern3();
    testErrorMatchPattern4();
    testErrorMatchPattern5();
    testErrorMatchPattern6();
    testErrorMatchPattern7();
    testErrorMatchPattern8();
    testErrorMatchPattern9();
    testErrorMatchPattern10();
    testErrorMatchPattern11();
    testErrorMatchPattern12();
    testErrorMatchPattern13();
    testErrorMatchPattern14();
    testErrorMatchPattern15();
    testErrorMatchPattern16();
    testErrorMatchPattern17();
}
