import ballerina/io;

public function main() returns error? {
    string a;
    string b;
    string c;
    string d;
    [a, b, c, d] = check testReturnError();
    io:println(a); // @output FOO:10.5
    io:println(b); // @output QUX:ERROR
    io:println(c); // @output BAZ:0.0
    io:println(d); // @output BAR:11.5
    io:println(testReturnAndThrowError()); // @output invalid name
}

public type InvalidNameError error<record { string companyName; }>;

function getQuote(string name) returns float|InvalidNameError {
    if name == "FOO" {
        return 10.5;
    } else if name == "BAR" {
        return 11.5;
    }
    return error InvalidNameError("invalid name", companyName = name);
}

function testReturnError() returns [string, string, string, string]|error {
    float quoteValue = check getQuote("FOO");
    string a = "FOO:" + quoteValue.toString();
    string b;
    var r = getQuote("QUX");
    if r is float {
        b = "QUX:" + r.toString();
    } else {
        b = "QUX:ERROR";
    }
    string c;
    var q = getQuote("BAZ");
    if q is float {
        c = "BAZ:" + quoteValue.toString();
    } else {
        quoteValue = 0.0;
        c = "BAZ:" + quoteValue.toString();
    }
    string d;
    var p = getQuote("BAR");
    if p is float {
        d = "BAR:" + p.toString();
    } else {
        quoteValue = 0.0;
        d = "BAR:ERROR";
    }
    return [a, b, c, d];
}

function testReturnAndThrowError() returns string {
    error? e = trap checkAndThrow();
    if e is error {
        return e.message();
    }
    return "OK";
}

function checkAndThrow() {
    var p = getQuote("BAZ");
    if p is float {
        _ = p;
    } else {
        panic p;
    }
}
