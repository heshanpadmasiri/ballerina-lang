import ballerina/io;

const PATH = "someLongPathSegment";

client class MyClient8 {
    @deprecated
    resource isolated function get .() returns string {
        return "response1";
    }

    @deprecated
    resource isolated function get A\u{0042}() returns int|string {
        return "response3";
    }

    @deprecated
    resource isolated function post AB/[string a]() returns string {
        return a;
    }
}

function testAccessingDeprecatedResource() {
    MyClient8 myClient = new;

    string a = myClient->/; // @error
    io:println(a);
    int|string b = myClient->/AB; // @error
    io:println(b);
    string c = myClient->/AB/[PATH].post; // @error
    io:println(c);
}
