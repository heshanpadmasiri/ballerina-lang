function testNonInitArrayAccess() returns string {
    string[] fruits = [];
    return fruits[5]; // @panic
}

public function main() {
    string _ = testNonInitArrayAccess();
}
