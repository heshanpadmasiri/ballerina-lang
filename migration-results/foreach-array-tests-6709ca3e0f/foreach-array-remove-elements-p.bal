function testRemoveElementsWhileIterating() {
    int[] values = [1, 2, 3];
    foreach int _ in values { // @panic
        var _ = values.pop();
    }
}

public function main() {
    testRemoveElementsWhileIterating();
}
