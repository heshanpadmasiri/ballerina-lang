function f2() returns string|error {
    return "test";
}

service on new Listener() {
    resource function say hello() {
        string abc = check f2(); // @error @error
        return;
    }
}

public class Listener {
    public isolated function 'start() returns error? {
    }

    public isolated function gracefulStop() returns error? {
    }

    public isolated function immediateStop() returns error? {
    }

    public isolated function detach(service object {} s) returns error? {
    }

    public isolated function attach(service object {} s, string[]|string? name = ()) returns error? {
    }
}
