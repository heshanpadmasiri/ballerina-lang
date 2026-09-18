import ballerina/io;

// @args ["error", "1"]
public function main(string s, int code) returns error? {
    io:println("error? returning main invoked"); // @output error? returning main invoked
    match s {
        "error" => {
            error e = error("generic error", statusCode = code);
            return e; // @panic
        }
        "nil" => {
            return;
        }
        "user_def_error" => {
            UserDefError e = error UserDefError(ERR_REASON, message = "error message", statusCode = code);
            return e;
        }
    }
    panic error("expected to have returned within match");
}

const ERR_REASON = "const error reason";

type ErrorRecord record {
    string message;
    int statusCode;
    error cause?;
};

type UserDefError distinct error<ErrorRecord>;
