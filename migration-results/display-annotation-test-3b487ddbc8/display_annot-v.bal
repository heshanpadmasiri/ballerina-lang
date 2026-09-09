// @unsupported The enabled positive assertions inspect compiler-internal AST nodes and their
// @unsupported annotation-expression rendering. These values, including attachment counts,
// @unsupported are unavailable to a Ballerina program at runtime.
import ballerina/jballerina.java;

@display {iconPath: "fooIconPath.icon", label: "Foo function"}
function foo(int i, string k) returns int {
    return i;
}

@display {iconPath: "barIconPath.icon", label: "Bar class"}
class Bar {
    @display {label: "k method"}
    function k() {
    }
}

@display {iconPath: "RecIcon.icon", label: "The main record!"}
type Rec record {|
    string s;
    int i;
|};

@display {iconPath: "service.icon", label: "service", "misc": "Other info"}
service on new Listener() {
    @display {iconPath: "k-func.icon", label: "k method"}
    function k() {
    }

    @display {iconPath: "k.icon", label: "resource method"}
    resource function get k() {
    }
}

class Listener {
    public function init() {
    }

    public function attach(service object {} s, string|string[]? name = ()) returns error? {
    }

    public function detach(service object {} s) returns error? {
    }

    public function 'start() returns error? {
    }

    public function gracefulStop() returns error? {
        return ();
    }

    public function immediateStop() returns error? {
        return ();
    }
}

@display {iconPath: "Config.icon", label: "RefreshTokenGrantConfig record"}
public type RefreshTokenGrantConfig record {|
    string refreshUrl;
    string refreshToken;
    string clientId;
    @display {iconPath: "Field.icon", label: "clientSecret field", kind: "password"}
    string clientSecret;
|};

function annotationOnWorker() {
    @display {
        label: "worker annotation",
        'type: "named",
        id: "hash"
    }
    worker testWorker {
    }
}

function testExternalFunction() = @display { label: "external", id: "hash" } external;

public function exit(int status) = @java:Method {'class: "java.lang.System", name: "exit"} external;

public function main() {
    exit(0);
}
