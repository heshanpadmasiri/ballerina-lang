listener Listener lis = new Listener(port);
string b7a = "b7a";

int port = o.p; // @error

Obj o = new();
string str = "";
int p = port;

service /hello on new Listener(8080) {

    function init() {
        str = b7a;
    }

    resource function get hello() {

        Response response = new;
        response.setTextPayload(str);
    }
}

class Obj {
    string str;
    int p = port;

    function init() {
        self.str = b7a;
    }
}

class Response {
    string text = "";

    function setTextPayload(string str) {
        self.text = str;
    }
}

class Listener {
    public function init(int port) {
    }

    public function attach(service object {} s, string|string[]? name = ()) returns error? {
        return;
    }

    public function detach(service object {} s) returns error? {
        return;
    }

    public function 'start() returns error? {
        return;
    }

    public function gracefulStop() returns error? {
        return;
    }

    public function immediateStop() returns error? {
        return;
    }
}
