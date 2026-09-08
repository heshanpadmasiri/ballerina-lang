import ballerina/io;

function f1() returns string|error => "test";

service class HelloService {
    resource function get hello() returns string|error? {
        string abc = check f1();
        if abc != "" { return abc; }
        return ();
    }
}

public function main() {
    boolean emitNoOutput = false;
    if emitNoOutput {
        io:println(());
    }
}
