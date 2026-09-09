type Error error<map<string>>;

function testMissingParamsNegative() {
    error e1 = error(); // @error
    error e2 = error(2); // @error
    error e3 = error(error("Message")); // @error
    error e4 = error("M1", "M2"); // @error
    error e5 = error("M", error("M1"), "c = 2000"); // @error

    error e6 = error Error(); // @error
    error e7 = error Error(2); // @error
    error e8 = error Error(error("Message")); // @error
    error e9 = error Error("M1", "M2"); // @error
    error e10 = error Error("M", error("M1"), "c = 2000"); // @error
}

type MyError1 error<map<string>>;
type MyError2 error<map<string>>;
function testErrorTypeRefNegative() {
    MyError1 me1 = error MyError("Message"); // @error
    MyError2 me2 = error MyError2("Message", c = 2); // @error
}

type ErrorIJ error<record { int i; string j; }>;
ErrorIJ e = error("msg", i = 1, j = 2, k = error("msg")); // @error @error @error
ErrorIJ e2 = error("msg", i = 1); // @error

type ErrorA error;
type ErrorB error<map<string>>;

ErrorA|ErrorB u0 = error ErrorA("msg");
ErrorA|ErrorB u1 = error ErrorA("msg", a = "a");
ErrorA|ErrorB u2 = error("msg"); // @error
ErrorA|ErrorB u3 = error("msg", a = "a"); // @error
ErrorA|ErrorB u4 = error("msg", a = 22);

readonly|ErrorA u5 = error("msg");
readonly|ErrorA u6 = error("msg", a = "a");
readonly|ErrorA u7 = error("msg", a = 22);

type ErrorU1 MyError1|MyError2;
type ErrorU2 MyError1|map<string>;
type ErrorU3 map<int>|map<Blah>|map<string>; // @error

error uc1 = error ErrorU1("Hello"); // @error
error uc2 = error ErrorU2("Hello"); // @error
error uc3 = error ErrorU3("Hello"); // @error

int|string uc4 = error ErrorA("msg"); // @error
int|string b = error("err"); // @error

type ErrorData1 record {
    string errorCode;
    Application application;
};

type ErrorData2 record {
    string errorCode;
    Application[] application;
};

type Application record{|
        string id;
        User user;
|};

type User record {|
    string name;
|};

type StringType string|int;

type ErrorR1 error<ErrorData1>;
type ErrorR2 error<ErrorData2>;
type ErrorR3 error<map<StringType>>;

function customError() {
    ErrorR1 er1 = error ErrorR1("Custom error", errorCode = "104", application = {}); // @error @error
    ErrorR1 er2 = error ErrorR1("Custom error", errorCode = "104", application = {id : "1", user: {}}); // @error
    ErrorR1 er3 = error ErrorR1("Custom error", errorCode = "104", application = ); // @error
    ErrorR2 er4 = error ErrorR2("Custom error", errorCode = "104", application = [{}]); // @error @error
    ErrorR3 er5 = error ErrorR3("Custom error", errorCode = "104", application = {}); // @error
}
