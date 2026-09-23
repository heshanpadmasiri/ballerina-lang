function recursiveFunction() {
    recursiveFunction(); // @panic
}

function testStackOverflowInFunction() {
    recursiveFunction();
}

public function main() {
    testStackOverflowInFunction();
}
