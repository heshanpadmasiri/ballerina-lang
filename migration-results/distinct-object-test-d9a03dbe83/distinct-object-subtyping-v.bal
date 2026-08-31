import ballerina/io;

public type Status distinct object {
    public int code;
};

public type StatusCodeResponse record {|
    Status status;
|};

public type InternalServerErrorStatus object {
    *Status;
    public byte code;
};

type InternalServerErrorStatusImmut readonly & object {
    *Status;
    public byte code;
};

public type InternalServerError record {|
    *StatusCodeResponse;
    InternalServerErrorStatus status = object {
        public byte code = 101;
    };
|};

public function testDistinctObjectSubtyping() {
    InternalServerErrorStatus x = object {
        public byte code = 101;
    };
    Status y = x;

    InternalServerError k = {};

    if !(y is InternalServerErrorStatus) {
        panic error(
           string `Expected a value of type: ${InternalServerErrorStatus.toString()}, found: ${(typeof y).toString()}`);
    }

    if k.status.code != 101 {
        panic error("Expected: 101, found: " + k.status.code.toString());
    }

    y = object InternalServerErrorStatusImmut {
        public byte code = 102;
    };

    if y.code != 102 {
        panic error("Expected: 102, found: " + y.code.toString());
    }
}

function printNoAssertedValues() {
    io:println();
}

public function main() {
    testDistinctObjectSubtyping();
}
