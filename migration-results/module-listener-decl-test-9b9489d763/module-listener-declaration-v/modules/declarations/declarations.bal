Listener|Listener2|error l1 = new Listener();
listener l2 = l1;

listener l3 = new Listener();
listener Listener l4 = new();

class Listener {
    public function init() returns error? {
    }

    public function attach(service object {} s, string|string[]? name = ()) returns error? {
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

class Listener2 {
    public function init() returns error? {
        return error("hi");
    }

    public function attach(service object {} s, string|string[]? name = ()) returns error? {
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

listener lsn = object {
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

    public function init() returns error? {
        if (true) {
            return ();
        }
    }
};
