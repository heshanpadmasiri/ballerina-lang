import ballerina/io;

type Message record { string a; };
type ErrorData record {
    string a?;
    error err?;
    map<string> m?;
    string message?;
    error cause?;
};
type ErrorData2 record {
    string a?;
    error err?;
    map<string | boolean> m?;
    string message?;
    error cause?;
    boolean fatal?;
};

function testBasicErrorMatch() returns string {
    error<ErrorData> err1 = error("Error Code", message = "Msg");
    match err1 {
        var error (reason, message = m) => {
            return <string> reason + ":" + <string> checkpanic m;
        }
    }
    return "Default";
}

function testErrorRestParamMatch(int errorNo) returns string {
    error err1 = selectError(errorNo);
    match err1 {
        var error (reason, message = m, x = x) => { return toString(x); }
        var error (reason, message = m, blah = x, ...rest) => { return <string> reason + toString(rest); }
        var error (reason, message = m) => { return <string> checkpanic m; }
        var error (reason, x = x) => { return toString(x); }
    }
    return "Default";
}

function selectError(int errorNo) returns error {
    error<ErrorData> err0 = error("Error Code", message = "Msg of error-0");
    [string, int] x = ["x", 1];
    error err1 = error("Error Code", x = x);
    error err2 = error("Error Code", message = "Hello", x = "x");
    error err3 = error("Error Code", message = "message", blah = "bb", foo = "foo");
    match errorNo {
        0 => { return err0; }
        1 => { return err1; }
        2 => { return err2; }
        3 => { return err3; }
    }
    return error("Just Error");
}

function testBasicErrorMatch2() returns string {
    error<ErrorData> err1 = error("Error Code", message = "Msg");
    [string, map<any>] | error t1 = err1;
    match t1 {
        var [reason, detail] => { return "Matched with tuple : " + reason + " " + toString(detail); }
        var error (reason, message = message) => {
            return "Matched with error : " + <string> reason + " {\"message\":\"" + <string> checkpanic message + "\"}";
        }
    }
    return "Default";
}

function testBasicErrorMatch3() returns string {
    error err1 = error("Error Code");
    [string, map<any>] | error t1 = err1;
    match t1 {
        var [reason, detail] => { return "Matched with tuple : " + reason + " " + toString(detail); }
        var error (reason) => { return "Matched with error : " + <string> reason; }
    }
    return "Default";
}

type Foo record {|
    boolean fatal;
    string message?;
    error cause?;
|};
type ER1 error<Foo>;

function testBasicErrorMatch4() returns string[] {
    ER1 er1 = error("Error 1", fatal = true, message = "message");
    error er2 = error("Error 2", message = "It's fatal", fatal = "fatal string");
    return [foo(er1), foo(er2)];
}

function foo(ER1 | error t1) returns string {
    match t1 {
        var error (_, fatal = fatal, message = message) => {
            if fatal is boolean { return "Matched with boolean : " + fatal.toString(); }
            else if message is string { return "Matched with string : " + message; }
            else { return "Matched with fatal as Nil"; }
        }
    }
    return "Default";
}

function testBasicErrorMatch5() returns string[] {
    Foo f = {fatal: true};
    error err1 = error("Error Code 1");
    error err2 = error("Error Code 1", message = "Something Wrong");
    Foo | error fe1 = err1;
    Foo | error fe2 = err2;
    return [foo2(f), foo2(fe1), foo2(fe2), foo3(fe1), foo3(fe2)];
}

function foo2(any | error f) returns string {
    match f {
        var {fatal} => { return "Matched with a record : " + toString(fatal); }
        var error (reason) => { return "Matched with an error : " + <string> reason; }
    }
    return "Default";
}

function foo3(any | error f) returns string {
    match f {
        var {fatal} => { return "Matched with a record : " + toString(fatal); }
        var error (reason) => { return "Matched with an error 1: " + <string> reason; }
        var error (reason, message = message) => {
            return "Matched with an error : " + <string> reason + ", message = " + <string> checkpanic message;
        }
    }
    return "Default";
}

function testBasicErrorMatch6() returns string[] {
    map<string> m = {key: "value"};
    var mRes = trap panik();
    return [foo4(m.get("key")), foo4(mRes)];
}

function panik() returns string {
    error e = error("Just Panic", message = "Bit of detail");
    panic e;
}

function foo4(any|error a) returns string {
    match a {
        "value" => { return "Matched with string"; }
        var error (reason, message = message) => {
            return "Matched with an error: reason = " + <string> reason + ", message = " + <string> checkpanic message;
        }
    }
    return "Default";
}

function testErrorWithUnderscore() returns string[] {
    error err1 = error("Error One");
    return [foo5(err1)];
}

function foo5(any|error e) returns string {
    match e {
        var [a, b] => { return "Matched with tuple var"; }
        var {a, b} => { return "Matched with record var"; }
        var error (reason) => { return "Matched with error reason = " + <string> reason; }
        var x => {
            if x is any { return "Matched nothing : " + <string>x; }
            else { return "Matched nothing"; }
        }
    }
}

function testBasicErrorMatch7() returns string[] {
    Foo f = {fatal: true};
    error err1 = error("Error Code 1");
    error err2 = error("Error Code 1", message = "Something Wrong");
    Foo | error fe1 = err1;
    Foo | error fe2 = err2;
    return [foo6(f), foo6(fe1), foo6(fe2)];
}

function foo6(any | error f) returns string {
    match f {
        var {fatal} => { return "Matched with a record : " + toString(fatal); }
        var error (reason, message = message) => {
            return "Matched with an error : " + <string> reason + <string> checkpanic message;
        }
    }
    return "Default";
}

function testFiniteTypedReasonVariable() returns string[] {
    error<ErrorData2> err1 = error("Error One", message = "msgOne", fatal = true);
    error<ErrorData2> err2 = error("Error Three", message = "msgTwo", fatal = false);
    error<ErrorData2> | error<ErrorData2> err3 = err1;
    error<ErrorData2> | error<ErrorData2> err4 = err2;
    return [matching(err3), matching(err4)];
}

function matching(error<ErrorData2> | error<ErrorData2> a) returns string {
    match a {
        var error (reason, message = message, fatal = fatal) => {
            return "reason = " + <string> reason + ", message = " + <string> checkpanic message + ", fatal = " + (<boolean> checkpanic fatal ? "true" : "false");
        }
        var x => { return "Failed"; }
    }
}

function testErrorMatchPattern() returns string {
    error<ErrorData> err1 = error("Error Code", message = "Msg");
    match err1 {
        error (var reason, message = var m, ...var rest) => { return <string> reason + ":" + <string> checkpanic m; }
        var error (reason) => { return <string> reason; }
    }
    return "Default";
}

function testErrorConstReasonMatchPattern() returns string {
    error<ErrorData> err1 = error("Error Code", message = "Msg");
    match err1 {
        error ("Error Code", message = var m, ...var rest) => { return "Const reason" + ":" + <string> checkpanic m; }
        var error (reason) => { return <string> reason; }
    }
    return "Default";
}

type ER error<ErrorData>;
function testIndirectErrorMatchPattern() returns string {
    ER err1 = error("Error Code", message = "Msg");
    match err1 {
        error ER (message = var m, ...var rest) => { return <string> checkpanic m; }
        error(var reason, ...var rest) => { return <string> reason; }
    }
    return "Default";
}

public function testErrorMatchWihtoutReason() returns string {
    string|error se = error("test reason", message="error detail message");
    match se {
        error(message = var message) => { return <string> checkpanic message; }
        var value => { return "default match"; }
    }
}

function toString(any|error val) returns string => val is error ? val.toString() : val.toString();

public function main() {
    io:println(testBasicErrorMatch()); // @output Error Code:Msg
    io:println(testBasicErrorMatch2()); // @output Matched with error : Error Code {"message":"Msg"}
    io:println(testBasicErrorMatch3()); // @output Matched with error : Error Code
    string[] basic4 = testBasicErrorMatch4();
    io:println(basic4[0]); // @output Matched with boolean : true
    io:println(basic4[1]); // @output Matched with string : It's fatal
    string[] basic5 = testBasicErrorMatch5();
    io:println(basic5[0]); // @output Matched with a record : true
    io:println(basic5[1]); // @output Matched with an error : Error Code 1
    io:println(basic5[2]); // @output Matched with an error : Error Code 1
    io:println(basic5[3]); // @output Matched with an error 1: Error Code 1
    io:println(basic5[4]); // @output Matched with an error 1: Error Code 1
    string[] basic6 = testBasicErrorMatch6();
    io:println(basic6[0]); // @output Matched with string
    io:println(basic6[1]); // @output Matched with an error: reason = Just Panic, message = Bit of detail
    string[] underscore = testErrorWithUnderscore();
    io:println(underscore[0]); // @output Matched with error reason = Error One
    string[] basic7 = testBasicErrorMatch7();
    io:println(basic7[0]); // @output Matched with a record : true
    io:println(basic7[1]); // @output Default
    io:println(basic7[2]); // @output Matched with an error : Error Code 1Something Wrong
    string[] finite = testFiniteTypedReasonVariable();
    io:println(finite[0]); // @output reason = Error One, message = msgOne, fatal = true
    io:println(finite[1]); // @output reason = Error Three, message = msgTwo, fatal = false
    io:println(testErrorRestParamMatch(0)); // @output Error Code{}
    io:println(testErrorRestParamMatch(1)); // @output ["x",1]
    io:println(testErrorRestParamMatch(2)); // @output x
    io:println(testErrorRestParamMatch(3)); // @output Error Code{"foo":"foo"}
    io:println(testErrorMatchPattern()); // @output Error Code:Msg
    io:println(testErrorConstReasonMatchPattern()); // @output Const reason:Msg
    io:println(testIndirectErrorMatchPattern()); // @output Msg
    io:println(testErrorMatchWihtoutReason()); // @output error detail message
}
