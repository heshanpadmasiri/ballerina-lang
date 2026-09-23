import ballerina/http;

service /helloWorld on new http:Listener(9090) {
    resource function get sayHelloWithString(int x) returns error? {
        return x; // @error
    }

    resource function get sayHelloWithInt(string x) returns () {
        return x; // @error
    }

    resource function get sayHelloWithNil(string x) {
        return x; // @error
    }
}

type Config record {};

class DummyEndpoint {
    function _init_(Config conf) {}
}

class DummyService {
    function getEndpoint() returns DummyEndpoint {
        DummyEndpoint ep = new;
        return ep;
    }
}
