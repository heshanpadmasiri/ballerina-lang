import ballerina/io;

public function main() {
    int[] arr = [];
    io:println(arr[0]); // @panic
}
