type AllFloatNonZero 1.0|3.143;

public function main() {
    AllFloatNonZero[] arr = [];
    arr[1] = 1.0; // @panic
}
