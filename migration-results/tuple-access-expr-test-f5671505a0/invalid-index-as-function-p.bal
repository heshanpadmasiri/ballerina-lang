import ballerina/lang.'int as ints;

// @args ["-1"]
public function main(string key) {
    [string, float, boolean] tuple = ["string", 9.0, true];
    int index = getKey(key);
    var result = tuple[index]; // @panic
    _ = result;
}

function getKey(string key) returns int {
    int|error index = ints:fromString(key);
    if index is error {
        return -1;
    }
    return index;
}
