import ballerina/io;
import ErrorMatchProject.module1;

type FooError error<record {|string msg; boolean fatal = false;|}>;

function errorMatchWithQualifiedReference(error e) returns int {
    match e {
        error(module1:ERROR_MESSAGE_1) => { return 1; }
        error(module1:ERROR_MESSAGE_2) => { return 2; }
        error(module1:ERROR_MESSAGE_3) => { return 3; }
        error(module1:ERROR_MESSAGE_4, error(module1:ERROR_MESSAGE_3)) => { return 4; }
        error(_, msg = module1:ERROR_MESSAGE_4, fatal = module1:DEFAULT_FATAL_STATUS) => { return 5; }
    }
    return 0;
}

function testErrorMatchWithQualifiedReference() {
    io:println(errorMatchWithQualifiedReference(error("OMG!"))); // @output 1
    io:println(errorMatchWithQualifiedReference(error(module1:ERROR_MESSAGE_2))); // @output 2
    io:println(errorMatchWithQualifiedReference(error("SOMETHING'S WRONG!"))); // @output 3
    io:println(errorMatchWithQualifiedReference(error("OH, NO!", error("SOMETHING'S WRONG!")))); // @output 4
    FooError err5 = error("ERROR!", msg = "OH, NO!", fatal = false);
    io:println(errorMatchWithQualifiedReference(err5)); // @output 5
    FooError err6 = error("ERROR!", msg = "OH, NO!", fatal = true);
    io:println(errorMatchWithQualifiedReference(err6)); // @output 0
    io:println(errorMatchWithQualifiedReference(error("ERROR!"))); // @output 0
}

public function main() {
    testErrorMatchWithQualifiedReference();
}
