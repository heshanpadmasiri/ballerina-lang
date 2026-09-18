public listener ABCD ep = new ABCD();
public listener ep1 = new ABCD();
listener ep2 = new ABCD();

int startCount = 0;

public class ABCD {
    public function 'start() returns error? {
        startCount += 1;
    }

    public function gracefulStop() returns error? {}

    public function immediateStop() returns error? {}

    public function attach(service object {} s, string[]|string? name = ()) returns error? {}

    public function detach(service object {} s) returns error? {}
}

service /sampleService1 on ep {
    resource function get foo(string b) {
    }

    resource function get bar(string b) {
    }
}

service /sampleService2 on ep1 {
    resource function get foo(string b) {}
}

service /sampleService3 on ep2 {
    resource function get foo(string b) {}
}

function init() returns error? {
    check ep.start();
    check ep1.start();
    check ep2.start();
    if (startCount != 3) {
        panic error("Started listener count differ");
    }
}
