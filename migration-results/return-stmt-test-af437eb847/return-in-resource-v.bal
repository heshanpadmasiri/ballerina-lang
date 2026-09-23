service object {} helloWorld = service object {
    resource function get sayHelloWithString(string x) returns error? {
        return error("dummy err");
    }

    resource function get sayHelloWithInt(int x) returns error? {
        return;
    }

    resource function get sayHelloWithNil1(string x) {
        return;
    }

    resource function get sayHelloWithNil2(string x) returns () {
        return;
    }
};

public function main() {
}
