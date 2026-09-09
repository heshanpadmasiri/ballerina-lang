import ballerina/io;

type first record {
    int|error f0 = 1;
    int|error f00 = 2;
};

public type secondRec record {
    first|error f1;
    first|error f2;
};

public function main() {
    (int|error)[] results = getFieldProjections(testStrand());
    int[] values = [];
    error[] errors = [];
    foreach int|error value in results {
        if value is int {
            values.push(value);
        } else {
            errors.push(value);
        }
    }

    io:println(values[0]); // @output 3
    io:println(values[1]); // @output 3
    io:println(errors[0]); // @output error("multiple waits on the same future is not allowed")
    io:println(errors[1]); // @output error("multiple waits on the same future is not allowed")
}

function getFieldProjections(secondRec result) returns (int|error)[] {
    first f1 = checkpanic result.f1;
    first f2 = checkpanic result.f2;
    return [f1.f0, f1.f00, f2.f0, f2.f00];
}

public function testStrand() returns secondRec {
    future<int|error> f0 = start add(1, 2);
    future<int|error> f00 = start add(1, 2);
    future<first> f1 = @strand {thread: "any"} start concat(f0, f00);
    future<first> f2 = @strand {thread: "any"} start concat(f0, f00);
    secondRec result = wait {f1, f2};
    return result;
}

function add(int i, int j) returns int {
    int k = i + j;
    int l = 0;
    while l < 9999999 {
        l += 1;
    }
    return k;
}

function concat(future<int|error> f0, future<int|error> f00) returns first {
    first result = wait {f0, f00};
    return result;
}
