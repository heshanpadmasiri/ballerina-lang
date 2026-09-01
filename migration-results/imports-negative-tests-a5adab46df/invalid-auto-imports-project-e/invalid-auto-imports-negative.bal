import ballerina/lang.'decimal as 'xml;
import ballerina/lang.'int as 'error;
import ballerina/lang.'float as 'object;

function testConcat() returns xml {
    xml x = xml `<hello>xml content</hello>`;
    return 'xml:concat(x, "Hello", "hello from String"); // @error
}

class CustomListener {
    *'object:Listener; // @error

    public function attach(service object {} s, string[]? name) returns error? {
    }

    public function detach(service object {} s) returns error? {
    }

    public function 'start() returns error? {
    }

    public function gracefulStop() returns error? {
    }

    public function immediateStop() returns error? {
    }
}

function testErrorStackTrace('error:CallStackElement elem) returns string { // @error
    return elem.callableName + ":" + elem.fileName;
}
