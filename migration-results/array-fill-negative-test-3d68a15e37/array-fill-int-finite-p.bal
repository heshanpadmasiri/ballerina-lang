type AllIntNonZero 1|2|3;

public function main() {
    AllIntNonZero[] arr = [];
    arr[1] = 1; // @panic
}
