Listener|Listener2|error l1 = new Listener();
listener l2 = l1; // @error

listener l3 = new Listener2(); // @error
listener Listener2 l4 = new(); // @error

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

    public function detach(service object {} s) returns error? {
    }

    public function 'start() returns error? {
    }

    public function gracefulStop() returns error? {
    }

    public function immediateStop() returns error? {
    }
}
